function SetSealParameter(DesignDataSection,name,value)

arguments (Input)
    DesignDataSection
    name  char
    value double
end

SealParReserved = evalin('base','Simulink.Parameter');
SealParReserved.DataType = 'double' ; 
SealParReserved.Value = value ; 
SealParReserved.StorageClass  = 'ExportedGlobal';

assignin(DesignDataSection,name,SealParReserved);    

assignin("base",name,SealParReserved);
evalin('base','clear SealParReserved'); 

end