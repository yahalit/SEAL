function SEALCfgTypes(DataDictionary, cfg) 
% function SEALCfgTypes(DataDictionary) 
% Define the driver interface busses. 
% DataDictionary: a handle to an open SLDD data
% At the end, data is udated into the SLDD file.


dataSection = getSection(DataDictionary,'Design Data');

%% Define version control
velems(3,1) =Simulink.BusElement ;
velems(1) = SetBusElement('Version','uint16',"SEAL database version" ) ; 
velems(2) = SetBusElement('SubVersion','uint16',"SEAL database sub version" ) ; 
velems(3) = SetBusElement('UserData','uint32',"SEAL database support data" ) ; 
VersionControlStruct = LogBusInSLDD(DataDictionary,  'SEALVerControl_T' , velems) ;

VersionControlStruct.Version = 1 ; 
VersionControlStruct.SubVersion = 1 ; 
VersionControlStruct.UserData = 0 ; 
SEALVerControl_init = Simulink.Parameter;
SEALVerControl_init.DataType = 'Bus: SEALVerControl_T';
SEALVerControl_init.Value     = VersionControlStruct ;
SEALVerControl_init.StorageClass  = 'ExportedGlobal';

assignin(dataSection,'SEALVerControl_init',SEALVerControl_init);    
LogSignalInSLDD(dataSection, 'SEALVerControl_T' , 'G_SEALVerControl','ExportedGlobal' ) ; 


%% Define UART related interface 

%% UART Communication bus
if ( cfg.System.UART.Available.v )
    elems(5,1) =Simulink.BusElement ;
    elems(1) = SetBusElement('PutCounter','uint16',"The place in the UARTQueue where next character is to be put" ) ; 
    elems(2) = SetBusElement('FetchCounter','uint16',"The location in the UARTQueue of the next character to read" ) ; 
    elems(3) = SetBusElement('UartError','uint16',"UART error" ) ; 
    elems(4) = SetBusElement('TxFetchCounter','uint16',"The location in the TX UARTQueue of the next character to read" ) ; 
    elems(5) = SetBusElement('UARTQueue','uint16',"Software Queue for incoming UART characters" ,[1 256]) ; 
    LogBusInSLDD(DataDictionary,  'UartCyclicBuf_T' , elems) ;
    
    
    %% UART buffer signals
    LogSignalInSLDD(dataSection, 'UartCyclicBuf_T' , 'G_pUartCyclicBuf_in','ImportedExternPointer') ; 
    LogSignalInSLDD(dataSection, 'UartCyclicBuf_T' , 'G_pUartCyclicBuf_out','ImportedExternPointer') ; 
end

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

LogBusInSLDD(DataDictionary,  'MicroInterp_T' , telems) ;
LogSignalInSLDD(dataSection, 'MicroInterp_T' , 'G_MicroInterp','ImportedExtern') ; 


%% Define CAN interfaces 
if ( cfg.System.CAN.Available.v )

    %% CAN communication bus 
    celems(7,1) =Simulink.BusElement ;
    celems(1) = SetBusElement('PutCounter','uint16',"The place in the CANQueue where the next message is to be put" ) ; 
    celems(2) = SetBusElement('FetchCounter','uint16',"The location in the CANQueue of the next message to read" ) ; 
    celems(3) = SetBusElement('CANError','uint16',"CAN error" ) ; 
    celems(4) = SetBusElement('CANQueue','uint32',"Software Queue for incoming CAN messages" ,[128,1]) ; 
    celems(5) = SetBusElement('TxFetchCounter','uint16',"The location in the CANQueue of the next message to transmit" ) ; 
    celems(6) = SetBusElement('CANID','uint32',"Can ID, 11 or 29bit" ,[64,1]) ; 
    celems(7) = SetBusElement('DLenAndAttrib','uint16',"Data length and attributes" ,[64,1]) ; 
    
    LogBusInSLDD(DataDictionary,  'CANCyclicBuf_T' , celems) ;
    
    
    %% CAN buffer signals
    LogSignalInSLDD(dataSection, 'CANCyclicBuf_T' , 'G_pCANCyclicBuf_in','ImportedExternPointer') ; 
    LogSignalInSLDD(dataSection, 'CANCyclicBuf_T' , 'G_pCANCyclicBuf_out','ImportedExternPointer') ; 
    
    %% Can message
    cmelems(4,1) =Simulink.BusElement ;
    cmelems(1) = SetBusElement('CANID','uint32',"ID of the CAN message" ) ; 
    cmelems(2) = SetBusElement('DataLen','uint16',"Data length of the CAN message" ) ; 
    cmelems(3) = SetBusElement('MsgData','uint32',"Data for incoming CAN messages" ,[1,2]) ; 
    cmelems(4) = SetBusElement('CANTxCnt','uint16',"Number TX requests including this message" ) ; 
    CANMessage_Struct =  LogBusInSLDD(DataDictionary,  'CANMessage_T' , cmelems) ;
    
    CANMessage_Struct.CANID = 0 ; 
    CANMessage_Struct.DataLen = 0 ; 
    CANMessage_Struct.MsgData = [0,0] ; 
    CANMessage_Struct.CANTxCnt = 0 ; 
    
    CANMessage_Init = Simulink.Parameter;
    CANMessage_Init.DataType = 'Bus: CANMessage_T';
    CANMessage_Init.Value     = CANMessage_Struct ;
    CANMessage_Init.StorageClass  = 'ExportedGlobal';
    
    assignin(dataSection,'CANMessage_Init',CANMessage_Init);    
