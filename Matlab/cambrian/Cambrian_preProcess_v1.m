

clear all

%%  Default Parameter

txPower = 37; %dBm
antennaGain = 17; %dBi
P_ETCS2 = -95; %dBm
P_ETCS2_HS = -92; %dBm


%% Define Antenna Angle

load('Data_Antenna_60.mat')

%% Define Railway

load('Data_Cambrian_track.mat')

%% Load Gs Data

load('Gs\Gs_60_15e3.mat')