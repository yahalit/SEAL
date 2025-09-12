function CreateProtectedBus(DesignDataSection,busName,DataStoreName,IsProtected,InitName,InitValue,Description)  
%CREATEPROTECTEDBUS Declare a flat Simulink.Bus, its initializer (Parameter), and a bus-typed data-store Signal.
%
% PURPOSE
%   Prepare Embedded Coder artifacts for a global bus variable shareable between
%   idle and interrupt contexts. The fields, sizes, and MATLAB classes in
%   INITVALUE define the Bus elements. INITNAME is a bus-typed Parameter
%   holding the initializer struct. DATASTORENAME is a bus-typed Signal
%   representing the data-store (global) variable.
%
%   When ISPROTECTED is true (nonzero), this function *registers* the bus
%   instance so that downstream
%   code-generation hooks can:
%     - create distinct ISR/IDLE copies,
%     - sample the ISR copy on idle-entry within a critical section,
%     - and commit only changed fields on idle-exit within a critical section.
%
% SIGNATURE
%   CreateProtectedBus(DesignDataSection, busName, DataStoreName, ...
%                      IsProtected, InitName, InitValue, Description)
%
% ARGUMENTS
%   DesignDataSection : Design Data section handle of an SLDD.
%   busName           : Name of the Simulink.Bus type to create.
%   DataStoreName     : Name of the Simulink.Signal (bus-typed) that models
%                       the global data store in Simulink.
%   IsProtected       : logical/number. If nonzero, registers this bus instance
%                       for ISR/IDLE protection.
%   InitName          : Name of the Simulink.Parameter initializer (bus-typed).
%   InitValue         : FLAT struct. Field names define element names; each
%                       field's class/size defines element data type/shape.
%   Description       : Description strings, one per field, [] | string array | cellstr with one entry per field.
%                       If empty, field names are used as descriptions.
%
% REQUIREMENTS
%   - Simulink.
%   - Helper: SetBusElement(name, className, descr, dims) -> Simulink.BusElement
%   - INITVALUE must be a *flat* struct (no nested structs).
%
% EXAMPLE
%   init.Pos   = zeros(3,1,'double');
%   init.Vel   = single(0);
%   init.Valid = false;
%   desc = {'Position [m]';'Velocity [m/s]';'Validity flag'};
%   CreateProtectedBus(getSection(myDD,'Design Data'), ...
%       'MyStateBus','gMyState',true,'MyStateInit',init,desc);
%
% See also: Simulink.Bus, Simulink.BusElement, Simulink.Parameter,
%           Simulink.Signal, assignin, Simulink.Bus.createMATLABStruct


global SealProjectDescriptor %#ok<GVMIS>

BusString = ['Bus: ',busName];

fn = fieldnames(InitValue) ; 

if isempty(Description) 
    Description = fn ; 
end
if isstring(Description) 
    Description = cellstr(Description);
end

nBus = numel(fn); 
elems(nBus,1) =Simulink.BusElement ;
for cnt = 1:nBus 
    next = fn{cnt};
    if isstruct(InitValue.(next)) 
        error("This function is intended for flat busses only") ; 
    end
    elems(cnt) = SetBusElement(next,class(InitValue.(next)) ,Description{cnt}, size(InitValue.(next)) ) ; 
end

BusEntity = Simulink.Bus;
BusEntity.Elements = elems;
  
assignin(DesignDataSection,busName,BusEntity);

% assignin('base',busName, BusEntity);
% InitStruct = Simulink.Bus.createMATLABStruct(busName) ;
% 
% for cnt = 1:nbus
%     InitStruct.(fn{cnt})(:) = InitValue.(fn{cnt}); 
% end
InitStruct = InitValue ;

InitStr = Simulink.Parameter ; 
InitStr.DataType = BusString;
InitStr.Value    = InitStruct        ;
InitStr.StorageClass  = 'ExportedGlobal';

assignin(DesignDataSection,InitName,InitStr);    

Instance = Simulink.Signal;
Instance.DataType = BusString;
Instance.StorageClass = 'ImportedExternPointer';

if IsProtected
    SealProjectDescriptor.ProtectedBusArray = [SealProjectDescriptor.ProtectedBusArray,struct('Name',DataStoreName,'Type',busName)]  ; 
end 
assignin(DesignDataSection, DataStoreName ,Instance); 

end