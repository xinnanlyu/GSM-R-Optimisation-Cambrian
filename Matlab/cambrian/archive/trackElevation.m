

range=2.5;

%% Track Elevation
trackZ=zeros(trackLength,1);

for i=1:trackLength
    trackXmin=trackX(i)-range;
    trackXmax=trackX(i)+range;
    trackYmin=trackY(i)-range;
    trackYmax=trackY(i)+range;
    rangeIndex=find(world(:,1)<=trackXmax & world(:,1)>=trackXmin & world(:,2)<=trackYmax & world(:,2)>=trackYmin);
    trackZ(i)=mean(world(rangeIndex,3));
    fprintf('Track %3.0f Z=%3.2fm\n',i,trackZ(i))
end

%% Bts Elevation
range=2.5;
BtsZ=zeros(32,1);
for i=1:32
    BtsXmin=BtsX(i)-range;
    BtsXmax=BtsX(i)+range;
    BtsYmin=BtsY(i)-range;
    BtsYmax=BtsY(i)+range;
    rangeIndex=find(world(:,1)<=BtsXmax & world(:,1)>=BtsXmin &...
        world(:,2)<=BtsYmax & world(:,2)>=BtsYmin);
    BtsZ(i)=mean(world(rangeIndex,3));
    fprintf('BTS %2.0f Z=%3.2fm\n',i,BtsZ(i))
end
