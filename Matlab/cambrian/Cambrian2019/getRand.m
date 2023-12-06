function [randArray] = getRand(minValue,maxValue,quantity)

randArray=minValue+randperm(maxValue-minValue+1,quantity)-1;

end

