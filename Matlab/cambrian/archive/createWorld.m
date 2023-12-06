clear
load CambrianData2.mat

%xSize=xMax-xMin+1;
%ySize=yMax-yMin+1;

%fprintf('%8.0f, %8.0f',xSize,ySize)

resolution=10;

worldX= xMin:resolution:xMax;
worldY= yMin:resolution:yMax;

sizeX=size(worldX,2);
sizeY=size(worldY,2);

world =zeros(sizeX*sizeY,3);
%world=zeros(112420*59249,1);
w=1;
for i=1:sizeX
    for j=1:sizeY
        world(w,:)=[worldX(i),worldY(j),0];
        w=w+1;
    end
end
