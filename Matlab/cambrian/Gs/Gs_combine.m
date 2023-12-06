clear

%% Load and combine Data
load('Data_Gs1_1_900.mat')
load('Data_Gs2_1_900.mat')

Gs1_temp=Gs1;
Gs2_temp=Gs2;

load('Data_Gs1_901_1800.mat')
load('Data_Gs2_901_1800.mat')

Gs1_temp=Gs1_temp+Gs1;
Gs2_temp=Gs2_temp+Gs2;

load('Data_Gs1_1801_2700.mat')
load('Data_Gs2_1801_2700.mat')

Gs1_temp=Gs1_temp+Gs1;
Gs2_temp=Gs2_temp+Gs2;

load('Data_Gs1_2701_3547.mat')
load('Data_Gs2_2701_3547.mat')

Gs1_temp=Gs1_temp+Gs1;
Gs2_temp=Gs2_temp+Gs2;


%% Merge all data

Gs=zeros(3547,30,2);

Gs(:,:,1)=Gs1_temp;
Gs(:,:,2)=Gs2_temp;

clear Gs1 Gs2 Gs1_temp Gs2_temp

save('Gs_60_15e3','Gs')

