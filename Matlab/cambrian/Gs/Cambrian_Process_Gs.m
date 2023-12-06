

%% Load Data
try
    loadData;
    loadData=0;
catch
    loadData=1;
end

fprintf('Max=3547\n');
fromNode=input('Calculate From=');
endNode=input('Calculate To=');

%%profile on

if loadData==1
    load('Data_Cambrian_track.mat')
    load('Data_Antenna_60.mat')
    load('CambrianWorld2.mat')
end


%% Configuration
antennaHalf=angle/2;

startDistance=0.5e3;
endDistance=15e3;
deviation=0.5e3;

Rall=startDistance:deviation:endDistance;
lengthR=length(Rall);
Gs1_N=zeros(1,lengthR);
Gs2_N=zeros(1,lengthR);

%% Result

Gs1 = zeros(trackLength,lengthR);
Gs2 = zeros(trackLength,lengthR);

%% Temp Data




%% Calculation
tic
for N=fromNode:endNode
    T1=toc;
    
    %% Define Angles and Locations
    a1s0=BtsA1(N);
    a1s1=BtsA1(N)-antennaHalf;
    a1s2=BtsA1(N)+antennaHalf;
    
    a2s0=BtsA2(N);
    a2s1=BtsA2(N)-antennaHalf;
    a2s2=BtsA2(N)+antennaHalf;
    
    Xi=track(N,1);
    Yi=track(N,2);
    
    
    %% Minimize the Area
    xv0=[Xi,Xi+endDistance/sqrt(3)*cosd(a1s1),Xi+endDistance*cosd(a1s0),Xi+endDistance/sqrt(3)*cosd(a1s2),Xi,...
        Xi+endDistance/sqrt(3)*cosd(a2s1),Xi+endDistance/sqrt(3)*cosd(a2s2),Xi];
    yv0=[Yi,Yi+endDistance/sqrt(3)*sind(a1s1),Yi+endDistance*sind(a1s0),Yi+endDistance/sqrt(3)*sind(a1s2),Yi,...
        Yi+endDistance/sqrt(3)*sind(a2s1),Yi+endDistance/sqrt(3)*sind(a2s2),Yi];
    
    in = inpolygon(world(:,1),world(:,2),xv0,yv0);
    area=[world(in,1),world(in,2),world(in,3)];
    
    fprintf('#')

    
    %% Calculate Gs
    for i=1:lengthR
        
        R=Rall(i);
        
        xv1=[Xi,Xi+R/sqrt(3)*cosd(a1s1),Xi+R*cosd(a1s0),Xi+R/sqrt(3)*cosd(a1s2),Xi];
        yv1=[Yi,Yi+R/sqrt(3)*sind(a1s1),Yi+R*sind(a1s0),Yi+R/sqrt(3)*sind(a1s2),Yi];
        
        in = inpolygon(area(:,1),area(:,2),xv1,yv1);
        Gs1_N(i) = std(area(in,3));
        
        xv2=[Xi,Xi+R/sqrt(3)*cosd(a2s1),Xi+R*cosd(a2s0),Xi+R/sqrt(3)*cosd(a2s2),Xi];
        yv2=[Yi,Yi+R/sqrt(3)*sind(a2s1),Yi+R*sind(a2s0),Yi+R/sqrt(3)*sind(a2s2),Yi];
        
        in = inpolygon(area(:,1),area(:,2),xv2,yv2);
        Gs2_N(i) = std(area(in,3));
        
        fprintf('*')
    end
    
    fprintf('\n')
    
    Gs1(N,:)=Gs1_N;
    Gs2(N,:)=Gs2_N;
    T2=toc;
    delta=T2-T1;
    ETA=T2*(endNode-N)/(N-fromNode)/60;
    fprintf('N=%4.0f complete, Delta=%2.1fs, ETA %2.1fmin \n',N,delta,ETA);
    
end

filename1 = sprintf('./Gs/Data_Gs1_%d_%d',fromNode,endNode);
filename2 = sprintf('./Gs/Data_Gs2_%d_%d',fromNode,endNode);

save(filename1,'Gs1')
save(filename2,'Gs2')

%profile off
%profile report