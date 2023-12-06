clear
clc

X=[];
Y=[];
Z=[];
checksum=0;

%%sh
files = dir('C:\Users\Workstation\Desktop\Cambrian5m\sh\*.xyz');
fileLength = length(files);

parfor i=1:fileLength
    [x,y,z] = xyzread(strcat('C:\Users\Workstation\Desktop\Cambrian5m\sh\',files(i).name));
    X=[X;x];
    Y=[Y;y];
    Z=[Z;z];
    fprintf('section SH, file %d complete!\n',i);
end
checksum=checksum+fileLength;

%%sj
files = dir('C:\Users\Workstation\Desktop\Cambrian5m\sj\*.xyz');
fileLength = length(files);

parfor i=1:fileLength
    [x,y,z] = xyzread(strcat('C:\Users\Workstation\Desktop\Cambrian5m\sj\',files(i).name));
    X=[X;x];
    Y=[Y;y];
    Z=[Z;z];
    fprintf('section SJ, file %d complete!\n',i);
end
checksum=checksum+fileLength;
%%sn
files = dir('C:\Users\Workstation\Desktop\Cambrian5m\sn\*.xyz');
fileLength = length(files);

parfor i=1:fileLength
    [x,y,z] = xyzread(strcat('C:\Users\Workstation\Desktop\Cambrian5m\sn\',files(i).name));
    X=[X;x];
    Y=[Y;y];
    Z=[Z;z];
    fprintf('section SN, file %d complete!\n',i);
end
checksum=checksum+fileLength;
%%so

files = dir('C:\Users\Workstation\Desktop\Cambrian5m\so\*.xyz');
fileLength = length(files);

parfor i=1:fileLength
    [x,y,z] = xyzread(strcat('C:\Users\Workstation\Desktop\Cambrian5m\so\',files(i).name));
    X=[X;x];
    Y=[Y;y];
    Z=[Z;z];
    fprintf('section SO, file %d complete!\n',i);
end
checksum=checksum+fileLength;
fprintf('point size is %3.0f billion, checksum is %3.0f\n',size(X,1)/1e6,checksum)
worldX=X;
worldY=Y;
worldZ=Z;
clear X Y Z files fileLength checksum
