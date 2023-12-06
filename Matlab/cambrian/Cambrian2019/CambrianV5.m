
%% Step 1  System Config

TX = 33; %Transmit Power 2W
G = 12; %Antenna Gain dBd
Prob=0.95; %confidence level
Pmin=-95; %min Pr in dBm

% process data
Pt = TX+G;


%% Step 2 Load LUT

% Load Network
load('Data_Cambrian_base.mat')

% Path loss LUT
load('PL_LUT.mat')

% Antenna values
load('Data_Antenna_60.mat') % antenna 1 and 2, angle starting from x axis
load('Data_AntennaBelong_60.mat') % 1-referenceNode 2-antenna for sample node

% TRI LUT
load('TRI_inc_Range.mat')

% Std LUT
load('Gs_60_15e3.mat') % every 500m deviation, antenna 1 and 2

% Confidence Level - delay ms LUT


%% Step 3 generate gene
% Use BTS or GA to generate genes
% if BTS, then may destroy when finish calculation.

population=100;
N=20;

genes = zeros(population,length(trackX));

for i=1:population
    locations=getRand(1,3547,N);
    genes(i,locations)=1;
end

%% Step 4 mutate and cross

pmutate=0.5;
pcross=0.5;

