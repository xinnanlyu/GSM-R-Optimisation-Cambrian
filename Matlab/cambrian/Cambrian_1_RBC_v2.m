fprintf('Xmax=%4.0f\tYmax=%4.0f\t',xmax,ymax);

RBCsize=size(RBCoptimal,1);

coverage=zeros(1,RBCsize);
PLtemp=zeros(1,RBCnum);

for indexA=1:RBCsize
    
    RBC(RBCnum,1)=RBCoptimal(indexA,1);
    RBC(RBCnum,2)=RBCoptimal(indexA,2);
    
    successCounter=0;
    
    for i=1:trackCounter
        
        train=[trainX(i),trainY(i)];
        
        
        
        
      
        for temp=1:RBCnum %path loss of all RBCs
            
                RBCtemp=[RBC(temp,1),RBC(temp,2)];         %position of current RBC
                distanceTemp=norm(RBCtemp - train);
                distanceTemp=round(distanceTemp)+1;
                PLtemp(temp)=PL_LUT(distanceTemp);
        end

        
        
        
        
        PL=min(PLtemp);
        RX=txPower-PL;
        
        if RX>threshold
            successCounter=successCounter+1;
        end
        
    end
    
    coverage(indexA)=successCounter*100/trackCounter;
end
    

%% find optimal result
maxvalue=max(max(coverage));
fprintf('Max coverage is %3.2f\t',maxvalue);
resultCounter=0;
for i=1:RBCsize
    if (coverage(i)==maxvalue)
        resulti=i;
        resultCounter=resultCounter+1;
    end
end

fprintf('Found %d results \n',resultCounter);