if(0)
x=Location';
y=Paths';

xOffset=min(x);
yOffset=min(y);

xCorrected=x-xOffset;
yCorrected=y-yOffset;
end

scatter(xCorrected,yCorrected,'filled')
grid on
title('Cambrian Line')