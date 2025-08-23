SealProjectDescriptor = struct('ModelName','Seal','BaseTs',50e-6,'HwTarget',"C28",'CodeGenFolder','AutoCode','RootDir',pwd,...
    'TIRoot',"C:\Projects\SensorLess\Software\BECpu2\SEAL\Automatic",...
    'SealTargetSourceFolder','C:\Projects\SensorLess\Software\BECpu2\SEAL\Automatic') ; 


HwTarget = SealProjectDescriptor.HwTarget;
% Set the directories to produce code 
% SealProjectDescriptor.ModelName = 'Seal';                 % your model name (without .slx/.mdl)

cfg = Simulink.fileGenControl('getConfig');

%% Setup work directories
% Change the parameters to non-default locations
% for the cache and code generation folders
cfg.CacheFolder = fullfile(pwd,'AutoCache');
cfg.CodeGenFolder = fullfile(pwd,CodeGenFolder.AutoCode);
%cfg.CodeGenFolderStructure = 'TargetEnvironmentSubfolder';
Simulink.fileGenControl('setConfig', 'config', cfg);

% Set path for sldd
SlddDir = '.\Support' ; 
addpath(SlddDir) ; 
SlddName = 'SEALGenericTypes_1.sldd';
SlddName =  fullfile(SlddDir,SlddName); 
BigFloat = single(1e18) ; 

% Pre processing is defined in the source file ert_make_rtw_hook.m

% Load model and install post processor
if ~bdIsLoaded(SealProjectDescriptor.ModelName)
    load_system(SealProjectDescriptor.ModelName);         % loads without opening
end
mdl = get_param(SealProjectDescriptor.ModelName, 'Handle'); % numeric handle to the block diagram

%% Generate code for C2000
ModelConfigurationSet  = getActiveConfigSet(mdl);
set_param(ModelConfigurationSet,'ProdEqTarget','on');
if  isequal( HwTarget,"C28" )
    set_param(ModelConfigurationSet,'ProdHWDeviceType','Texas Instruments->C2000');
elseif  isequal( HwTarget,"C29" )
    set_param(ModelConfigurationSet,'ProdHWDeviceType','Texas Instruments->C2000-C29x');
else
    error("Unknown Hardware target option") ; 
end

%% Log the post-code-generation processor
set_param(mdl,'PostCodeGenCommand','PrepWrapper');