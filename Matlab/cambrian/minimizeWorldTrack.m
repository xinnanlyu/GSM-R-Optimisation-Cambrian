range=15e3;
%world2=world;
world3=[];
for i=1:3547
    trackXmin=track(i,1)-range;
    trackXmax=track(i,1)+range;
    trackYmin=track(i,2)-range;
    trackYmax=track(i,2)+range;
    
    rangeIndex=find(world2(:,1)<=trackXmax & world2(:,1)>=trackXmin & ...
    world2(:,2)<=trackYmax & world2(:,2)>=trackYmin);
    
    worldTemp=zeros(size(rangeIndex,1),3);
    for j=1:3
        worldTemp(:,j)=world2(rangeIndex,j);
    end
    
    world3=[world3;worldTemp];
    world2(rangeIndex,:)=[];
        
    fprintf('Track %3.0f Complete! world size=%9.0f\n',i,size(world2,1))
end

    


