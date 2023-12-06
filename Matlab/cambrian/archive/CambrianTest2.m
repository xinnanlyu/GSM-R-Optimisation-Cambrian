%clear
%load('CambrianData_withRBCoptimal.mat')

RBCtotalnum=size(RBCoptimal,1);
RBCnum=2;

txPower=37; % 43dBm=20Watt 37dBm=5W
threshold=-95;
successCounter=0;

RBCsize=size(RBCoptimal,1);

%PL=zeros(1,samples);
PLtemp=zeros(1,RBCnum);
RBC=zeros(RBCnum,2);
coverage=zeros(RBCsize,RBCsize);

tic
for indexA=1:RBCsize
    RBC(1,:)=RBCoptimal(indexA,:);
    
    for indexB=(indexA+1):RBCsize
        RBC(2,:)=RBCoptimal(indexB,:);
        
    


for i=1:(trackCounter-1)
    
    train=[trainX(i),trainY(i)];  %position of train
    
    for temp=1:RBCnum %path loss of all RBCs
        RBCtemp=RBC(temp,:);         %position of current RBC
        PLtemp(temp)=plain(RBCtemp,train);
    end
    
    PL=min(PLtemp);
    RX=txPower-PL;
    
    if RX>threshold
        successCounter=successCounter+1;
    end
    
end
coverage(indexA,indexB)=successCounter*100/(trackCounter-1);
successCounter=0;
    end
    
    fprintf('%d/%d complete\t',indexA,RBCsize);
    w=toc;
    timeCounter=w*(RBCsize-indexA)/indexA;
    fprintf('%4.1f seconds left\n',timeCounter/2);
end






%{
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


    %}