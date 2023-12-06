%clear all
tic
%load('CambrianData.mat')

%% parameters
%xmax=112420;
%ymax=59248;

xmin=0;
xmax=30000;
ymin=30000;
ymax=60000;

interval=500;
thresholdDistance=500;

RBCx=xmin:interval:xmax;
RBCy=ymin:interval:ymax;

sizeX=size(RBCx,2);
sizeY=size(RBCy,2);
totalSize=sizeX*sizeY;

%% all possible RBC sites
RBCtotal=zeros(totalSize,2);
index=1;
for i=1:sizeX
    for j=1:sizeY
        RBCtotal(index,:)=[RBCx(i),RBCy(j)];
        index=index+1;
    end
end

samples=size(x,2);


%% sample area
trackCounter=1;
for i=1:samples
    trackX=xCorrected(i);
    trackY=yCorrected(i);
    
    if trackX<=xmax && trackX>=xmin
        if trackY<=ymax && trackY>=ymin
            trainX(1,trackCounter)=trackX;
            trainY(1,trackCounter)=trackY;
            trackCounter=trackCounter+1;
        end
    end
end
    
    


%% optimize RBC site scale
RBCindex=1;
distance=zeros(1,samples);
%RBCoptimal=zeros(totalSize,2);

for i=1:totalSize
    RBCselected=RBCtotal(i,:);  %select each RBC from all possible combinations
    
    for track=1:samples    %calculate distance from RBC and track
        train=[xCorrected(track),yCorrected(track)];
        distance(track)=norm(train - RBCselected);
    end
    
    if min(distance)<thresholdDistance   % keep the combination if distance is acceptable
        RBCoptimal(RBCindex,:)=RBCselected;
        RBCindex=RBCindex+1;
        
        fprintf('*');  %display calculation status
    else
        fprintf('-');
    end
    
    if mod(i,100)==0
        fprintf('\n %d finished\n',i);
        
    end
    
    
    
end

toc