end

%% System level reports 


[B_top, busVal] = cfg_to_bus(cfg.AxesData,'SetupReportBuf_T' );
busVal = busVal(:) ; 
assignin(dataSection,'SetupReportBuf_T',B_top);    

% LogBusInSLDD(DataDictionary,  'SetupReportBuf_T' , suelems) ;
LogSignalInSLDD(dataSection, 'SetupReportBuf_T' , 'G_SetupReportBuf') ; 

SetupReportBuf_init = Simulink.Parameter;
SetupReportBuf_init.DataType = 'Bus: SetupReportBuf_T';
SetupReportBuf_init.Value     = busVal ;
SetupReportBuf_init.StorageClass  = 'ExportedGlobal';

assignin(dataSection,'SetupReportBuf_init',SetupReportBuf_init);    



%% Command to the servo driver
nCommandElements = 24 ; 
cselems(nCommandElements,1) =Simulink.BusElement ;
for cnt = 1:nCommandElements , cselems(cnt) = SetBusElement(['Spare_',num2str(cnt)],'int16',"Spare : " + num2str(cnt)  ) ; end 

cselems(1)  = SetBusElement('PositionCommand','double',"Command to position controller" ) ; 
cselems(2)  = SetBusElement('SpeedCommand','double',"Command to speed controller" ) ; 
cselems(3)  = SetBusElement('CurrentCommand','double',"Command to current controller" ) ; 
cselems(4)  = SetBusElement('LoopConfiguration','int16',"Control loop configuration: see enumerated type VarFeedbackMode" ) ; 
cselems(5)  = SetBusElement('ReferenceMode','int16',"ReferenceMode: see enumerated type VarReferenceModes" ) ; 
cselems(6)  = SetBusElement('MotorOn','int16',"Motor on request" ) ; 
cselems(7)  = SetBusElement('FailureReset','int16',"Failure Reset Request" ) ; 
cselems(8)  = SetBusElement('bSetSealControl','int16',"Oblige the drive from SEAL control" ) ; 
cselems(9)  = SetBusElement('bControlUART','int16',"Flag that the SEAL uses the UART and the drive should not interpret UART communication" ) ; 
DrvCommandBuf_T = Simulink.Bus;
DrvCommandBuf_T.Elements = cselems;

LogBusInSLDD(DataDictionary,  'DrvCommandBuf_T' , cselems) ;
LogSignalInSLDD(dataSection, 'DrvCommandBuf_T' , 'G_DrvCommandBuf') ; 

%% System level feedback bus
nFeedbackElements = 24 ; 
felems(nFeedbackElements,1) =Simulink.BusElement ;
for cnt = 1:nFeedbackElements , felems(cnt) = SetBusElement(['Spare_',num2str(cnt)],'int16',"Spare : " + num2str(cnt)  ) ; end 

