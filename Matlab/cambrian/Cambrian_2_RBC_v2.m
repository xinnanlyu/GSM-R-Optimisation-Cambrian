fprintf('Xmax=%4.0f\tYmax=%4.0f\t',xmax,ymax);

RBCsize=size(RBCoptimal,1);

PLtemp=zeros(1,RBCnum);
coverage=zeros(RBCsize,RBCsize);


for indexA=1:RBCsize
    RBC(RBCnum-1,1)=RBCoptimal(indexA,1);
    RBC(RBCnum-1,2)=RBCoptimal(indexA,2);
    
    for indexB=indexA:RBCsize
        RBC(RBCnum,1)=RBCoptimal(indexB,1);
        RBC(RBCnum,2)=RBCoptimal(indexB,2);
    
    
    successCounter=0;
    
    for i=1:trackCounter
        
        train=[trainX(i),trainY(i)];
        
        for temp=1:RBCnum %path loss of all RBCs
            RBCtemp=[RBC(temp,1),RBC(temp,2)];         %position of current RBC
            distanceTemp=norm(RBCtemp - train);
            distanceTemp=round(distanceTemp)+1;
            %PLtemp(temp)=plain(RBCtemp,train);
            PLtemp(temp)=PL_LUT(distanceTemp);
        end
        
        PL=min(PLtemp);
        RX=txPower-PL;
        
        if RX>threshold
            successCounter=successCounter+1;
        end
        
    end
    
    coverage(indexA,indexB)=successCounter*100/trackCounter;
    end
end
    

%% Step 7, find optimal result
maxvalue=max(max(coverage));
fprintf('Max coverage is %3.2f\t',maxvalue);
resultCounter=0;
for i=1:RBCsize
    for j=i:RBCsize
    if (coverage(i,j)==maxvalue)
        resulti=i;
        resultj=j;
        resultCounter=resultCounter+1;
    end
    end
end

fprintf('Found %3.0f results \n',resultCounter);