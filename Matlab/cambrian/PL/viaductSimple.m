function [ PL ] = viaductSimple( RBC, train )

    distance = 0.001*norm(RBC - train);
    PL=42.305 + 26.26*log10(distance)+20*log10(900);
end

