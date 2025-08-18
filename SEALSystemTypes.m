function SEALSystemTypes(DataDictionary) 
% function SEALSystemTypes(DataDictionary) 
% Define the driver interface busses. 
% DataDictionary: a handle to an open SLDD data
% At the end, data is udated into the SLDD file.


dataSection = getSection(DataDictionary,'Design Data');

%% Define version control
velems(3,1) =Simulink.BusElement ;
velems(1) = SetBusElement('Version','uint16',"SEAL database version" ) ; 
velems(2) = SetBusElement('SubVersion','uint16',"SEAL database sub version" ) ; 
velems(3) = SetBusElement('UserData','uint32',"SEAL database support data" ) ; 
VersionControlStruct = LogBusInSLDD(DataDictionary,  'SEALVerControl' , velems) ;

VersionControlStruct.Version = 1 ; 
VersionControlStruct.SubVersion = 1 ; 
VersionControlStruct.UserData = 0 ; 
SEALVerControl_init = Simulink.Parameter;
SEALVerControl_init.DataType = 'Bus: SEALVerControl';
SEALVerControl_init.Value     = VersionControlStruct ;
SEALVerControl_init.StorageClass  = 'ExportedGlobal';

assignin(dataSection,'SEALVerControl_init',SEALVerControl_init);    
LogSignalInSLDD(dataSection, 'SEALVerControl' , 'G_SEALVerControl','ExportedGlobal' ) ; 


%% Define UART related interface 

%% UART Communication bus
elems(5,1) =Simulink.BusElement ;
elems(1) = SetBusElement('PutCounter','uint16',"The place in the UARTQueue where next character is to be put" ) ; 
elems(2) = SetBusElement('FetchCounter','uint16',"The location in the UARTQueue of the next character to read" ) ; 
elems(3) = SetBusElement('UartError','uint16',"UART error" ) ; 
elems(4) = SetBusElement('TxFetchCounter','uint16',"The location in the TX UARTQueue of the next character to read" ) ; 
elems(5) = SetBusElement('UARTQueue','uint16',"Software Queue for incoming UART characters" ,[1 256]) ; 

LogBusInSLDD(DataDictionary,  'UartCyclicBuf' , elems) ;


%% UART buffer signals
LogSignalInSLDD(dataSection, 'UartCyclicBuf' , 'G_UartCyclicBuf_in') ; 
LogSignalInSLDD(dataSection, 'UartCyclicBuf' , 'G_UartCyclicBuf_out') ; 

%% Text interpreter
telems(9,1) =Simulink.BusElement ;
telems(1) = SetBusElement('IsGetFunc','uint16',"1 if this is a get function" ) ; 
telems(2) = SetBusElement('TempString','uint16',"Temporary string to hold characters extracted from the cyclical buffer" ,[1 64]) ; 
telems(3) = SetBusElement('InterpretError','uint16',"String formatting error" ) ; 
telems(4) = SetBusElement('cnt','uint16',"In string counter" ) ; 
telems(5) = SetBusElement('Argument','double',"Argument of a set function" ) ; 
telems(6) = SetBusElement('State','uint16',"State of the interpreting process" ) ; 
telems(7) = SetBusElement('NewString','uint16',"Indicate a new string is available" ) ; 
telems(8) = SetBusElement('MnemonicIndex','uint16',"Mnemonic index" ) ; 
telems(9) = SetBusElement('ArrayIndex','uint16',"Array index" ) ; 

LogBusInSLDD(DataDictionary,  'MicroInterp' , telems) ;
LogSignalInSLDD(dataSection, 'MicroInterp' , 'G_MicroInterp','ImportedExtern') ; 


%% Define CAN interfaces 

%% CAN communication bus 
celems(7,1) =Simulink.BusElement ;
celems(1) = SetBusElement('PutCounter','uint16',"The place in the CANQueue where the next message is to be put" ) ; 
celems(2) = SetBusElement('FetchCounter','uint16',"The location in the CANQueue of the next message to read" ) ; 
celems(3) = SetBusElement('CANError','uint16',"CAN error" ) ; 
celems(4) = SetBusElement('CANQueue','uint32',"Software Queue for incoming CAN messages" ,[128,2]) ; 
celems(5) = SetBusElement('TxFetchCounter','uint16',"The location in the CANQueue of the next message to transmit" ) ; 
celems(6) = SetBusElement('CANID','uint32',"Can ID, 11 or 29bit" ,[64,1]) ; 
celems(7) = SetBusElement('DLenAndAttrib','uint16',"Data length and attributes" ,[64,1]) ; 

