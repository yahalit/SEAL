function busInstance = CreateBusInstance( busname , slddname ) 

SlddHandle =  Simulink.data.dictionary.open(slddname)  ;
sect = getSection(SlddHandle,'Design Data');

% Lookup the entry
entry  = getEntry(sect,busname);
busObj = getValue(entry);

% Create instance
busInstance = Simulink.Bus.createMATLABStruct(busObj);

end 