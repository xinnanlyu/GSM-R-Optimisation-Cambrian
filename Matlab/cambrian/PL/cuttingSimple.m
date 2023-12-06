function [ PL ] = cuttingSimple( RBC, train )


    distance = 0.001*norm(RBC - train);
    PL=71.83 + 43*log10(distance);


end

