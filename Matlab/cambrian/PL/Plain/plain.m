function [ PL ] = plain( RBC, train )
    distance = 0.001*norm(RBC - train);
    PL=46.17 + 34.19*log10(distance)+20*log10(900);
end

