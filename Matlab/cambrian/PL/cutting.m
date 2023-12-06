function [ PL ] = cutting( RBC, train )

distance = 0.001*norm(RBC - train);
Wup=50;
Wdown=40;
x=rand([1 1]); % X need to determine what it is.
deep = true;

if deep
    PL=32.45+10*(13.05*exp(-0.039*(Wup-Wdown)))*log10(distance)+(0.3*Wdown^2-10.09*Wdown+88.62)*x;
else
    PL=32.45+(-0.16*(Wup+Wdown)+13.75)*x+10*(1.66*Wdown^2-58.51*Wdown+517.6)*log10(distance);
end


end

