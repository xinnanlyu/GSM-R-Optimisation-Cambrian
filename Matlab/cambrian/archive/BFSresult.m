%clear
%load('CambrianData.mat')
%{
RBCnum=17;

RBC=zeros(RBCnum,2);

RBC(1,:)=[5500,56710];
RBC(2,:)=[17500,59310];
RBC(3,:)=[22500,54310];
RBC(4,:)=[21000,43000];
RBC(5,:)=[22500,30700];
RBC(6,:)=[21500,19900];
RBC(7,:)=[35000,18900];
RBC(8,:)=[26000,12600];
RBC(9,:)=[25000,5500];
RBC(10,:)=[46000,24000];
RBC(11,:)=[56500,18500];
RBC(12,:)=[66000,11000];
RBC(13,:)=[77500,12500];
RBC(14,:)=[85000,22000];
RBC(15,:)=[91500,31000];
RBC(16,:)=[103500,30000];
RBC(17,:)=[112500,32500];


samples=2906;

txPower=37; % 43dBm=20Watt 37dBm=5W
threshold=-95;

PLtemp=zeros(1,RBCnum);
%}
RX=zeros(1,samples);

for i=1:samples
    train=[xCorrected(i),yCorrected(i)];
    for temp=1:RBCnum
        RBCtemp=[RBC(temp,1),RBC(temp,2)];
        PLtemp(temp)=plain(train,RBCtemp);
    end
    
    PL=min(PLtemp);
    RX(i)=txPower-PL;
end

figure()
scatter3(xCorrected/1000,yCorrected/1000,RX,[],RX);
colorbar

interval=5;

set(gca,'xtick',0:interval:120,'ytick',0:interval:70);
xlabel('X Coordinates in km');
ylabel('Y Coordinates in km');
title('Cambrian Line BFS Result')
hold on

if 0
R=6057;
alpha=0:pi/20:2*pi;

for i=1:RBCnum
    plot(RBC(i,1)/1000,RBC(i,2)/1000,'o','color','r','linewidth',5)
    
    x=R*cos(alpha)+RBC(i,1);
    y=R*sin(alpha)+RBC(i,2);
    plot(x/1000,y/1000,'-','color','b');
    
    
end    
end