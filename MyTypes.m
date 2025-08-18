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


%% Create example specific structs
PosProfilerDataStructPrototype = Simulink.Bus.createMATLABStruct('PosProfilerData');
PosProfilerStateStructPrototype = Simulink.Bus.createMATLABStruct('PosProfilerState');

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



% 4) Save the dictionary and close all the open dictionaries
saveChanges(dd);
%Simulink.data.dictionary.closeAll(); 

% Copy the new sldd to its use location
% copyfile (SlddName,  fullfile(SlddDir,SlddName)) ; 

% 5) Link your model to the dictionary (once)
% set_param('MyModel','DataDictionary','MyModel.sldd');
% save_system('MyModel');