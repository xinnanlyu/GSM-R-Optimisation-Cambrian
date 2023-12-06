

selectNode = input('Select Node=');

colorSet=zeros(1,trackLength);

for i=1:trackLength
    colorSet(i)=addColor(colornet(selectNode,i));
end

colorSet=colornet(selectNode,:);

figure()
scatter(track(:,1),track(:,2),5,colorSet);
axis equal
grid on