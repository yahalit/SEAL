%TODO (Boom) 
%- Check that all host data interfaces are there 
%- Check existance od Seal_Initialize and add its call 
%- Check that subsystem names include either IdleLoop or are called ISRxxxu

% -Compile code block as TI 
% - Store version data to compare with the drive

% Prepare a wrapper for the SEAL project 
CFile = "Seal.c"; 
HFile = "Seal.h"; 
EHFile = "ExternSeal.h"; 
ECFile = "ExternSeal.c"; 
CodeDir = evalin('base','cfg.CodeGenFolder') + "\Seal_ert_rtw";
BaseTs  = 50e-6 ; 

HFile= fullfile(CodeDir,HFile) ; 
CFile= fullfile(CodeDir,CFile) ; 
EHFile= fullfile(CodeDir,EHFile) ; 
ECFile= fullfile(CodeDir,ECFile) ; 


%% Look for all the variables defined in the h that have no declaration in the c
[U,V] = parseExternVars(HFile) ; 
[Ua,Va,Inda] = parseUndeclaredVars(CFile,U,V) ; 
U(Inda) = [] ; 
V(Inda) = [] ; 

[ints,idles,setups,exceptions,aborts] = scan_isr_idle(HFile,BaseTs) ;

lines = ["#ifndef EXTERN_SEAL_DEF_H"  ; ... 
         "#define EXTERN_SEAL_DEF_H"  ; ...
         "typedef const short unsigned * bPtr" ; 
         "const char unsigned GenesisVerse[] = ""In the beginning God created the heaven and the earth"";" ;  ...
         "#pragma DATA_SECTION (GenesisVerse,.DS_GENESIS_VERSE)" ] ; 

for cnt = 1:numel(U) 
    lines = [lines;U(cnt)+" "+V(cnt)+";" ] ; %#ok<*AGROW>
    % lines = [lines;"#pragma DATA_SECTION ("+U(cnt)+","+".DS_"+U(cnt)+")" ] ; 
end

InitializeLines = "(voidFunc) InitializeFuncs[8] = {(voidFunc)Seal_initialize,(voidFunc)NULL,(voidFunc)NULL,(voidFunc)NULL,(voidFunc)NULL,(voidFunc)NULL,(voidFunc)NULL,(voidFunc)NULL}; " ;
IdleLoopLines   = BuildFuncDeclare('IdleLoopFuncs',idles) ; 
ExceptionLines = BuildFuncDeclare('ExceptionFuncs' , exceptions)  ;
AbortLines = BuildFuncDeclare('AbortFuncs' , aborts)  ;
SetupLines      = BuildFuncDeclare('SetupFuncs',setups) ; 
IsrLines        = BuildFuncDeclare('IsrFuncs',ints) ; 




lptr =  ["const short unsigned * BufferPtrs[16] = {(bPtr)&G_DrvCommandBuf,(bPtr)&G_FeedbackBuf,(bPtr)&G_SetupReportBuf,(bPtr)&G_CANCyclicBuf_in,(bPtr)&G_CANCyclicBuf_out," + ...
         "(bPtr)&G_UartCyclicBuf_in,(bPtr)&G_UartCyclicBuf_out,(bPtr)&G_SEALVerControl,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};" ;  ...
         "#pragma DATA_SECTION (BufferPtrs,.DS_INTFC_PTRS)" ] ; 
         

lines = [lines ; InitializeLines ;IdleLoopLines ; IsrLines ; SetupLines ; AbortLines ; ExceptionLines ; lptr ; "#endif"] ;  


writelines(lines, EHFile);                 % overwrite or create


%% Write the C file 
% writelines(lines, ECFile);                 % overwrite or create

