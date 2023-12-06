% generate genes
Xmax=345e3;
Xmin=315e3;


NodeCounter=0;
BTSCounter=0;
for i=1:3547
    if(trackX(i)<Xmax && trackX(i)>=Xmin)
        NodeCounter = NodeCounter+1;
    end
end


selectedNode = zeros(NodeCounter,1);

index=1;
for i=1:3547
    if(trackX(i)<Xmax && trackX(i)>=Xmin)
        selectedNode(index) = i;
        index=index+1;
    end
end



for i=1:32
    if(BtsX(i)<Xmax && BtsX(i)>=Xmin)
        BTSCounter = BTSCounter+1;
    end
end

Comnbinations = nchoosek(NodeCounter,BTSCounter);
averageTime=0.001;
estimateTimeH = Comnbinations*averageTime/60/60;

%set=1:NodeCounter;
%chosenSet = combntns(set,BTSCounter);

fprintf("Node=%d, BTS=%d\n",NodeCounter,BTSCounter)
fprintf("Estimate %4.1f hours\n",estimateTimeH);



