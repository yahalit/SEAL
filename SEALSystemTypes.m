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
bus = LogBusInSLDD(DataDictionary,  'SEALVerControl' , velems) ;

% VersionControlStruct.Version = 1 ; 
% VersionControlStruct.SubVersion = 1 ; 
% VersionControlStruct.UserData = 0 ; 

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

%% Finally save the changes
saveChanges(DataDictionary);

end


function busInstance = LogBusInSLDD(DataDictionary,  BusName , Elements) 
% Register a bus type in the design data section of the SLDD 
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
% Register a bus instance as system global in the design data section of the SLDD 
if nargin < 4 
    storageclass = 'ImportedExtern';
end
Sig2Register = Simulink.Signal;
Sig2Register.DataType = ['Bus: ',SigType] ; 
Sig2Register.StorageClass  = storageclass;
% if ( isequal(char(storageclass) ,'ExportedGlobal') )
%     Sig2Register.Value = value ; 
% end

assignin(dataSection,SigName,Sig2Register);   

end