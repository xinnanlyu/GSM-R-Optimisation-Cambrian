%{
    Cambrian Beta 1 
    Target: to run the whole BFS in an area within this script
    This will also be useful for Scenario 3

    whole area:  112420*59248

%}
%clear
%profile off
%profile on
%load('CambrianData.mat')
%% Step 1, define area and baseline parameter

%for yvalue=49000:100:49000
yvalue=input('Ymin = ');    
    %fprintf('Ymin is %6.0f\n',yvalue);
xmin=0;
xmax=30000;
ymin=yvalue;
ymax=60000;

interval=500;
thresholdDistance=500;
samples=2906;

%% Step 2, list all possible RBC sites in the area

RBCx=xmin:interval:xmax;
RBCy=ymin:interval:ymax;

sizeX=size(RBCx,2);
sizeY=size(RBCy,2);
totalSize=sizeX*sizeY;

RBCtotal=zeros(totalSize,2);
index=1;
for i=1:sizeX
    for j=1:sizeY
        RBCtotal(index,:)=[RBCx(i),RBCy(j)];
        index=index+1;
    end
end

%% Step 3, get all samples point(track) in the area
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
trackCounter=trackCounter-1;

%% Step 4, filter RBC which are not close to track
RBCindex=1;
distance=zeros(1,trackCounter);
%RBCoptimal=zeros(totalSize,2);

for i=1:totalSize
    RBCselected=RBCtotal(i,:);  %select each RBC from all possible combinations
    
    for track=1:trackCounter    %calculate distance from RBC and track
        train=[trainX(track),trainY(track)];
        distance(track)=norm(train - RBCselected);
    end
    
    if min(distance)<thresholdDistance   % keep the combination if distance is acceptable
        RBCoptimal(RBCindex,:)=RBCselected;
        RBCindex=RBCindex+1;
        %fprintf('*');  %display calculation status
    %else
        %fprintf('-');
    end
    
    %if mod(i,200)==0
        %fprintf('%d finished\n',i);
    %end    
end

RBCsize=size(RBCoptimal,1);

%% Step 5, define communication parameters

RBCnum=3;
txPower=37; % 43dBm=20Watt 37dBm=5W
threshold=-95;

%% Step 6, Perform BFS for all RBC

PLtemp=zeros(1,RBCnum);
RBC=zeros(RBCnum,2);
coverage=zeros(RBCsize,RBCsize,RBCsize);


%% Step 6.0 generate LUT for path loss
PL_LUT=zeros(1,20000);
RBC_LUT=[0,0];

%fprintf('Generating Path Loss LUT...\n');
tic
for i=1:200000
    Train_LUT=[i,0];
    PL_LUT(i)=plain(Train_LUT,RBC_LUT);
end
timer=toc;
%fprintf('Path Loss LUT generated! Time=%4.1f\n',timer);

fprintf('Calculating....\n');

%% Step 6.1 Reduce headways (by 50%)
tic
for indexA=1:RBCsize
    RBC(1,1)=RBCoptimal(indexA,1);
    RBC(1,2)=RBCoptimal(indexA,2);
    
    for indexB=(indexA+1):RBCsize
        RBC(2,1)=RBCoptimal(indexB,1);
        RBC(2,2)=RBCoptimal(indexB,2);
        
        for indexC=(indexB+1):RBCsize
            RBC(3,1)=RBCoptimal(indexC,1);
            RBC(3,2)=RBCoptimal(indexC,2);
        
    
%% Step 6.2 calculate RX for every sample points
successCounter=0;

for i=1:trackCounter
    
    train=[trainX(i),trainY(i)];  %position of train
    
    for temp=1:RBCnum %path loss of all RBCs
        RBCtemp=[RBC(temp,1),RBC(temp,2)];         %position of current RBC
        distanceTemp=norm(RBCtemp - train);
        distanceTemp=round(distanceTemp);
        %PLtemp(temp)=plain(RBCtemp,train);
        PLtemp(temp)=PL_LUT(distanceTemp);
    end
    
    PL=min(PLtemp);
    RX=txPower-PL;

%% Step 6.3 verify whether success reception exist
    
    
    if RX>threshold
        successCounter=successCounter+1;
    end
    
end

coverage(indexA,indexB,indexC)=successCounter*100/trackCounter;

        end
        %fprintf('*');

    end
    
    %fprintf('\n%d/%d complete\t',indexA,RBCsize);
    w=toc;
    %timeCounter=w*(RBCsize-indexA)/indexA;
    %fprintf('%4.1f seconds left\n',timeCounter/3);
    fprintf('*');
end


%% Step 7, find optimal result
maxvalue=max(max(max(coverage)));
fprintf('\nMax coverage is %2.2f\n',maxvalue);
resultCounter=0;
for i=1:RBCsize
    for j=(i+1):RBCsize
        for k=(j+1):RBCsize
            if (coverage(i,j,k)==maxvalue)
                resulti=i;
                resultj=j;
                resultk=k;

                %fprintf('Max coverage is %2.2f\n',maxvalue);
                %fprintf('Result is (%d,%d,%d)\n',i,j,k);
                resultCounter=resultCounter+1;
            end
        end
    end
end

fprintf('Total of %d results found! \n',resultCounter);
%end
%% Step 8, Display Result
%{
    figure()
    scatter(trainX,trainY)
    hold on
    plot(RBCoptimal(resulti,1),RBCoptimal(resulti,2),'o','LineWidth',5,'color','r')
    plot(RBCoptimal(resultj,1),RBCoptimal(resultj,2),'o','LineWidth',5,'color','r')
    plot(RBCoptimal(resultk,1),RBCoptimal(resultk,2),'o','LineWidth',5,'color','r')
    grid on
    hold off
    fprintf('RBC1 X=%d,\t Y=%d\n',RBCoptimal(resulti,1),RBCoptimal(resulti,2));
    fprintf('RBC2 X=%d,\t Y=%d\n',RBCoptimal(resultj,1),RBCoptimal(resultj,2));
    fprintf('RBC3 X=%d,\t Y=%d\n\n',RBCoptimal(resultk,1),RBCoptimal(resultk,2));
%}
%profile report
%profile off