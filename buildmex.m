function buildmex( str ) 
  disp(['Building: ' , str] ) ;
  try 
    msg = evalc(['mex -g -v ',str]) ; 
  catch me
    msg = me.message ; 
    if ( contains(msg,'LNK1201'))
        error('A debug session is still active, kill it before generating a new mex') ; 
    else
        error(msg) ; 
    end
  end
  dmsg  = double(msg) ;
  p     = find( dmsg == 10 ) ; 
  for cnt = 2:length(p) 
      next = strtrim(char(dmsg(p(cnt-1)+1:p(cnt)-1))) ; 
      if (contains(next,'LNK') || contains(next,'note','IgnoreCase', true) ||contains(next,'remark', 'IgnoreCase', true) ||  contains(next,'error') || contains(next,'warning') || startsWith( next,'MEX'))
          disp(next) ; 
      end
  end
end