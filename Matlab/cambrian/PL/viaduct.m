% This function requires height of viaduct
% Result is very different from viaductSimple function
% Suggest to use viaductSimple unless verified
% @XinnanLyu   20/06/2016

function [ PL ] = viaduct( RBC, train )
Height=20; %height of viaduct
distance = 0.001*norm(RBC - train);

if distance>0.4
    PL=54.95-(0.2*Height-16.5)*log10(distance);
else
    PL=(0.61*Height+91.75)-(0.43*Height-2.36)*log10(distance);
end

end

