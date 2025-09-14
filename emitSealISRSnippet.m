function emitSealISRSnippet(pba, outFile,headerPath,opts)
% emitSealISRSnippet  Generate C snippet file with PreISR/PostISR routines.
%
% Usage:
%   emitSealISRSnippet(SealProjectDescriptor.ProtectedBusArray, 'SealISR.c')
if nargin < 4 
    opts = [] ; 
end

if nargin < 2
    error('You must supply output file name as second argument.');
end

% Basic validation
need = {'Name','Type','Initializer','DataStoreName'};
for f = need
    if ~isfield(pba, f{1})
        error('ProtectedBusArray is missing field "%s".', f{1});
    end
end

% open file
fid = fopen(outFile,'w');
assert(fid>0,'Cannot open %s for write', outFile);

fprintf(fid, "/* Auto-generated ISR swap snippet */\n\n");

for k = 1:numel(pba)
    type = string( cIdent(pba(k).Type)) ;
    routineName = "Protect" + type;
    emit_change_function(fid , headerPath, type, routineName, opts);
    fprintf(fid, "\n");
end
fprintf(fid, "\n\n\n");


fprintf(fid, "/* Entry & Exit routines */\n\n");

% Define helper pointer variables
fprintf(fid, "// Pointer definitions \n");
for k = 1:numel(pba)
    type = string( cIdent(pba(k).Type)) ;
    % ds   = cIdent(pba(k).DataStoreName);
    rt_name = type+"RT" ; 
    bgin_name = type+"BG_in" ; 
    bgout_name = type+"BG_out" ; 
    backup_name = type+"BG_Backup" ; 

    fprintf(fid, "%s  %s ;\n", type , rt_name);
    fprintf(fid, "%s  %s ;\n", type , bgin_name);
    fprintf(fid, "%s  %s ;\n", type , bgout_name);
    fprintf(fid, "%s  %s ;\n", type , backup_name);
    fprintf(fid, "\n\n\n");
end

% Seal pointer initialization 
fprintf(fid, "void SealPointerInit(void)\n{\n");
for k = 1:numel(pba)
    type = string( cIdent(pba(k).Type)) ;
    ds   =  string(pba(k).DataStoreName);
    rt_name = type+"RT" ; 
    bgin_name = type+"BG_in" ; 
    bgout_name = type+"BG_out" ; 
    backup_name = type+"BG_Backup" ;
    initname    = string(pba(k).Initializer) ; 

    fprintf(fid, "    %s = &%s ;\n", ds , bgin_name);
    fprintf(fid, "    %s = %s ;\n", backup_name,bgin_name);
    
    fprintf(fid, "    %s = %s ;\n", bgin_name,initname);
    fprintf(fid, "    %s = %s ;\n", bgout_name,initname);
    fprintf(fid, "    %s = %s ;\n", rt_name,initname);
    fprintf(fid, "\n");
end
fprintf(fid, "}\n\n\n\n");




% PreISR
fprintf(fid, "void PreISR(void)\n{\n");
for k = 1:numel(pba)
    name = cIdent(pba(k).Name); %#ok<NASGU>
    type = cIdent(pba(k).Type);
    ds   = cIdent(pba(k).DataStoreName);
    bk   = sprintf("p%s_Backup", type);

    fprintf(fid, "    /* %s : %s */\n", pba(k).Name, pba(k).Type);
    fprintf(fid, "    %s = %s;\n", bk, ds);
    fprintf(fid, "    %s = &%sRT;\n", ds, type);
    fprintf(fid, "\n");
end
fprintf(fid, "}\n\n");

% PostISR
fprintf(fid, "void PostISR(void)\n{\n");
for k = 1:numel(pba)
    name = cIdent(pba(k).Name); %#ok<NASGU>
    type = cIdent(pba(k).Type);
    ds   = cIdent(pba(k).DataStoreName);
    bk   = sprintf("p%s_Backup", type);

    fprintf(fid, "    /* %s : %s */\n", pba(k).Name, pba(k).Type);
    fprintf(fid, "    %s = %s;\n", ds, bk);
    fprintf(fid, "\n");
end
fprintf(fid, "}\n\n\n");

fprintf(fid, "void PreIdle(void)\n{\n");
fprintf(fid, "short unsigned mask ;\n");

for k = 1:numel(pba)
    name = cIdent(pba(k).Name); %#ok<NASGU>
    type = string( cIdent(pba(k).Type)) ;
    % ds   = cIdent(pba(k).DataStoreName);
    rt_name = type+"RT" ; 
    bgin_name = type+"BG_in" ; 
    bgout_name = type+"BG_out" ; 
    
    fprintf(fid, "    mask = BlockInts();\n");
    fprintf(fid, "    %s = %s;\n", bgin_name, rt_name);
    fprintf(fid, "    RestoreInts(mask);\n");
    fprintf(fid, "    %s = %s;\n", bgout_name, bgin_name ) ;

    fprintf(fid, "\n");
end


fprintf(fid, "}\n\n\n\n");


fprintf(fid, "void PostIdle(void)\n{\n");
fprintf(fid, "short unsigned mask ;\n");

for k = 1:numel(pba)
    name = cIdent(pba(k).Name); %#ok<NASGU>
    type = string( cIdent(pba(k).Type)) ;
    % ds   = cIdent(pba(k).DataStoreName);
    rt_name = type+"RT" ; 
    bgin_name = type+"BG_in" ; 
    bgout_name = type+"BG_out" ; 
    
    fprintf(fid, "    mask = BlockInts();\n");
    fprintf(fid, "    Protect%s( &%s  ,  &%s  , &%s ); \n",type,bgin_name,bgout_name,rt_name);
    fprintf(fid, "    RestoreInts(mask);\n");

    fprintf(fid, "\n");
end


fprintf(fid, "}\n");



fclose(fid);
fprintf(1,"Generated %s\n", outFile);

end

% ---- helper ----
function s = cIdent(s)
s = regexprep(char(s), '[^A-Za-z0-9_]', '_');
if isempty(s)
    s = 'X';
elseif ~isletter(s(1)) && s(1)~='_'
    s = ['_', s];
end
end
