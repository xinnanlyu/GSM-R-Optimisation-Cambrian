files = dir('D:\Download_Cambrian_751082\Cambrian5m\sh\*.xyz');
fileLength = length(files);

X=[];
Y=[];
Z=[];

for i=1:1
    [x,y,z] = xyzread(strcat('D:\Download_Cambrian_751082\Cambrian5m\sh\',files(i).name));
    X=[X;x];
    Y=[Y;y];
    Z=[Z;z];
    fprintf('section SH, file %d complete!\n',i);
end

surface(X,Y,Z)