trackXmin=min(track(:,1))-5e3;
trackXmax=max(track(:,1))+5e3;
trackYmin=min(track(:,2))-5e3;
trackYmax=max(track(:,2))+5e3;

rangeIndex=find(world(:,1)<=trackXmax & world(:,1)>=trackXmin & ...
    world(:,2)<=trackYmax & world(:,2)>=trackYmin);
%%
world2=zeros(size(rangeIndex,1),3);
world2(:,1)=world(rangeIndex,1);
world2(:,2)=world(rangeIndex,2);
world2(:,3)=world(rangeIndex,3);
clear trackXmax trackXmin trackYmax trackYmin rangeIndex Bts track