felems(1)  = SetBusElement('SystemTime','double',"Time counted from process start" ) ; 
felems(2)  = SetBusElement('EncoderMain','int32',"The main encoder sensor" ) ; 
felems(3)  = SetBusElement('EncoderSecondary','int32',"The secondary encoder sensor" ) ; 
felems(4)  = SetBusElement('EncoderMainSpeed','single',"Speed of main encoder sensor" ) ; 
felems(5)  = SetBusElement('EncoderSecondarySpeed','single',"Speed of secondary encoder sensor" ) ; 
felems(6)  = SetBusElement('Iq','single',"Q-channel current Amp" ) ; 
felems(7)  = SetBusElement('Id','single',"Q-channel current Amp" ) ; 
felems(9)  = SetBusElement('DcBusVoltage','single',"DC bus voltage V" ) ; 
felems(10)  = SetBusElement('PowerStageTemperature','single',"Power stage temperature C" ) ;
felems(11)  = SetBusElement('FieldAngle','single',"Motor electrical field angle" ) ;
felems(12)  = SetBusElement('ErrorCode','uint32',"Motor failure report" ) ; 
felems(13)  = SetBusElement('LoopConfiguration','int16',"Control loop configuration" ) ; 
felems(14)  = SetBusElement('ReferenceMode','int16',"ReferenceMode" ) ; 
felems(15)  = SetBusElement('MotorOn','int16',"Motor on report" ) ; 
felems(16)  = SetBusElement('HallCode','int16',"Code of Hall sensors" ) ; 
felems(17)  = SetBusElement('STODisable','int16',"1 if disabled by STO" ) ;
felems(18)  = SetBusElement('StatusBitField','int16',"Status bit field" ) ;
felems(19)  = SetBusElement('ConfirmRelinquishControl','int16',"Confirm Release the drive from SEAL control" ) ; 
felems(20)  = SetBusElement('ProfiledPositionCommand','double',"Drive-sourecd Command to position controller" ) ; 
felems(21)  = SetBusElement('ProfiledSpeedCommand','double',"Drive sources Command to speed controller" ) ; 
felems(22)  = SetBusElement('ProfiledTorqueCommand','double',"Drive sources Command to current controller" ) ; 

FeedbackBuf_T_Instance = LogBusInSLDD(DataDictionary,  'FeedbackBuf_T' , felems) ;
LogSignalInSLDD(dataSection, 'FeedbackBuf_T' , 'G_FeedbackBuf') ; 

% Signal for drive simulation
assignin(dataSection,'Drv_FeedbackBuf_T_init',FeedbackBuf_T_Instance);    



%% Enumerated type for reference modes
et = Simulink.data.dictionary.EnumTypeDefinition;
et.StorageType  = 'uint16';
% Add members
appendEnumeral(et,'T_StayInPlace',  0, 'Reference values do not change, or come to complete stop ASAP');
appendEnumeral(et,'T_ProfiledSpeed',   1, 'Converge a desired speed. Position commands if applicable are automated to match the speed');
appendEnumeral(et,'T_ProfiledPosition', 2, 'Converge to a desired position subject to speed and current limits');
appendEnumeral(et,'T_Continuous', 3, 'Reference values are continuously calculated by SEAL');
appendEnumeral(et,'T_InDriveProfiler', 4, 'Reference is generated internally by the drive');
% Remove the default placeholder member ('enum1') that the object starts with
removeEnumeral(et,1);
addEntry(dataSection,'VarReferenceModes', et);

%% Enumerated type for feedback modes 
et = Simulink.data.dictionary.EnumTypeDefinition;
et.StorageType  = 'uint16';
% Add members
appendEnumeral(et,'T_Current',  0, 'Current (torque) control only');
appendEnumeral(et,'T_Speed',   1, 'Speed control, cascaded over current control');
appendEnumeral(et,'T_Position', 2, 'Position control cascaded over Speed control, cascaded over current control');
% Remove the default placeholder member ('enum1') that the object starts with
removeEnumeral(et,1);
addEntry(dataSection,'VarFeedbackMode', et);


%% Enumerated type for data types
et = Simulink.data.dictionary.EnumTypeDefinition;
et.StorageType  = 'uint16';
% Add members
appendEnumeral(et,'T_int32',  0, 'long');
appendEnumeral(et,'T_single',   2, 'float');
appendEnumeral(et,'T_int16', 4, 'short');
appendEnumeral(et,'T_uint32', 8, 'unsigned long');
appendEnumeral(et,'T_uint16', 12, 'unsigned short');
appendEnumeral(et,'T_double', 16, 'double');
% Remove the default placeholder member ('enum1') that the object starts with
removeEnumeral(et,1);
addEntry(dataSection,'VarDataTypes', et);

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