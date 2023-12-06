%{
        Cambrian v2 plot
        Will show RBC result on Cambrian Line

        also support Cambrian v3 beta


%}
%clear
%filename1='Cambrian_v2_interval400_95percent.mat';
%filename2='Cambrian_v3beta_interval200_99.8percent.mat';

compare=0;

%load(filename1);

figure()
scatter(xCorrected,yCorrected)
hold on

R=10000;
alpha=0:pi/20:2*pi;

%% Doule result plot for compare
if compare
    
%subplot(2,1,1);    
for i=1:RBCnum  %plot result from filename1
    plot(RBC(i,1),RBC(i,2),'o','linewidth',2,'color','r');
    
    x=R*cos(alpha)+RBC(i,1);
    y=R*sin(alpha)+RBC(i,2);
    
    plot(x,y,'-','color','r');
    
end

load(filename2);
%subplot(2,1,2);    
for i=1:RBCnum  %plot result from filename2
    plot(RBC(i,1),RBC(i,2),'o','linewidth',2,'color','b');
    
    x=R*cos(alpha)+RBC(i,1);
    y=R*sin(alpha)+RBC(i,2);
    
    plot(x,y,'-','color','b');
    
end



else
%% Single result plot
    
for i=1:RBCnum
    plot(RBC(i,1),RBC(i,2),'o','linewidth',2,'color','r');
    
    x=R*cos(alpha)+RBC(i,1);
    y=R*sin(alpha)+RBC(i,2);
    
    plot(x,y,'-','color','r');
    
end

end
grid on
axis([0 115000 0 60000])
axis equal
hold off
title('interval=300m, coverage=95%')