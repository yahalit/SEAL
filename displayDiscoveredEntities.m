function displayDiscoveredEntities(ints,idles,setups,exceptions,aborts)

disp('Detected entry poin functions') ; 
disp('-----------------------------'); 
DisplayEntities("Interrupt Service Routines",ints) ; 
DisplayEntities("Idle loop Routines",idles) ; 
DisplayEntities("Setup routine",setups) ; 
DisplayEntities("Exception handling routines",exceptions) ; 
DisplayEntities("Abort routines",aborts) ; 

end

function DisplayEntities(title,funcs_in) 

funcs = funcs_in ; 
for cnt = numel(funcs):-1:1
    if isequal( funcs(cnt).Func,"NULL" )
        funcs(cnt) = [] ; 
    end
end

if isempty(funcs) 
    disp("[" +title + "]: " +" No entries discovered") ;
    return ; 
end
    disp("[" + title + "] :" ) ;
    for cnt = 1:numel(funcs) 
        next = funcs(cnt).Func ; 
        if startsWith( upper(next),'ISR' )
            disp(next + ":  Period time = " + num2str(funcs(cnt).Ts)+ " usec" ) 
        else
            disp(next) ;
        end
    end

end
