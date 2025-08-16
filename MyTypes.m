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

% 3) NOW you can access MemorySections
% memSecs = getSection(cdict,'MemorySections');
% % Create a new Memory Section entry (unique name of your choice)
% entryName = 'TI_SEALDATA_SECT';
% ms = addEntry(memSecs, entryName);
% 
% % Emit the TI pragmas. Use the variable-name token so the symbol name is substituted.
% % (Token syntax accepted here is %<VariableName>.)
% set ( ms,'PreStatement',[
%     '#pragma DATA_SECTION(G_SEAL_Data, "TI_SEALDATA_SECT")' newline ...
%     '#pragma DATA_ALIGN(G_SEAL_Data, 2)' ]) ;
% set(ms,'PostStatement','');   % usually not needed

% Generate the communication structures between SEAL and the hosting driver
SEALSystemTypes(dd) ;

%% Generate data structures ( busses)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dd = Simulink.data.dictionary.open('MyModel.sldd');  % or open existing
% Bus element data types: 
% 'double' 'single' ,'int8', 'uint8','int16', 'uint16','int32', 'uint32','boolean'
% 2) Build the bus in code

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


FeedbackBuf = Simulink.Bus;
FeedbackBuf.Elements = felems;


%% System level setup 
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

SetupReportBuf = Simulink.Bus;
SetupReportBuf.Elements = felems;

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


pelems(7,1) =Simulink.BusElement ;
pelems(1) = SetBusElement('PositionTarget','single',"Final position to arrive" ) ; 
pelems(2) = SetBusElement('ProfileSpeed','single',"Maximum speed" ) ; 
pelems(3) = SetBusElement('ProfileAcceleration','single',"Maximum Profile acceleration" ) ; 
pelems(4) = SetBusElement('ProfileDeceleration','single',"Maximum Profile deceleration" ) ; 
pelems(5) = SetBusElement('ProfileFilterDen','double',"Filter monic polynomial for profile filtering",[4,1] ) ; 
pelems(6) = SetBusElement('ProfileFilterNum','double',"Filter numerator for profile filtering",[1,1] ) ; 
pelems(7) = SetBusElement('ProfileDataOk','uint16',"Flag that profiler data is consistent",[1,1] ) ; 
PosProfilerData = Simulink.Bus;
PosProfilerData.Elements = pelems;

selems(6,1) =Simulink.BusElement ;
selems(1) = SetBusElement('Ts','single',"Profiler sampling time " ) ; 
selems(2) = SetBusElement('MaxPosition','single',"Maximum position" ) ; 
selems(3) = SetBusElement('MinPosition','single',"Minimum position" ) ; 
selems(4) = SetBusElement('AbsSpeedLimit','single',"Absolute Speed limit" ) ; 
selems(5) = SetBusElement('AbsAccelerationLimit','single',"Absolute Acceleration limit" ) ; 
selems(6) = SetBusElement('CurrentCommandLimit','single',"Current command limit" ) ; 
SystemData = Simulink.Bus;
SystemData.Elements = selems;

ppelems(3,1) =Simulink.BusElement ;
ppelems(1) = SetBusElement('Position','double',"Position state of profiler" ) ; 
ppelems(2) = SetBusElement('Speed','double',"Speed state of profiler" ) ; 
ppelems(3) = SetBusElement('FiltState','double',"State of profiling filter",[8,1] ) ; 
PosProfilerState = Simulink.Bus;
PosProfilerState.Elements = ppelems;


% 3) Put the bus into the SLDD's Design Data section
sec = getSection(dd,'Design Data');
  
assignin(sec,'PosProfilerData',PosProfilerData);     
assignin(sec,'PosProfilerState',PosProfilerState);     
assignin(sec,'SystemData',SystemData);     
assignin(sec,'DrvCommandBuf',DrvCommandBuf);     
assignin(sec,'FeedbackBuf',FeedbackBuf);     
assignin(sec,'SetupReportBuf',SetupReportBuf);     


