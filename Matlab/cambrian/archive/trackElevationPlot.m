btsLength=32;
BtsZ=zeros(32,1);
range=2.5;

for i=1:btsLength
    btsXmin=BtsX(i)-range;
    btsXmax=BtsX(i)+range;
    btsYmin=BtsY(i)-range;
    btsYmax=BtsY(i)+range;
    rangeIndex=find(world(:,1)<=btsXmax & world(:,1)>=btsXmin & world(:,2)<=btsYmax & world(:,2)>=btsYmin);
    BtsZ(i)=mean(world(rangeIndex,3))+BtsH(i);
    fprintf('BTS %3.0f Z=%3.2fm\n',i,BtsZ(i))
end




scatter3(trackX,trackY,trackZ,[],trackZ);

colorbar
hold on
scatter3(BtsX, BtsY, BtsZ, [], 'r')


for i=1:32
    plot3([BtsX(i),BtsX(i)],[BtsY(i),BtsY(i)],[BtsZ(i)-BtsH(i),BtsZ(i)],'r');
end
hold off