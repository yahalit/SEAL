function hLib = ReplacementTable


hLib = RTW.TflTable;
%---------- entry: sin ----------- 
hEnt = createCRLEntry(hLib, ...
    'single y1 = sin( single u1 )', ...
    'double y1 = __sin( double u1 )');
hEnt.setTflCFunctionEntryParameters( ...
          'Priority', 100);

hEnt.EntryInfo.Algorithm = 'RTW_UNSPECIFIED';


hLib.addEntry( hEnt ); 

