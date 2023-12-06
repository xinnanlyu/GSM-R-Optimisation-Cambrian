clear

debug=0;

%% Load and combine Data
load('Data_GsP_1_900.mat')
load('Data_GsP_H1_1_900.mat')
load('Data_GsP_H2_1_900.mat')

GsP_temp=GsP;
GsP_H1_temp=GsP_H1;
GsP_H2_temp=GsP_H2;

load('Data_GsP_901_1800.mat')
load('Data_GsP_H1_901_1800.mat')
load('Data_GsP_H2_901_1800.mat')

GsP_temp=GsP_temp+GsP;
GsP_H1_temp=GsP_H1_temp+GsP_H1;
GsP_H2_temp=GsP_H2_temp+GsP_H2;

load('Data_GsP_1801_2700.mat')
load('Data_GsP_H1_1801_2700.mat')
load('Data_GsP_H2_1801_2700.mat')

GsP_temp=GsP_temp+GsP;
GsP_H1_temp=GsP_H1_temp+GsP_H1;
GsP_H2_temp=GsP_H2_temp+GsP_H2;

load('Data_GsP_2701_3547.mat')
load('Data_GsP_H1_2701_3547.mat')
load('Data_GsP_H2_2701_3547.mat')

GsP_temp=GsP_temp+GsP;
GsP_H1_temp=GsP_H1_temp+GsP_H1;
GsP_H2_temp=GsP_H2_temp+GsP_H2;


%% Merge all data

GsP=GsP_temp;
GsP_H1=GsP_H1_temp;
GsP_H2=GsP_H2_temp;




if debug==0
save('GsP_60_15e3','GsP')
save('GsP_H1_60_15e3','GsP_H1')
save('GsP_H2_60_15e3','GsP_H2')
end


clear GsP_temp GsP_H1_temp GsP_H2_temp debug