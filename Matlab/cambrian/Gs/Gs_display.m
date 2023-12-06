%{

        Display Gs and GsP result, require Data_Cambrian_track to fully
        display.

load('Data_Antenna_60.mat')
load('Data_Cambrian_track.mat')

load('Gs_60_15e3.mat')
load('GsP_60_15e3.mat')
load('GsP_H1_60_15e3.mat')
load('GsP_H2_60_15e3.mat')

%}



N=input('Display N=');
R=0.5e3:0.5e3:15e3;


%% Display Gs
figure(1)
subplot(2,1,1)
plot(R,Gs(N,:,1))
title('Gs, A=1')
subplot(2,1,2)
plot(R,Gs(N,:,2))
title('Gs, A=2')

%% Display GsP > track(,,3)
figure(2)
subplot(2,1,1)
plot(R,GsP(N,:,1))
title('GsP, A=1')
subplot(2,1,2)
plot(R,GsP(N,:,2))
title('GsP, A=2')

%% Display GsP > track(,,3) + H1
figure(3)
subplot(2,1,1)
plot(R,GsP_H1(N,:,1))
title('GsP_H1, A=1')
subplot(2,1,2)
plot(R,GsP_H1(N,:,2))
title('GsP_H1, A=2')

%% Display GsP > track(,,3) + H2
figure(4)
subplot(2,1,1)
plot(R,GsP_H2(N,:,1))
title('GsP_H1, A=1')
subplot(2,1,2)
plot(R,GsP_H2(N,:,2))
title('GsP_H1, A=2')


%% Display Antenna
figure(5)

Xi=track(N,1);
Yi=track(N,2);
Rmax=15e3;

a1s1=BtsA(N,1)-angle/2;
a1=BtsA(N);
a1s2=BtsA(N,1)+angle/2;

a2s1=BtsA(N,2)-angle/2;
a2=BtsA(N,2);
a2s2=BtsA(N,2)+angle/2;

xv=[Xi,Xi+Rmax*cosd(a1s1),Xi+Rmax*cosd(a1s2),Xi,Xi+Rmax*cosd(a2s1),Xi+Rmax*cosd(a2s2),Xi];
yv=[Yi,Yi+Rmax*sind(a1s1),Yi+Rmax*sind(a1s2),Yi,Yi+Rmax*sind(a2s1),Yi+Rmax*sind(a2s2),Yi];

plot(track(:,1),track(:,2),'*')
hold on
plot(track(N,1),track(N,2),'o','LineWidth',5,'Color','r')
plot(xv,yv,'color','r')
axis equal
hold off
grid on