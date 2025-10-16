function [ok,msg] = validateSealConfig(cfg)
%VALIDATESEALCONFIG  Quick schema checks for your SEAL JSON.
% Returns true if compatible; otherwise prints a message and returns false.

    ok = false;  % pessimistic default
    
    %--- helpers
    function tf = hasfield_s(s, f)
        tf = isstruct(s) && isfield(s, f);
    end

    function s = asString(x)
        if isstring(x), s = char(x); 
        elseif ischar(x), s = x;
        else, s = ''; 
        end
    end

    function [msg,ok] = fail(msg)
        msg = ['Incompatibility: \n', msg] ; 
        ok = false;
    end

    %--- basic presence
    msg = [] ; 
    if ~hasfield_s(cfg, "System")
        [msg,ok] = fail('Missing "System" block.'); return; end

    % test that all the required fields are there 
    req = {'CPU','NumberOfAxes','CAN','UART','EtherNet','EtherCAT'};
    missing = setdiff(req, fieldnames(cfg.System).');
    if ~isempty(missing)
        fail(sprintf('System is missing fields: %s', strjoin(missing,', '))); return;
    end

    % Sub-structs must be 1x1 struct
    subs = {'CAN','UART','EtherNet','EtherCAT'};
    for k = 1:numel(subs)
        s = cfg.System.(subs{k});
        if ~(isstruct(s) && isequal(size(s),[1 1]))
            fail(sprintf('System.%s must be a 1x1 struct.', subs{k})); return;
        end
    end    

    if ~hasfield_s(cfg.System, "CPU")
        [msg,ok] = fail('Missing "System.CPU".'); return; end
    if ~hasfield_s(cfg.System, "NumberOfAxes")
        [msg,ok] = fail('Missing "System.NumberOfAxes".'); return; end
    if ~isfield(cfg, "AxesData")
        [msg,ok] = fail('Missing "AxesData" array.'); return; end

    %--- CPU check
    cpu = asString(cfg.System.CPU.v);
    if ~strcmp(cpu, 'F29H85')
        [msg,ok] = fail(sprintf('CPU is "%s", expected "F29H85".', cpu)); return; end

    %--- NumberOfAxes matches AxesData length
    nAxes = double(cfg.System.NumberOfAxes.v);
    nData = numel(cfg.AxesData);
    if ~(isfinite(nAxes) && nAxes == nData)
        [msg,ok] = fail(sprintf('NumberOfAxes=%g does not match AxesData length=%d.', nAxes, nData)); 
        return; 
    end

    %--- AxesData indices are consecutive (accept 0..n-1 or 1..n)
    if nData == 0
        [msg,ok] = fail('AxesData is empty.'); return; 
    end
    try
        idx = arrayfun(@(a) double(a.Index.v), cfg.AxesData);
    catch
        [msg,ok] = fail('One or more AxesData entries missing numeric "Index".'); return;
    end
    seq0 = 0:(nData-1);
    seq1 = 1:nData;
    if ~(isequal(idx(:).', seq0) || isequal(idx(:).', seq1))
        [msg,ok] = fail(sprintf('AxesData.Index not consecutive. Got [%s], expected [%s] or [%s].', ...
            strjoin(string(idx),','), strjoin(string(seq0),','), strjoin(string(seq1),',')));
        return;
    end

    %--- All AxesData.Type are "FSISlave"
    try
        types = arrayfun(@(a) string(a.Type.v), cfg.AxesData);
    catch
        [msg,ok] = fail('One or more AxesData entries missing "Type".'); return;
    end
    if any(types ~= "FSISlave")
        bad = find(types ~= "FSISlave", 1, 'first');
        [msg,ok] = fail(sprintf('AxesData(%d).Type is "%s", expected "FSISlave".', bad, types(bad)));
        return;
    end

    % If we got here, all checks passed
    ok = true;
end