LogBusInSLDD(DataDictionary,  'CANCyclicBuf' , celems) ;


%% CAN buffer signals
LogSignalInSLDD(dataSection, 'CANCyclicBuf' , 'G_CANCyclicBuf_in') ; 
LogSignalInSLDD(dataSection, 'CANCyclicBuf' , 'G_CANCyclicBuf_out') ; 


%% System level reports 
nSetupElements = 24 ; 
suelems(nSetupElements,1) =Simulink.BusElement ;

for cnt = 1:nSetupElements , suelems(cnt) = SetBusElement(['Spare_',num2str(cnt)],'int32',"Spare : " + num2str(cnt)  ) ; end 
suelems(1)  = SetBusElement('MaximumPositionReference','double',"Maximum position referece" ) ;
suelems(2)  = SetBusElement('MinimumPositionReference','double',"Minimum position reference" ) ;
suelems(3)  = SetBusElement('HighPositionException','double',"High position value that causes an exception " ) ;
suelems(4)  = SetBusElement('LowPositionException','double',"Low position value that causes an exception " ) ;
suelems(5)  = SetBusElement('AbsoluteSpeedLimit','single',"Absolute speed limit" ) ; 
suelems(6)  = SetBusElement('PositionModulo1','double',"Modulo count for position sensor #1" ) ;
suelems(7)  = SetBusElement('PositionModulo2','double',"Modulo count for position sensor #2" ) ;
suelems(8)  = SetBusElement('OverSpeed','single',"Speed for overspeed exception" ) ;  
suelems(9)  = SetBusElement('AbsoluteAccelerationLimit','single',"Absolute acceleration limit" ) ; 
suelems(10)  = SetBusElement('ContinuousCurrentLimit','single',"Continuous current limit" ) ; 
suelems(11)  = SetBusElement('PeakCurrentLimit','single',"Peak current limit" ) ; 
suelems(12)  = SetBusElement('PeakCurrentDuration','single',"Peak current duration" ) ;
suelems(13)  = SetBusElement('OverCurrent','single',"Over current that causes an exception" ) ;
suelems(14)  = SetBusElement('UARTBaudRate','uint32',"Baud rate of UART" ) ;
suelems(15)  = SetBusElement('CANBaudRate','uint32',"Baud rate of CAN" ) ;
suelems(16)  = SetBusElement('IsPosSensorModulo1','uint16',"Is Sensor modulo: 1" ) ;
suelems(17)  = SetBusElement('IsPosSensorModulo2','uint16',"Is Sensor modulo: 2" ) ;
suelems(18)  = SetBusElement('CANId11bit','uint16',"CAN ID 11bit" ) ;
suelems(19)  = SetBusElement('Ts','single',"Profiler sampling time " ) ;

SetupReportBuf = Simulink.Bus;
SetupReportBuf.Elements = suelems;

LogBusInSLDD(DataDictionary,  'SetupReportBuf' , suelems) ;
LogSignalInSLDD(dataSection, 'SetupReportBuf' , 'G_SetupReportBuf') ; 

%% Command to the servo driver
nCommandElements = 24 ; 
cselems(nCommandElements,1) =Simulink.BusElement ;
for cnt = 1:nCommandElements , cselems(cnt) = SetBusElement(['Spare_',num2str(cnt)],'int32',"Spare : " + num2str(cnt)  ) ; end 

cselems(1)  = SetBusElement('PositionCommand','double',"Command to position controller" ) ; 
cselems(2)  = SetBusElement('SpeedCommand','double',"Command to speed controller" ) ; 
cselems(3)  = SetBusElement('CurrentCommand','double',"Command to current controller" ) ; 
cselems(4)  = SetBusElement('LoopConfiguration','int16',"Control loop configuration" ) ; 
cselems(5)  = SetBusElement('ReferenceMode','int16',"ReferenceMode" ) ; 
cselems(6)  = SetBusElement('MotorOn','int16',"Motor on request" ) ; 
cselems(7)  = SetBusElement('FailureReset','int16',"Failure Reset Request" ) ; 
DrvCommandBuf = Simulink.Bus;
DrvCommandBuf.Elements = cselems;

