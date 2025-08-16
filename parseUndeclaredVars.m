function [Ua,Va,Inda] = parseUndeclaredVars(CFile,U,V) 

txt = fileread(CFile);

% --- Normalize newlines and remove comments (// and /* */) ---
txt = strrep(txt, sprintf('\r\n'), newline);
txt = strrep(txt, sprintf('\r'), newline);
txt = stripBlockAndLineComments(txt);

% --- Tokenize into C statements terminated by ';' while tracking line numbers ---
stmts= splitStatements(txt);
Ua = U ; 
Va = V ; 
m = numel(stmts) ; 
Inda = zeros(1,m) ; 
nvars = 0 ; 

for i = m:-1:1
    st = strtrim(stmts{i});
    if isempty(st)
        continue;
    end

    % Skip function prototypes or function-pointer declarators (have '(')
    if contains(st, '(')
        continue;
    end

    % remove GCC-style attributes inline (non-greedy)
    st = regexprep(st, '__attribute__\s*\(\(.*?\)\)', ' ');
    st = regexprep(st, '__declspec\([^\)]*\)', ' ');

    stsplit = strsplit(st);
    if length( stsplit) < 2  
        continue ; 
    end
    

    nu = strcmp( stsplit{1},U) ;
    nv = find(strcmp( stsplit{2},V)) ;

    % disp(stsplit) ; 
    if  isscalar( nv)  
        nvars = nvars + 1 ; 
        Ua{nvars} = U{nv} ; 
        Va{nvars} = V{nv} ; 
        Inda(nvars) = nv ; 
    end
    
end
Ua = Ua(1:nvars); 
Va  = Va(1:nvars) ; 
Inda  = Inda(1:nvars) ; 
end


% ---------- helpers ----------
function s = stripBlockAndLineComments(s)
    % remove /* ... */ across lines (non-greedy, can occur multiple times)
    s = regexprep(s, '/\*.*?\*/', ' ', 'dotall');
    % remove // ... end-of-line
    s = regexprep(s, '//[^\n]*', ' ');
    s = regexprep(s, '#[^\n]*', ' ');
end

function [stmts] = splitStatements(s)
    % Assemble statements up to ';', track starting line numbers
    lines = regexp(s, '\n', 'split');
    in = "";
    stmts = {};
    startLines = [];
    curStart = 1;
    for i=1:numel(lines)
        L = string(lines{i});
        trimmed = strtrim(L);
        if strlength(in)==0 && trimmed==""  % skip leading blanks
            curStart = i+1;
            continue;
        end
        % Append a space (keeps tokens readable) and track start line
        if strlength(in)==0
            curStart = i;
        end
        in = in + " " + L;

        % Consume all semicolon-terminated chunks on this accumulated buffer
        while true
            idx = strfind(in,';');
            if isempty(idx), break; end
            cut = idx(1);
            stmt = extractBetween(in, 1, cut-1);
            stmts{end+1} = char(strtrim(stmt)); %#ok<AGROW>
            startLines(end+1) = curStart;      %#ok<AGROW>
            in = extractAfter(in, cut);
            in = strtrim(in);
            % next statement starts on the same physical line
            curStart = i;
        end
    end
    % Ignore trailing partial (no semicolon)
end

