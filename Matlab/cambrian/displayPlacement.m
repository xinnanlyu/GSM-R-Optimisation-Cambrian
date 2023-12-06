
%% correction

RBC_IA = zeros(29,2);

for i=1:29
    RBC_IA(i,1) = RBC(i,1)+xOffset;
    RBC_IA(i,2) = RBC(i,2)+yOffset;
end


%% plot IA

figure()
plot(track(:,1),track(:,2),'.','color','k')
hold on
axis equal
grid on
plot(BtsX,BtsY,'*','linewidth',3,'color','c')

plot(RBC_IA(:,1),RBC_IA(:,2),'*','linewidth',3,'color','r')

legend('railway track','existing BTS', 'optimised BTS')

%{
angle=60;
R=5e3;

for s=1:29
    antennaIndex = ()
    Xi=track(antennaIndex,1);
    Yi=track(antennaIndex,2);
    
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
    
    plot(xv1,yv1,'color','y')
    plot(xv2,yv2,'color','y')
end
%}

%% plot GA

placement = best(2,:);
BTS_GA = [track(placement,1),track(placement,2)];

figure()
plot(track(:,1),track(:,2),'.','color','k')
hold on
axis equal
grid on
plot(BtsX,BtsY,'*','linewidth',3,'color','c')

plot(BTSOptimal(:,1),BTSOptimal(:,2),'*','linewidth',3,'color','r')

legend('railway track','existing BTS', 'optimised BTS')