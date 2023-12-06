filename='terrain-5-dtm-SH53NW.xyz';
filename2='terrain-5-dtm-SH53NE.xyz';
filename3='terrain-5-dtm-SH53NW.xyz';
X=[];
Y=[];
Z=[];



[x,y,z] = xyzread(filename);

X=[X;x];
Y=[Y;y];
Z=[Z;z];
sigma=std(z)

[x,y,z] = xyzread(filename2);

X=[X;x];
Y=[Y;y];
Z=[Z;z];
sigma=std(z)

[x,y,z] = xyzread(filename3);

X=[X;x];
Y=[Y;y];
Z=[Z;z];
sigma=std(z)


figure(1)
scatter3(X/1000,Y/1000,Z,[],Z);
colorbar
%G=xyz2grid(x,y,z);
%surf(G)