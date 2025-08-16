% Set the directories to produce code 
ModelName = 'Seal';                 % your model name (without .slx/.mdl)

cfg = Simulink.fileGenControl('getConfig');

%% Setup work directories
% Change the parameters to non-default locations
% for the cache and code generation folders
cfg.CacheFolder = fullfile(pwd,'AutoCache');
cfg.CodeGenFolder = fullfile(pwd,'AutoCode');
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
if ~bdIsLoaded(ModelName)
    load_system(ModelName);         % loads without opening
end
mdl = get_param(ModelName, 'Handle'); % numeric handle to the block diagram

set_param(mdl,'PostCodeGenCommand','PrepWrapper');