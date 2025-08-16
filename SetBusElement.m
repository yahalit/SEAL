function elem = SetBusElement(name,DataType,Description,Dimensions, MinMax)

if nargin < 4 
    Dimensions = [1,1] ; 
end

if nargin < 3 
    Description = 'Not available' ; 
end
if nargin < 2 
    DataType =  'single' ; 
end

elem  = Simulink.BusElement; 
elem.Name = name ; 
elem.DataType = DataType ; 
elem.Description = Description; 
elem.Dimensions   = Dimensions;  
elem.Complexity   = 'real';

if nargin > 4 
    elem.Min = MinMax(1) ; 
    elem.Max = MinMax(2) ; 
end

end