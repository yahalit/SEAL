function [errmsg,ints,idles,setups,exceptions,aborts] = scan_isr_idle(headerFile,BaseTs,modelname )

errmsg = [] ; 
typestr = struct('E_Func_Initializer',1,'E_Func_Idle',2,'E_Func_ISR',3,'E_Func_Setup',4,'E_FuncException',5,'E_FuncAbort',7) ; 

txt = fileread(headerFile);

% --- Normalize newlines and remove comments (// and /* */) ---
txt = strrep(txt, sprintf('\r\n'), newline);
txt = strrep(txt, sprintf('\r'), newline);
txt = stripBlockAndLineComments(txt);

% --- Tokenize into C statements terminated by ';' while tracking line numbers ---
[stmts, ~] = splitStatements(txt);

m = numel(stmts) ; 
FuncArraySize = 8 ; 
ints(FuncArraySize,1) = struct('Func', [],'Type',[], 'Ts', [],'nInts',[],'Priority',[]);
[ints.Func] = deal("NULL");   % same function handle for all
[ints.nInts]   = deal(16); 
[ints.Ts]      = deal(1e-4); 
[ints.Type]    = deal(0); 
[ints.Priority] = deal(0) ; 

idles  = ints;
setups = idles ; 
exceptions = idles ; 
aborts = idles ; 
nint = 0 ; 
nidle = 0 ; 
nsetup = 0 ; 
nexception = 0 ; 
nabort = 0 ; 
InitializeDetected = 0 ;
ExpectedInitializeName = modelname+"_initialize" ; 
for i = 1:m
    st = strtrim(stmts{i});
    if isempty(st) || ~startsWith(st,"extern") && isempty(regexp(st,'^\s*extern\b','once'))
        continue;
    end


    % remove GCC-style attributes inline (non-greedy)
    st = regexprep(st, '__attribute__\s*\(\(.*?\)\)', ' ');
    st = regexprep(st, '__declspec\([^\)]*\)', ' ');

    % Space round parantheses 
    st = strrep ( st ,'(',' (');
    st = strrep ( st ,';',' ;');

    stsplit = strsplit(st);
    % if length( stsplit) ~= 3 || ~isequal(stsplit{1},'extern') 
    %     continue ; 
    % end
    % disp( stsplit) 
    if numel(stsplit) >= 4 && isequal( stsplit{1} ,'extern' ) && isequal( stsplit{2} ,'void' ) && isequal( stsplit{4} ,'(void)' ) 
        name = stsplit{3} ; 
        if startsWith( upper(name) , 'ISR')  
            if ( ~contains(name,'u')) || (length(name)<5 )
                errmsg = ([st,' : Suspect wanabee ISR, will not be taken']) ; 
                return ; 
            else
                place = strfind(name,'u') ; 
                place = place(1) ; 
                TsChar = strrep( name(4:place-1),'_','.') ;
                TsChar = strrep( TsChar,'p','.') ;

                try
                    Ts = str2double(TsChar) * 1e-6  ;
                catch
                    errmsg = ([st,' : Bad formatted sampling time ,ISR will not be taken']) ; 
                end
                [nIntsOverBase,ok] = GetMultiple( Ts, BaseTs ) ; 
                if ok == 0 
                    errmsg = ([st,' : Suspect wanabee ISR, invalid sampling time, will not be taken']) ; 
                    return ; 
                else
                    nint = nint + 1 ; 
                    if ( nint <= FuncArraySize )
                        ints(nint)  = struct('Func',name,'Ts',Ts,'nInts',nIntsOverBase,'Type',typestr.E_Func_ISR ,'Priority' , FuncArraySize+1 - nint)   ;  
                    else
                        errmsg = ([st,' : Too many ISR routines (limit of 8)']) ; 
                        return ;
                    end
                end 
            end
        elseif startsWith( upper(name) , 'IDLELOOP')  
            nidle = nidle + 1 ; 
            if ( nidle <= FuncArraySize )
                idles(nidle)  = struct('Func',name ,'Type',typestr.E_Func_Idle, 'Ts', [],'nInts',[],'Priority' , FuncArraySize+1  - nidle)  ;
            else
                errmsg = ([st,' : Too many Idle loop routines (limit of 8)']) ; 
                return ; 
            end
        elseif startsWith( upper(name) , 'SETUP')  
            nsetup = nsetup + 1 ; 
            if ( nsetup <= 1 )
            setups(nsetup)  =  struct('Func',name,'Type',typestr.E_Func_Setup, 'Ts', [],'nInts',[],'Priority' , FuncArraySize+1  - nsetup )   ;
            else
                errmsg = ([st,' : Too many setup loop routines (limit of 8)']) ; 
                return ; 
            end
        elseif startsWith( upper(name) , 'EXCEPTION')  
            nexception = nexception + 1 ; 
            if ( nexception <= FuncArraySize )
                exceptions(nexception)  =  struct('Func',name ,'Type',typestr.E_FuncException, 'Ts', [],'nInts',[],'Priority' , FuncArraySize+1  - nexception)   ;
            else
                errmsg = ([st,' : Too many exception routines (limit of 8)']) ; 
                return ;
            end
        elseif startsWith( upper(name) , 'ABORT')  
            nabort = nabort + 1 ; 
            if ( nabort <= FuncArraySize )
                aborts(nabort)  =  struct('Func',name,'Type',typestr.E_FuncAbort , 'Ts', [],'nInts',[],'Priority' , FuncArraySize+1  - nabort)   ;
            else
                errmsg = ([st,' : Too many abort routines (limit of 8)']) ; 
                return ; 
            end
        else
            if isequal( string(name),  ExpectedInitializeName) 
                InitializeDetected = 1 ; 
            else
                errmsg = (st+" : Unidentified function for the seal.") ; 
                return ;             
            end
        end 
    end

end
% If no setup function is defined, define an empty one 
if ( nsetup == 0 )
     nsetup = 1;
     setups(nsetup)  =  struct('Func',SetupEmpty,'Type',typestr.E_Func_Setup, 'Ts', [],'nInts',[],'Priority' , FuncArraySize+1  - nsetup )   ;
end

if ( InitializeDetected == 0 )
    errmsg = (ExpectedInitializeName+" : Expected initializer not found.") ; 
    return ;             
end


% Fix the priority of interrupt services 
%if nint 
if nint
    intsub = ints(1:nint);
    n = [intsub.nInts]; 
    p = [intsub.Priority] ; 
    nu = unique(n) ; 
    NextPri = FuncArraySize ;
    start   = 1 ; 
    for cnt = 1:length(nu) 
        ind    = find(n==nu(cnt)) ; 
        indlen = length(ind) ; 
        pind = p(ind) ;
        [~,ip] = sort(pind) ; 
        isub1 = intsub(ind(ip)) ; 
        for c1 = 1:indlen
            isub1(c1).Priority = NextPri ; 
            NextPri = NextPri - 1 ; 
        end
        ints(start:start+length(ind)-1) = isub1 ; 
        start = start + indlen ; 
    end
end
%end


    % nvars = nvars + 1 ; 
    % types{nvars}  = stsplit{2} ; 
    % vars{nvars}  = stsplit{3} ;     
end

function [nInts,ok] = GetMultiple( Ts, BaseTs ) 

    ok = 1 ; 
    quo =  Ts / BaseTs  ; 
    nInts = fix(quo + 0.001);
    if (nInts < 1 || abs (quo - nInts) > 0.001 )
        ok = 0 ; 
    end
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

