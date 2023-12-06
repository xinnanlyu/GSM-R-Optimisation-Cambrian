clear all
load('CambrianData.mat')

xmax=max(xCorrected);
ymax=max(yCorrected);

RBCnum=9;

RBC=zeros(RBCnum,2);

RBC(1,:)=[10510,57320];
RBC(2,:)=[20460,47230];
RBC(3,:)=[82650,17360];
RBC(4,:)=[23900,31920];
RBC(5,:)=[26550,16080];
RBC(6,:)=[46210,23330];
RBC(7,:)=[59060,16050];
RBC(8,:)=[93170,31740];
RBC(9,:)=[24470,1474];

samples=size(x,2);


txPower=43; % 43dBm=20Watt 37dBm=5W

%PL=zeros(1,samples);
RX=zeros(1,samples);
C=zeros(1,samples);

RBCtemp=0;
PL=0;
PLtemp=zeros(1,RBCnum);


threshold=-95;
successCounter=0;

for i=1:samples
    
    train=[xCorrected(i),yCorrected(i)];  %position of train
    
    for temp=1:RBCnum %path loss of all RBCs
        RBCtemp=RBC(temp,:);         %position of current RBC
        PLtemp(temp)=plain(RBCtemp,train);
    end
    
    PL=min(PLtemp);
    RX(i)=txPower-PL;
    
    if RX(i)>threshold
        successCounter=successCounter+1;
    end
end

figure(1)
scatter3(xCorrected,yCorrected,RX,[],RX);
colorbar

interval=5000;

set(gca,'xtick',0:interval:xmax,'ytick',0:interval:ymax);

fprintf('RBC successfully covered %2.2f percent area\n',successCounter*100/samples);

%hold on

%plot3(RBC(1,:),RBC(2,:),-130,'o','LineWidth',20,'color','r') %which is the RBC1


%figure(2)
%mesh(xCorrected,yCorrected,RX)


    