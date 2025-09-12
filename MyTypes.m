% Generate the SLDD (Simulink Data Definitions) for specialized types
% This SLDD is a secondary referenced SLDD so it can be safely deleted and
% restores without affecting other user selections.
% Run AtpStart before to define the directories 
SealProjectDescriptor.ProtectedBusArray = [] ; 

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
pos0 = 0 ; 
 den = [1.000000000000000 ; -0.874052257056399 ;  0.280840263500717 ; -0.024477523271653 ]; 
 numer = 0.382310483172666 ; 
 IsProtected = true; 
PosProfilerDataStructInit = struct('PositionTarget',pos0,'ProfileSpeed',0,'ProfileAcceleration',1e3,...
    'ProfileDeceleration',1e3,'ProfileFilterDen',den,'ProfileFilterNum',numer,'Ts',0,'ProfileDataOk',uint16(0)) ; 
Description = ["inal position to arrive","Maximum speed","Maximum Profile acceleration","Maximum Profile absolute deceleration",...
    "Filter monic polynomial for profile filtering","Filter numerator for profile filtering",...
    "Profiler sampling time","Flag that profiler data is consistent" ] ; 
CreateProtectedBus(DesignDataSection,'PosProfilerData_T','Gp_PosProfilerData',IsProtected,'PosProfilerData_init',PosProfilerDataStructInit,Description);  


%% Define the profiler state 

pos0 = 0 ; 
PosProfilerStateStructInit = struct('Position',pos0,'Speed',0,'FiltState',pos0*ones(4,1)) ; 
Description = ["Position state of profiler","Speed state of profiler","State of profiling filter"] ; 
CreateProtectedBus(DesignDataSection,'PosProfilerState_T','Gp_PosProfilerState',1,'G_PosProfilerState_init',PosProfilerStateStructInit,Description);  


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
uelems(3) = SetBusElement('UartBaudRate','uint32',"Baud rate of UART (if bUseUart)" ) ; 
uelems(4) = SetBusElement('CanID','uint32',"CAN IDs used locally by CAN",[1,4] ) ; 
uelems(5) = SetBusElement('CanIDMask','uint32',"CAN ID masks used locally by CAN",[1,4] ) ; 
uelems(6) = SetBusElement('ExtCanID','uint32',"CAN IDs used locally by CAN",[1,4] ) ; 
uelems(7) = SetBusElement('ExtCanIDMask','uint32',"CAN ID masks used locally by CAN",[1,4] ) ; 
UserInfo_T = Simulink.Bus;
UserInfo_T.Elements = uelems;
assignin(DesignDataSection,'UserInfo_T',UserInfo_T); 

G_UserInfo_initV = Simulink.Bus.createMATLABStruct('UserInfo_T');
G_UserInfo_initV.VersionNumber = int32(1) ; 
G_UserInfo_initV.bUseUart = uint16(1) ; 
G_UserInfo_initV.UartBaudRate = uint32(230400) ; 
G_UserInfo_initV.CanID = uint32([ 1000 , 2000 , UnusedCanFiller , UnusedCanFiller ]);
G_UserInfo_initV.CanIDMask = uint32([ 0 , 0 , UnusedCanFiller , UnusedCanFiller ]);
G_UserInfo_initV.ExtCanID = uint32([ 1000 , 2000 , UnusedCanFiller , UnusedCanFiller ]);
G_UserInfo_initV.ExtCanIDMask = uint32([ 0 , 0 , UnusedCanFiller , UnusedCanFiller ]);

G_UserInfo_init = Simulink.Parameter;
G_UserInfo_init.Value = G_UserInfo_initV ; 
G_UserInfo_init.StorageClass  = 'ExportedGlobal';
G_UserInfo_init.DataType = "Bus: UserInfo_T" ;


assignin(DesignDataSection,'G_UserInfo_init',G_UserInfo_init);   


% 4) Save the dictionary and close all the open dictionaries
saveChanges(dd);