LogBusInSLDD(DataDictionary,  'DrvCommandBuf' , cselems) ;
LogSignalInSLDD(dataSection, 'DrvCommandBuf' , 'G_DrvCommandBuf') ; 

%% System level feedback bus
nFeedbackElements = 24 ; 
felems(nFeedbackElements,1) =Simulink.BusElement ;
for cnt = 1:nFeedbackElements , felems(cnt) = SetBusElement(['Spare_',num2str(cnt)],'int32',"Spare : " + num2str(cnt)  ) ; end 

felems(1)  = SetBusElement('EncoderMain','int32',"The main encoder sensor" ) ; 
felems(2)  = SetBusElement('EncoderSecondary','int32',"The secondary encoder sensor" ) ; 
felems(3)  = SetBusElement('EncoderMainSpeed','single',"Speed of main encoder sensor" ) ; 
felems(4)  = SetBusElement('EncoderSecondarySpeed','single',"Speed of secondary encoder sensor" ) ; 
felems(5)  = SetBusElement('Iq','single',"Q-channel current Amp" ) ; 
felems(6)  = SetBusElement('Id','single',"Q-channel current Amp" ) ; 
felems(7)  = SetBusElement('DcBusVoltage','single',"DC bus voltage V" ) ; 
felems(8)  = SetBusElement('PowerStageTemperature','single',"Power stage temperature C" ) ;
felems(9)  = SetBusElement('FieldAngle','single',"Motor electrical field angle" ) ;
felems(13)  = SetBusElement('LoopConfiguration','int16',"Control loop configuration" ) ; 
felems(14)  = SetBusElement('ReferenceMode','int16',"ReferenceMode" ) ; 
felems(15)  = SetBusElement('MotorOn','int16',"Motor on report" ) ; 
felems(16)  = SetBusElement('HallCode','int16',"Code of Hall sensors" ) ; 
felems(17)  = SetBusElement('STODisable','int16',"1 if disabled by STO" ) ;
felems(18)  = SetBusElement('StatusBitField','int16',"Status bit field" ) ;
felems(19)  = SetBusElement('ErrorCode','uint32',"Motor failure report" ) ; 

LogBusInSLDD(DataDictionary,  'FeedbackBuf' , felems) ;
LogSignalInSLDD(dataSection, 'FeedbackBuf' , 'G_FeedbackBuf') ; 


%% Finally save the changes
saveChanges(DataDictionary);

end


function busInstance = LogBusInSLDD(DataDictionary,  BusName , Elements) 
% function busInstance = LogBusInSLDD(DataDictionary,  BusName , Elements) 
% Register a bus type in the design data section of the SLDD 
% DataDictionary: The data dictionary in which the bus description is to be
% installed
dataSection = getSection(DataDictionary,'Design Data');
bus = Simulink.Bus;
bus.Elements = Elements;
assignin(dataSection,BusName,bus);    
if nargout > 0 
    assignin('base',BusName, bus);
    %     entry   = getEntry(dataSection, BusName);
    %     busObj  = getValue(entry);
    busInstance = Simulink.Bus.createMATLABStruct(BusName) ;
    evalin('base',['clear ',BusName]);
end
end

function LogSignalInSLDD(dataSection, SigType , SigName , storageclass  ) 
% Register a bus instance as system global signal in the design data section of the SLDD 
% Arguments: 
% dataSection: A design data section in an SLDD, where the signal is to be put 
% SigType: The signal to store, any native type or "Bus: Something". For a Bus, just write "Something" , the Bus: preamble will be
% added automatically.
% SigName: The name in which the signal is to be identified at the generated code
% storageckass: Defaulted to "ImportedExtern" but can be any other legal option like 'ExportedGlobal'
if nargin < 4 
    storageclass = 'ImportedExtern';
end
Sig2Register = Simulink.Signal;

types = {
    'double'
    'single'
    'int8'
    'uint8'
    'int16'
    'uint16'
    'int32'
    'uint32'
    'int64'
    'uint64'
    'logical'
    'char'
    'string'
};

if any( strcmp(SigType,types) )
    Sig2Register.DataType = SigType ; 
else
    Sig2Register.DataType = ['Bus: ',SigType] ; 
end
Sig2Register.StorageClass  = storageclass;
% if ( isequal(char(storageclass) ,'ExportedGlobal') )
%     Sig2Register.Value = value ; 
% end

assignin(dataSection,SigName,Sig2Register);   

end