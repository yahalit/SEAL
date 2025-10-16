function busNames = buildTypedCfgBuses(sample, rootBusName)
% buildTypedCfgBuses(sample, rootBusName)
% Builds Simulink.Bus objects from a struct-of-structs where every leaf is:
%   struct('t', <type>, 'v', <value>)
% Rules:
%   - DataType is taken from leaf.t (with 'float' -> 'single', 'bool' -> 'boolean')
%   - Dimensions inferred from size(leaf.v) (scalar if empty)
%   - Nested structs => nested buses; struct arrays => array of that nested bus
%   - Non-leaf structs must be consistent across array elements (uses element(1) for schema)
%
% Returns cell array of created bus names and assigns them in base workspace.

    arguments
        sample (1,1) struct
        rootBusName (1,1) string = "RootBus_T"
    end

    registry = containers.Map('KeyType','char','ValueType','any');

    [~, registry] = makeBus(sample, char(rootBusName), registry);

    keysReg = registry.keys;
    for i = 1:numel(keysReg)
        assignin('base', keysReg{i}, registry(keysReg{i}));
    end
    busNames = keysReg(:);
    fprintf('Created %d bus object(s):\n', numel(busNames));
    disp(busNames);

    %---------------- helpers ----------------%
    function [busName, reg] = makeBus(s, proposedName, reg)
        busName = uniqueName(proposedName, reg);
        be = Simulink.BusElement.empty;

        fn = fieldnames(s);
        for k = 1:numel(fn)
            f = fn{k};
            v = s.(f);

            el = Simulink.BusElement;
            el.Name = f;

            if isLeaf(v)
                % Single typed leaf
                [dt, dims] = leafTypeAndDims(v);
                el.DataType = dt;
                el.Dimensions = dims;
                el.Complexity = 'real';

            elseif isstruct(v) && ~isscalar(v)
                % Struct array -> array of nested bus (use first element as schema)
                childName = childBusName(busName, f);
                [childBusNameOut, reg] = makeBus(v(1), childName, reg);
                el.DataType = ['Bus: ' childBusNameOut];
                el.Dimensions = size(v);

            elseif isstruct(v) && isscalar(v)
                % Nested scalar struct -> nested bus
                childName = childBusName(busName, f);
                [childBusNameOut, reg] = makeBus(v, childName, reg);
                el.DataType = ['Bus: ' childBusNameOut];
                el.Dimensions = 1;

            else
                % Defensive fallback: treat as a leaf with double(1)
                warning('Field %s.%s is not a typed leaf/struct; falling back to double(1).', busName, f);
                el.DataType = 'double';
                el.Dimensions = 1;
            end

            be(end+1,1) = el; %#ok<AGROW>
        end

        B = Simulink.Bus;
        B.Elements = be;
        reg(busName) = B;
    end

    function tf = isLeaf(x)
        tf = isstruct(x) && isscalar(x) && isfield(x,'t') && isfield(x,'v');
    end

    function [dt, dims] = leafTypeAndDims(leaf)
        % Normalize type tokens
        t = string(leaf.t);
        t = strtrim(lower(t));
        switch t
            case 'float'
                dt = 'single';
            case {'bool','boolean','logical'}
                dt = 'boolean';
            otherwise
                % Accept MATLAB numeric class names ('double','single','uint32', etc.)
                % Also allow 'string' and 'char' -> encode as uint8 vector
                dt = char(t);
        end

        v = leaf.v;
        if any(strcmp(dt, {'string','char'}))
            % Bus signals can't be variable-length text; encode as uint8[N]
            bytes = uint8(char(string(v)));
            dt = 'uint8';
            dims = size(bytes);
            if isempty(dims), dims = 1; end
            return;
        end

        if isempty(v)
            dims = 1;        % scalar
        else
            dims = size(v);  % keep shape (row/col vectors, matrices)
        end
    end

    function nm = childBusName(parent, field)
        nm = matlab.lang.makeValidName(sprintf('%s_%s_T', parent, field));
    end

    function nm = uniqueName(proposed, reg)
        nm = matlab.lang.makeValidName(proposed);
        base = nm; idx = 1;
        while isKey(reg, nm)
            nm = sprintf('%s_%d', base, idx); idx = idx+1;
        end
    end
end
