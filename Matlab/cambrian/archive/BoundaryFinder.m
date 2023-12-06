load('CambrianData.mat')
RBCnum=17;

xvalue=110000;
delta=1000;
finder1=1;
finder2=0;

RBC=zeros(RBCnum,2);

RBC(1,:)=[5500,56710];
RBC(2,:)=[17500,59310];
RBC(3,:)=[22500,54310];
RBC(4,:)=[21000,43000];
RBC(5,:)=[22500,30700];
RBC(6,:)=[21500,19900];
RBC(7,:)=[35000,18900];
RBC(8,:)=[26000,12600];
RBC(9,:)=[25000,5500];
RBC(10,:)=[46000,24000];
RBC(11,:)=[56500,18500];
RBC(12,:)=[66000,11000];
RBC(13,:)=[77500,12500];
RBC(14,:)=[85000,22000];
RBC(15,:)=[91500,31000];
RBC(16,:)=[103500,30000];
RBC(17,:)=[112500,32500];
%% Step 2, list all possible RBC sites in the area




fprintf('Generating Path Loss LUT.....\n');
PL_LUT=zeros(1,200000);
RBC_LUT=[0,0];

for i=1:200000
    Train_LUT=[i,0];
    PL_LUT(i)=plain(Train_LUT,RBC_LUT);
end

fprintf('Generation Complete!\n');

%% Large Scale Finder
while finder1==1
    Cambrian_1_RBC;
    
    xvalue=xvalue+delta;
    
    if maxvalue<100
        finder1=0;
        finder2=1;
        delta=100;
        xvalue=xvalue-1900;
    end
end

%% Small Scale Finder
while finder1==0 && finder2==1
    Cambrian_1_RBC;
    
    xvalue=xvalue+delta;
    
    if maxvalue<100
        finder2=0;
        xvalue=xvalue-200;
    end
end

%% Result Output

if finder1==0 && finder2==0
    fprintf('\n\nOptimal Result Found at X=%4.0f\n',xvalue);
    %Cambrian_1_RBC;
end
