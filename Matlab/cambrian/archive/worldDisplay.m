
Display3D=input('Display 3D? =');
LoadData=input('Load 3D Data?=');
if LoadData
    load('CambrianWorld3.mat')
    load('CambrianDataCore.mat')
end

figure()
scatter(track(:,1),track(:,2),[],track(:,3))


fprintf('X:215003-359998\tY:275003-349998\n');
xMin=input('X From=');
xMax=input('X To=');
yMin=input('Y From=');
yMax=input('Y To=');
memory=(xMax-xMin)*(yMax-yMin)/2.5e7;
fprintf('%2.1fGB memory will be used, proceed?',memory);
RAMcheck=input('');

areaIndex=find(world(:,1)<=xMax & world(:,1)>=xMin & world(:,2)<=yMax & world(:,2)>=yMin);
trackIndex=find(track(:,1)<=xMax & track(:,1)>=xMin & track(:,2)<=yMax & track(:,2)>=yMin);
area=world(areaIndex,:,:);
areaTrack=[track(trackIndex,1),track(trackIndex,2),track(trackIndex,3)];
%figure(1)
%scatter3(area(:,1),area(:,2),area(:,3),[],area(:,3))
figure()
if Display3D==1
    scatter3(area(:,1),area(:,2),area(:,3),[],area(:,3));
    hold on
    scatter3(areaTrack(:,1),areaTrack(:,2),areaTrack(:,3),[],'r')
else
    scatter(area(:,1),area(:,2),[],area(:,3))
    hold on
    scatter(areaTrack(:,1),areaTrack(:,2),[],'r')
    axis equal
end
hold off
colorbar