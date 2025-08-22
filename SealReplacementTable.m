function hLib = SealReplacementTable


hLib = RTW.TflTable;
%---------- entry: sin ----------- 
hEnt = createCRLEntry(hLib, ...
    'single y1 = sin( single u1 )', ...
    'single y1 = __sin( single u1 )');
hEnt.setTflCFunctionEntryParameters( ...
          'Priority', 100);

hEnt.EntryInfo.Algorithm = 'RTW_UNSPECIFIED';


hLib.addEntry( hEnt ); 