%% Create example specific structs
PosProfilerDataStructPrototype = Simulink.Bus.createMATLABStruct('PosProfilerData');
SystemDataStructPrototype = Simulink.Bus.createMATLABStruct('SystemData');
PosProfilerStateStructPrototype = Simulink.Bus.createMATLABStruct('PosProfilerState');
% UartCyclicBufStructPrototype = Simulink.Bus.createMATLABStruct('UartCyclicBuf');
% CANCyclicBufStructPrototype = Simulink.Bus.createMATLABStruct('CANCyclicBuf');

%% Create Structs of global drive interface, they must be provided with ImportedExtern attribute
% Init data stores for global structs
SystemDataStructPrototype.Ts = single(100e-4)  ; 
SystemDataStructPrototype.CurrentCommandLimit =  20  ; 
SystemDataStructPrototype.AbsSpeedLimit =  BigFloat ; 
SystemDataStructPrototype.MaxPosition =  BigFloat  ; 
SystemDataStructPrototype.MinPosition = -BigFloat  ; 
SystemDataStructPrototype.AbsSpeedLimit =  BigFloat  ; 
SystemDataStructPrototype.AbsAccelerationLimit =  1.e6 ; 

SystemData_init = Simulink.Parameter;
SystemData_init.DataType = 'Bus: SystemData';
SystemData_init.Value  = SystemDataStructPrototype ;
SystemData_init.StorageClass  = 'ExportedGlobal';
assignin(sec,'SystemData_init',SystemData_init);    

PosProfilerDataStructPrototype.PositionTarget = 0 ; 
PosProfilerDataStructPrototype.ProfileSpeed   = 1 ; 
PosProfilerDataStructPrototype.ProfileAcceleration   = 1 ; 
PosProfilerDataStructPrototype.ProfileDeceleration   = 1 ; 
PosProfilerDataStructPrototype.ProfileFilterDen   = [1.000000000000000 ; -0.874052257056399 ;  0.280840263500717 ; -0.024477523271653 ] ; 
PosProfilerDataStructPrototype.ProfileFilterNum   = 0.382310483172666 ; 
PosProfilerDataStructPrototype.ProfileDataOk = 0 ;

PosProfilerData_init = Simulink.Parameter;
PosProfilerData_init.DataType = 'Bus: PosProfilerData';
PosProfilerData_init.Value     = PosProfilerDataStructPrototype ;
PosProfilerData_init.StorageClass  = 'ExportedGlobal';

assignin(sec,'PosProfilerData_init',PosProfilerData_init);    


PosProfilerState_init = Simulink.Parameter;
PosProfilerState_init.DataType = 'Bus: PosProfilerState';
PosProfilerState_init.Value     = PosProfilerStateStructPrototype ;
PosProfilerState_init.StorageClass  = 'ExportedGlobal';

assignin(sec,'PosProfilerState_init',PosProfilerState_init);    

%% Creating custom storage classes for drive globals. 
%  Each has separate initializer and memory store instances
%  Never change this - otherwise SW will miserable fail.
sG_DrvCommandBuf = Simulink.Signal;
sG_DrvCommandBuf.DataType = 'Bus: DrvCommandBuf';
sG_DrvCommandBuf.StorageClass  = 'ImportedExtern';
assignin(sec,'G_DrvCommandBuf',sG_DrvCommandBuf);    
clear sG_DrvCommandBuf ; 

sG_FeedbackBuf  = Simulink.Signal;
sG_FeedbackBuf.DataType = 'Bus: FeedbackBuf';
sG_FeedbackBuf.StorageClass  = 'ImportedExtern';
assignin(sec,'G_FeedbackBuf',sG_FeedbackBuf);    
clear sG_FeedbackBuf ; 

sG_SetupReportBuf  = Simulink.Signal;
sG_SetupReportBuf.DataType = 'Bus: SetupReportBuf';
sG_SetupReportBuf.StorageClass  = 'ImportedExtern';
assignin(sec,'G_SetupReportBuf',sG_SetupReportBuf);    
clear sG_SetupReportBuf ;


% 4) Save the dictionary and close all the open dictionaries
saveChanges(dd);
%Simulink.data.dictionary.closeAll(); 

% Copy the new sldd to its use location
% copyfile (SlddName,  fullfile(SlddDir,SlddName)) ; 

% 5) Link your model to the dictionary (once)
% set_param('MyModel','DataDictionary','MyModel.sldd');
% save_system('MyModel');