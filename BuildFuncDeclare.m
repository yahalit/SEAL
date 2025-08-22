function str = BuildFuncDeclare(name , decriptorArr) 

numstr = 8 ;
str = strings(numstr,1) ; 
str(1) = "VoidFun " + name + "["+num2str(numstr)+"] ={" ; 
for cnt = 2:(numstr+1) 
    if  cnt <= numel(decriptorArr) 
        str(cnt) = BuildSingle(decriptorArr(cnt-1)) ; 
    else
        str(cnt) = BuildSingle( struct('Type',0) ) ; 
    end
    if ( cnt <= numstr )
        str(cnt) = str(cnt) + "," ; 
    else
        str(cnt) = str(cnt) + "};" ;
    end
end

% typedef struct
% {
%     voidFunc func; 
%     float Ts; 
%     enum E_FunType FunType; 
%     short unsigned nInts  ; 
%     short unsigned Priority   ;
%     short unsigned Algn;
%     long  Ticker;
% } FuncDescriptor;
% 
end

function str = BuildSingle(desc) 

if ( desc.Type == 3 ) % ISR
    str = "{.func = (voidFunc) " + desc.Func + ", .FunType =" + num2str(desc.Type) + ", .Priority=" + num2str(desc.Priority) + ... 
        ", .nInts = " + num2str(desc.nInts) + ", .Ts=" + num2str(desc.Ts) + ", .Algn=0, .Ticker = 0}" ;
else
    if ( desc.Type == 0 )
        str = "{.func = (voidFunc) " + "NULL" + ", .FunType = 0, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}" ;
    else
        str = "{.func = (voidFunc) " + desc.Func + ", .FunType =" + num2str(desc.Type) + ", .Priority=" + num2str(desc.Priority) + ...
            ", .nInts = 1 , .Ts = 0.001 , .Algn=0, .Ticker = 0}" ;
    end
end
end