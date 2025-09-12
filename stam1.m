
headerPath = "C:\Projects\SEAL\SealRelease\AutoCode\Seal_ert_rtw\Seal.h";
structName = 'PosProfilerState_T'; 
outCPath   = 'Stam.c' ; 
opts = struct('arrayFieldMode' ,'elementwise') ; %'whole-field-if-any') ;
routineName = ['Protect',structName];
fields = emit_change_function(headerPath, structName, outCPath, routineName, opts);