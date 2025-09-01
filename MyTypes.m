% Generate the SLDD (Simulink Data Definitions) for specialized types
% This SLDD is a secondary referenced SLDD so it can be safely deleted and
% restores without affecting other user selections.
% Run AtpStart before to define the directories 


% Kill the SEALGenericTypes if it exists
% Compare against the requested file
try
    ddObjs = Simulink.data.dictionary.getOpenDictionaries();
    if ( any(strcmpi(filename, ddObjs)) ) 
        Simulink.data.dictionary.close(SlddName);
    end
catch
end


if ( isfile(SlddName) )
    % Get all open dictionaries
    delete(SlddName) ; 
end

% Create or open the SLDD
Simulink.data.dictionary.closeAll() ; 
dd = Simulink.data.dictionary.create(SlddName);   % create new


%% Generate memory section for middlware connection
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the "Memory Sections" container from the coder dictionary
% 2) Create/open the Embedded Coder Dictionary stored in that SLDD
try
    cdict = coder.dictionary.create(SlddName);   % creates if missing
catch
    cdict = coder.dictionary.open(SlddName);     % opens if already there
end

% (Sanity: confirm classes)
assert(contains(class(dd),'Simulink.data.Dictionary'));
assert(contains(class(cdict),'coder.Dictionary'));


% Generate the communication structures between SEAL and the hosting driver
SEALSystemTypes(dd) ;
DesignDataSection = getSection(dd,'Design Data');

%% Generate data structures ( busses)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dd = Simulink.data.dictionary.open('MyModel.sldd');  % or open existing
% Bus element data types: 
% 'double' 'single' ,'int8', 'uint8','int16', 'uint16','int32', 'uint32','boolean'
% 2) Build the bus in code

%% Define the profiler data
pelems(8,1) =Simulink.BusElement ;
pelems(1) = SetBusElement('PositionTarget','single',"Final position to arrive" ) ; 
pelems(2) = SetBusElement('ProfileSpeed','single',"Maximum speed" ) ; 
pelems(3) = SetBusElement('ProfileAcceleration','single',"Maximum Profile acceleration" ) ; 
pelems(4) = SetBusElement('ProfileDeceleration','single',"Maximum Profile deceleration" ) ; 
pelems(5) = SetBusElement('ProfileFilterDen','double',"Filter monic polynomial for profile filtering",[4,1] ) ; 
pelems(6) = SetBusElement('ProfileFilterNum','double',"Filter numerator for profile filtering",[1,1] ) ; 
pelems(7) = SetBusElement('ProfileDataOk','uint16',"Flag that profiler data is consistent",[1,1] ) ; 
pelems(8) = SetBusElement('Ts','single',"Profiler sampling time " ) ;
PosProfilerData_T = Simulink.Bus;
PosProfilerData_T.Elements = pelems;

assignin(DesignDataSection,'PosProfilerData_T',PosProfilerData_T);     
PosProfilerDataStructPrototype = Simulink.Bus.createMATLABStruct('PosProfilerData_T');
PosProfilerDataStructPrototype.PositionTarget = 0 ; 
PosProfilerDataStructPrototype.ProfileSpeed   = 1 ; 
PosProfilerDataStructPrototype.ProfileAcceleration   = 1 ; 
PosProfilerDataStructPrototype.ProfileDeceleration   = 1 ; 
PosProfilerDataStructPrototype.ProfileFilterDen   = [1.000000000000000 ; -0.874052257056399 ;  0.280840263500717 ; -0.024477523271653 ] ; 
PosProfilerDataStructPrototype.ProfileFilterNum   = 0.382310483172666 ; 
PosProfilerDataStructPrototype.ProfileDataOk = 0 ;

PosProfilerData_init = Simulink.Parameter;
PosProfilerData_init.DataType = 'Bus: PosProfilerData_T';
PosProfilerData_init.Value     = PosProfilerDataStructPrototype ;
PosProfilerData_init.StorageClass  = 'ExportedGlobal';

