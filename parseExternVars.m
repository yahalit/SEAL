function [types,vars] = parseExternVars(headerFile)
% PARSEEXTERNVARS  Extract extern variable declarations from a C header.
%   T = parseExternVars('seal.h')
%
%   Finds statements like:
%     extern uint16_T PutCounter;
%     extern volatile struct Foo *bar, baz[10];
%
%   Skips prototypes (anything with '(' before the semicolon).
%
%   Returns a table with: Line, BaseType, Name, PointerStars, Arrays, RawStatement.

txt = fileread(headerFile);

% --- Normalize newlines and remove comments (// and /* */) ---
txt = strrep(txt, sprintf('\r\n'), newline);
txt = strrep(txt, sprintf('\r'), newline);
txt = stripBlockAndLineComments(txt);

% --- Tokenize into C statements terminated by ';' while tracking line numbers ---
[stmts, startLines] = splitStatements(txt);

m = numel(stmts) ; 
types = cell(1,m) ; 
vars  = cell(1,m) ; 
nvars = 0 ; 

for i = 1:m
    st = strtrim(stmts{i});
    if isempty(st) || ~startsWith(st,"extern") && isempty(regexp(st,'^\s*extern\b','once'))
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
    if length( stsplit) ~= 3 || ~isequal(stsplit{1},'extern') 
        continue ; 
    end

    nvars = nvars + 1 ; 
    types{nvars}  = stsplit{2} ; 
    vars{nvars}  = stsplit{3} ;     
end
types = types(1:nvars); 
vars  = vars(1:nvars) ; 
end

% ---------- helpers ----------
function s = stripBlockAndLineComments(s)
    % remove /* ... */ across lines (non-greedy, can occur multiple times)
    s = regexprep(s, '/\*.*?\*/', ' ', 'dotall');
    % remove // ... end-of-line
    s = regexprep(s, '//[^\n]*', ' ');
    s = regexprep(s, '#[^\n]*', ' ');
end

function [stmts, startLines] = splitStatements(s)
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

