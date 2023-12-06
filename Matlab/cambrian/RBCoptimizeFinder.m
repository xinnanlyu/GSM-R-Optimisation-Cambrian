clear trainX trainY RBCoptimal


optimalIndex=1;
trackCounter=1;
for i=1:OptimalSize
    
    if RBCoptimalAll(i,1)<xmax
        if RBCoptimalAll(i,2)<ymax
            RBCoptimal(optimalIndex,:)=RBCoptimalAll(i,:);
            optimalIndex=optimalIndex+1;
        end
    end
    
end

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
%fprintf('* ');