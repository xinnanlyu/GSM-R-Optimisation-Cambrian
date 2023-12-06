load('Data_DetermineWhichAntenna.mat')

antennaIndex = input('Load Antenna No.');

R=15e3;

angle=60;

figure()

plot(trackX,trackY,'o','color','k')
hold on
grid on
axis equal


Xi=trackX(antennaIndex);
Yi=trackY(antennaIndex);

a1s1=BtsA(antennaIndex,1)-angle/2;
a1=BtsA(antennaIndex-1);
a1s2=BtsA(antennaIndex,1)+angle/2;

a2s1=BtsA(antennaIndex,2)-angle/2;
a2=BtsA(antennaIndex,2);
a2s2=BtsA(antennaIndex,2)+angle/2;

xv1=[Xi,Xi+R*cosd(a1s1),Xi+R*cosd(a1s2),Xi];
yv1=[Yi,Yi+R*sind(a1s1),Yi+R*sind(a1s2),Yi];

xv2=[Xi,Xi+R*cosd(a2s1),Xi+R*cosd(a2s2),Xi];
yv2=[Yi,Yi+R*sind(a2s1),Yi+R*sind(a2s2),Yi];

plot(Xi,Yi,'o','LineWidth',5,'color','r')
plot(xv1,yv1,'color','r')
plot(xv2,yv2,'color','b')

fprintf('A1=%3.0f\tA2=%3.0f\n',a1,a2)
