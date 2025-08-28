%TODO (Boom) 
%- Check that all host data interfaces are there 
%- Check existance od Seal_Initialize and add its call 
%- Check that subsystem names include either IdleLoop or are called ISRxxxu

% -Compile code block as TI 
% - Store version data to compare with the drive

% Package all coder products for target use
PD = evalin('base','SealProjectDescriptor') ; % = struct('ModelName',ModelName,'HwTarget',"C28",'CodeGenFolder','AutoCode','RootDir',pwd) ; 

StartFolder = pwd ; 

targetFolder = fullfile(PD.RootDir,PD.CodeGenFolder + "\" + PD.ModelName + "_ert_rtw");
cd(targetFolder);
bi = load('buildInfo.mat');                         % gives you buildInfo
buildInfo = bi.buildInfo ; 
buildOpts = bi.buildOpts ; 
templateMakefile = bi.templateMakefile ; 

packNGo(buildInfo, ...
    'fileName', [PD.ModelName '_deploy.zip'], ...
    'packType','flat');                    % or 'hierarchical'

% Back to work directory 
cd(StartFolder) ; % PD.RootDir); 

% Set the files to the post proc folder 
PostProcDir = fullfile(PD.RootDir,'PostProc') ;
ClearFolderTree( PostProcDir) ; 
ZipFile   = fullfile(PD.RootDir,"AutoCode\" + PD.ModelName + "_deploy.zip") ;
CodeDir = fullfile(PD.RootDir,"AutoCode\" + "\Seal_ert_rtw");
unzip(ZipFile, PostProcDir);
% Deleta the main function 
MainName = fullfile(PD.RootDir,"PostProc\ert_main.c") ; 
ExtCodeName = fullfile(PD.RootDir,PD.ExternalCodeFolder) ; 
ExtEntries = dir(ExtCodeName);
ExtEntries = ExtEntries(~ismember({ExtEntries.name}, {'.','..'}));
for cnt = 1:numel(ExtEntries) 
    next = fullfile(PostProcDir,ExtEntries(cnt).name);
    delete( next ) ; 
end
delete(MainName) ; 
delete(PostProcDir+"\*.mat") ; 

% Prepare a wrapper for the SEAL project 
CFile = "Seal.c"; 
HFile = "Seal.h"; 
EHFile = "ExternSeal.h"; 
ECFile = "ExternSeal.c"; 

HFile= fullfile(PostProcDir,HFile) ; 
CFile= fullfile(PostProcDir,CFile) ; 
EHFile= fullfile(PostProcDir,EHFile) ; 
ECFile= fullfile(PostProcDir,ECFile) ; 


%% Look for all the variables defined in the h that have no declaration in the c
[U,V] = parseExternVars(HFile) ; 
[Ua,Va,Inda] = parseUndeclaredVars(CFile,U,V) ; 
U(Inda) = [] ; 
V(Inda) = [] ; 

[errmsg,ints,idles,setups,exceptions,aborts] = scan_isr_idle(HFile,PD.BaseTs,PD.ModelName) ;

if ~isempty(errmsg)
    error(errmsg);
else
    displayDiscoveredEntities(ints,idles,setups,exceptions,aborts); 
end


lines = ["#ifndef EXTERN_SEAL_DEF_H"  ;  
         "#define EXTERN_SEAL_DEF_H"  ; 
         "typedef const short unsigned * bPtr;";
"void (*InitFunc)(void)=Seal_initialize;";
"void (*SetupFunc)(void)="+setups(1).Func+";"];

for cnt = 1:numel(U) 
    lines = [lines;U(cnt)+" "+V(cnt)+";" ] ; %#ok<*AGROW>
    % lines = [lines;"#pragma DATA_SECTION ("+U(cnt)+","+".DS_"+U(cnt)+")" ] ; 
end

IdleLoopLines   = BuildFuncDeclare('IdleLoopFuncs',idles) ; 
ExceptionLines = BuildFuncDeclare('ExceptionFuncs' , exceptions)  ;
AbortLines = BuildFuncDeclare('AbortFuncs' , aborts)  ;
IsrLines        = BuildFuncDeclare('IsrFuncs',ints) ; 




lptr =  ["const short unsigned * BufferPtrs[16] = {(bPtr)&G_DrvCommandBuf,(bPtr)&G_FeedbackBuf,(bPtr)&G_SetupReportBuf,(bPtr)&G_pCANCyclicBuf_in,(bPtr)&G_pCANCyclicBuf_out," + ...
         "(bPtr)&G_pUartCyclicBuf_in,(bPtr)&G_pUartCyclicBuf_out,(bPtr)&G_SEALVerControl,0U,0U,0U,0U,0U,0U,0U,0U};"] ; 
         

lines = [lines ; IdleLoopLines ; IsrLines  ; AbortLines ; ExceptionLines ; lptr ; "#endif"] ;  


writelines(lines, EHFile);                 % overwrite or create

% Pass the files to the target
ClearFolderTree( PD.SealTargetSourceFolder) ; 
copyfile(PostProcDir, PD.SealTargetSourceFolder, 'f');

ExtCodeDir = fullfile(PD.RootDir,PD.ExternalCodeFolder) ;
ClearFolderTree( PD.SealExtTargetSourceFolder) ; 
copyfile(ExtCodeDir, PD.SealExtTargetSourceFolder, 'f');



%% Write the C file 
% writelines(lines, ECFile);                 % overwrite or create