assignin(DesignDataSection,'PosProfilerData_init',PosProfilerData_init);    

%% Define the profiler state 
ppelems(3,1) =Simulink.BusElement ;
ppelems(1) = SetBusElement('Position','double',"Position state of profiler" ) ; 
ppelems(2) = SetBusElement('Speed','double',"Speed state of profiler" ) ; 
ppelems(3) = SetBusElement('FiltState','double',"State of profiling filter",[4,1] ) ; 
PosProfilerState_T = Simulink.Bus;
PosProfilerState_T.Elements = ppelems;
  
assignin(DesignDataSection,'PosProfilerState_T',PosProfilerState_T);     
PosProfilerStateStructPrototype = Simulink.Bus.createMATLABStruct('PosProfilerState_T');

PosProfilerState_init = Simulink.Parameter;
PosProfilerState_init.DataType = 'Bus: PosProfilerState_T';
PosProfilerState_init.Value     = PosProfilerStateStructPrototype ;
PosProfilerState_init.StorageClass  = 'ExportedGlobal';

assignin(DesignDataSection,'PosProfilerState_init',PosProfilerState_init);    

%% Define parameters
SetSealParameter(DesignDataSection,'Kp',5) ;
SetSealParameter(DesignDataSection,'KpSpeed',5) ;
SetSealParameter(DesignDataSection,'KiSpeed',5) ;


%% Define some use info
% Define any CAN filters you wish to use 
% Mask is 1 if bit is not checked
% Unused filters and IDs shuld be set to UnusedCanFiller
UnusedCanFiller = 2^31 - 1 ; 
uelems(7,1) =Simulink.BusElement ;
uelems(1) = SetBusElement('VersionNumber','int32',"Version control number" ) ; 
uelems(2) = SetBusElement('bUseUart','uint16',"1: Request control of UART" ) ; 
uelems(3) = SetBusElement('bUartBaudRate','uint32',"Baud rate of UART (if bUseUart)" ) ; 
uelems(4) = SetBusElement('CanID','uint32',"CAN IDs used locally by CAN",[1,4] ) ; 
uelems(5) = SetBusElement('CanIDMask','uint32',"CAN ID masks used locally by CAN",[1,4] ) ; 
uelems(6) = SetBusElement('ExtCanID','uint32',"CAN IDs used locally by CAN",[1,4] ) ; 
uelems(7) = SetBusElement('ExtCanIDMask','uint32',"CAN ID masks used locally by CAN",[1,4] ) ; 
UserInfo_T = Simulink.Bus;
UserInfo_T.Elements = uelems;
assignin(DesignDataSection,'UserInfo_T',UserInfo_T); 

G_UserInfo_initV = Simulink.Bus.createMATLABStruct('UserInfo_T');
G_UserInfo_initV.VersionNumber = 1 ; 
G_UserInfo_initV.bUseUart = 1 ; 
G_UserInfo_initV.UartBaudRate = 230400 ; 
G_UserInfo_initV.CanID = [ 1000 , 2000 , UnusedCanFiller , UnusedCanFiller ];
G_UserInfo_initV.CanIDMask = [ 0 , 0 , UnusedCanFiller , UnusedCanFiller ];
G_UserInfo_initV.ExtCanID = [ 1000 , 2000 , UnusedCanFiller , UnusedCanFiller ];
G_UserInfo_initV.ExtCanIDMask = [ 0 , 0 , UnusedCanFiller , UnusedCanFiller ];

G_UserInfo_init = Simulink.Parameter;
G_UserInfo_init.Value = G_UserInfo_initV ; 
G_UserInfo_init.StorageClass  = 'ExportedGlobal';
G_UserInfo_init.DataType = "Bus: UserInfo_T" ;


assignin(DesignDataSection,'G_UserInfo',G_UserInfo_init);   


% 4) Save the dictionary and close all the open dictionaries
saveChanges(dd);
