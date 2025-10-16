function [B_top, busVal] = cfg_to_bus(cfg, topBusName)
% cfg_to_bus  Build Simulink.Bus objects from a nested descriptor struct
% and produce a bus instance with values taken from cfg.*
%
% Returns:
%   B_top  - top-level Simulink.Bus object (also placed in base workspace)
%   busVal - MATLAB struct instance; if cfg is a struct array, busVal matches its size
%
% Types supported:
%   float/single, double, (u)int8/16/32/64,
%   bool/boolean/logical -> Bus:'boolean' ; Value: logical
%   string               -> Bus:uint8[1x32]; Value: char[1x32] (zero-padded/truncated)
%   date                 -> Bus:uint32 YYYYMMDD ; Value: uint32 YYYYMMDD
%
% Usage:
%   [CfgBus, cfg_val] = cfg_to_bus(cfg, 'CfgBus');

    if nargin < 2, topBusName = 'CfgBus'; end
    assert(isstruct(cfg), 'cfg must be a struct');
    topBusName = sanitizeName(topBusName);

    if isscalar(cfg)
        [~, busVal] = buildBusForStruct(cfg, topBusName);
    else
        % Top-level struct array: build schema from first element, then fill all
        [~, sampleVal] = buildBusForStruct(cfg(1), topBusName);
        busVal = repmat(sampleVal, size(cfg));
        for ii = 1:numel(cfg)
            [~, subVal] = buildBusForStruct(cfg(ii), topBusName);
            busVal(ii) = subVal;
        end
    end

    B_top = evalin('base', topBusName);
end

% ====== Internal helpers ======

function [busName, valOut] = buildBusForStruct(S, busName)
    % Build/assign a Bus for a scalar struct S, and return the valued MATLAB struct
    assert(isstruct(S) && isscalar(S), 'buildBusForStruct expects a scalar struct');

    fns = fieldnames(S);
    elems = repmat(Simulink.BusElement, numel(fns), 1);
    valOut = struct();

    for k = 1:numel(fns)
        f = fns{k};
        v = S.(f);

        elem = Simulink.BusElement;
        elem.Name = sanitizeName(f);
        elem.Complexity = 'real';
        elem.DimensionsMode = 'Fixed';
        elem.Min = [];
        elem.Max = [];
        elem.SamplingMode = 'Sample based';

        if isstruct(v) && all(ismember({'t','v'}, fieldnames(v)))
            % Leaf with type+value
            [busDT, dims, valCast] = mapTypedLeaf(v);
            elem.DataType   = busDT;
            elem.Dimensions = dims;
            valOut.(f) = valCast;

        elseif isstruct(v) && isscalar(v)
            % Nested scalar struct -> sub-bus
            subBusName = [sanitizeName(f) 'Bus'];
            [~, subVal] = buildBusForStruct(v, subBusName);
            elem.DataType   = ['Bus: ' subBusName];
            elem.Dimensions = 1;
            valOut.(f) = subVal;

        elseif isstruct(v) && ~isscalar(v)
            % Struct array -> array of sub-bus
            sz = size(v);
            subBusName = [sanitizeName(f) 'Bus'];
            [~, sampleVal] = buildBusForStruct(v(1), subBusName);
            elem.DataType   = ['Bus: ' subBusName];
            elem.Dimensions = sz;

            valOut.(f) = repmat(sampleVal, sz);
            for ii = 1:numel(v)
                [~, subVal] = buildBusForStruct(v(ii), subBusName);
                valOut.(f)(ii) = subVal;
            end

        elseif isnumeric(v) || islogical(v)
            % Raw numerics/logicals (rare in your cfg)
            elem.DataType   = class(v);
            elem.Dimensions = size(v);
            valOut.(f) = v;

        elseif isstring(v) || ischar(v)
            % Raw strings outside typed leaves: keep char[1x32] in value,
            % Bus carries uint8[1x32]
            ch = fixedLenChars(v, 32);
            elem.DataType   = 'uint8';
            elem.Dimensions = [1 32];
            valOut.(f) = ch;

        else
            error('Unsupported field "%s" of class %s', f, class(v));
        end

        elems(k) = elem;
    end

    B = Simulink.Bus;
    B.Elements = elems;
    assignin('base', busName, B);
end

function [busDT, dims, vcast] = mapTypedLeaf(leaf)
    % Map leaf.t (string/char) to Simulink bus dtype and MATLAB value (vcast)
    t = lower(string(leaf.t));

    switch t
        case {'float','single'}
            busDT = 'single';

        case {'double'}
            busDT = 'double';

        case {'int8','uint8','int16','uint16','int32','uint32','int64','uint64'}
            busDT = char(t);

        case {'bool','boolean','logical'}
            % Simulink bus wants 'boolean'; MATLAB value should be logical
            busDT = 'boolean';
            vcast = logical(leaf.v);
            dims  = size(vcast);
            if isempty(dims), dims = 1; end
            return;

        case {'string'}
            % Bus carries bytes; value keeps fixed-length char row
            busDT = 'uint8';
            dims  = [1 32];
            vcast = fixedLenChars(leaf.v, 32);
            return;

        case {'date'}
            busDT = 'uint32';
            vcast = encodeDate32(leaf.v);   % preserves shape
            dims  = size(vcast);
            if isempty(dims), dims = 1; end
            return;

        otherwise
            error('Unsupported type "%s". Extend mapTypedLeaf().', t);
    end

    % Generic numeric casting path (non-string/date/boolean)
    v = leaf.v;
    if isstring(v), v = char(v); end
    if ischar(v)
        % Only allowed for 'string' (handled above) or 'date' (handled in encode)
        error('Char initializers only supported for type "string" or "date".');
    end
    try
        vcast = cast(v, busDT);
    catch ME
        error('Cannot cast value to %s: %s', busDT, ME.message);
    end
    dims = size(vcast);
    if isempty(dims), dims = 1; end
end

function ch = fixedLenChars(val, N)
    % Return char row of length N, padded with char(0)
    if isstring(val), val = char(val); end
    if isnumeric(val) || islogical(val)
        val = char(uint8(val));
    elseif ~ischar(val)
        error('Cannot convert value of class %s to fixed-length char', class(val));
    end
    ch = val(:).';         % row
    L  = numel(ch);
    if L >= N
        ch = ch(1:N);
    else
        ch = [ch repmat(char(0), 1, N-L)];
    end
end

function u = encodeDate32(val)
% Encode to uint32 YYYYMMDD; supports arrays of datetime/strings/numerics.
    if isa(val, 'datetime')
        y = year(val); m = month(val); d = day(val);
        u = uint32(y.*10000 + m.*100 + d); return;
    end
    if isstring(val) || ischar(val)
        try
            dt = datetime(val, 'InputFormat','yyyy-MM-dd');
        catch
            dt = datetime(val); % best-effort
        end
        y = year(dt); m = month(dt); d = day(dt);
        u = uint32(y.*10000 + m.*100 + d); return;
    end
    if isnumeric(val)
        u = uint32(val);
        y = floor(double(u)/10000);
        m = floor((double(u) - y*10000)/100);
        d = double(u) - y*10000 - m*100;
        if any(y < 1900 | y > 9999 | m < 1 | m > 12 | d < 1 | d > 31)
            error('Numeric date must be YYYYMMDD within valid ranges.');
        end
        return;
    end
    error('Unsupported date value of class %s', class(val));
end

function nm = sanitizeName(nm)
    nm = regexprep(nm, '[^\w]', '_');
    if ~isempty(nm) && isstrprop(nm(1),'digit'), nm = ['f_' nm]; end
end
