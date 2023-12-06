
%profile on

%Need to Load CambrianData6 to make it work.

BtsA1=zeros(trackLength,1);
BtsA2=zeros(trackLength,1);
angle=input('Antenna Angle = ');
range=15e3;

for i=1:trackLength
    fprintf("*")
end
fprintf("\n")  
%status bar



for i=1:trackLength
    
    [BtsA1(i),BtsA2(i)]=fAntennaAngle( i,trackX,trackY,angle,range);

    fprintf("*")
    
end
fprintf("\n")
%profile off
%profile report
clear i