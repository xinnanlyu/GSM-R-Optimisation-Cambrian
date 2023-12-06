
RBCx=0:interval:112000;
RBCy=0:interval:102000;

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


RBCindex=1;
distance=zeros(1,samples);

for i=1:totalSize
    RBCselected=RBCtotal(i,:);  %select each RBC from all possible combinations
    
    for track=1:samples    %calculate distance from RBC and track
        train=[xCorrected(track),yCorrected(track)];
        distance(track)=norm(train - RBCselected);
    end
    
    if min(distance)<thresholdDistance   % keep the combination if distance is acceptable
        RBCoptimalAll(RBCindex,:)=RBCselected;
        RBCindex=RBCindex+1;
    end
end

OptimalSize=size(RBCoptimalAll,1);
fprintf('RBC sites found! Total=%4.0f\n',OptimalSize);