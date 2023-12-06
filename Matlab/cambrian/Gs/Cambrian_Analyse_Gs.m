debug=0; % Level 0: no debug, Level 1: no save, Level 2: Profile Report






%% Load Data
try
    loadData;
catch
    load('Data_Cambrian_track.mat')
    load('Data_Antenna_60.mat')
    load('CambrianWorld2.mat')
end

fprintf('Max=3547\n');
fromNode=input('Calculate From=');
endNode=input('Calculate To=');

if debug==2
    profile on
else
    profile off
end


%% Configuration
antennaHalf=angle/2;

startDistance=0.5e3;
endDistance=15e3;
deviation=0.5e3;

Rall=startDistance:deviation:endDistance;
lengthR=length(Rall);

% temp data in every iteration
GsP1_N=zeros(1,lengthR);
GsP2_N=zeros(1,lengthR);

GsP1_H1=zeros(1,lengthR);
GsP2_H1=zeros(1,lengthR);

GsP1_H2=zeros(1,lengthR);
GsP2_H2=zeros(1,lengthR);

H1=15;
H2=30;

%% Result Data
GsP=zeros(trackLength,lengthR,2);
GsP_H1=zeros(trackLength,lengthR,2);
GsP_H2=zeros(trackLength,lengthR,2);

%% Calculation
tic

if debug>0
    fprintf('World Length=%d',length(world));
end


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
    Zi=track(N,3);
    
    
    %% Minimize the Area
    xv0=[Xi,Xi+endDistance/sqrt(3)*cosd(a1s1),Xi+endDistance*cosd(a1s0),Xi+endDistance/sqrt(3)*cosd(a1s2),Xi,...
        Xi+endDistance/sqrt(3)*cosd(a2s1),Xi+endDistance/sqrt(3)*cosd(a2s2),Xi];
    yv0=[Yi,Yi+endDistance/sqrt(3)*sind(a1s1),Yi+endDistance*sind(a1s0),Yi+endDistance/sqrt(3)*sind(a1s2),Yi,...
        Yi+endDistance/sqrt(3)*sind(a2s1),Yi+endDistance/sqrt(3)*sind(a2s2),Yi];
    
    in = inpolygon(world(:,1),world(:,2),xv0,yv0);
    area=[world(in,1),world(in,2),world(in,3)];
    
    if debug>0
        fprintf('Area Length=%d\n',length(area));
        fprintf('IN Length=%d\n',length(in));
    end
    
    fprintf('#')
    
    
    %% Calculate Gs
    for i=1:lengthR
        
        R=Rall(i);
        
        xv1=[Xi,Xi+R/sqrt(3)*cosd(a1s1),Xi+R*cosd(a1s0),Xi+R/sqrt(3)*cosd(a1s2),Xi];
        yv1=[Yi,Yi+R/sqrt(3)*sind(a1s1),Yi+R*sind(a1s0),Yi+R/sqrt(3)*sind(a1s2),Yi];
        
        in = inpolygon(area(:,1),area(:,2),xv1,yv1);
        
        temp = area(in,3)>Zi;
        GsP1_N(i)=sum(temp)/sum(in);
        
        temp = area(in,3)>Zi+H1;
        GsP1_H1(i) = sum(temp)/sum(in);
        
        temp = area(in,3)>Zi+H2;
        GsP1_H2(i) = sum(temp)/sum(in);
        
        
        xv2=[Xi,Xi+R/sqrt(3)*cosd(a2s1),Xi+R*cosd(a2s0),Xi+R/sqrt(3)*cosd(a2s2),Xi];
        yv2=[Yi,Yi+R/sqrt(3)*sind(a2s1),Yi+R*sind(a2s0),Yi+R/sqrt(3)*sind(a2s2),Yi];
        
        in = inpolygon(area(:,1),area(:,2),xv2,yv2);
        
        temp = area(in,3)>Zi;
        GsP2_N(i) = sum(temp)/sum(in);
        
        temp = area(in,3)>Zi+H1;
        GsP2_H1(i) = sum(temp)/sum(in);
        
        temp = area(in,3)>Zi+H2;
        GsP1_H2(i) = sum(temp)/sum(in);
        
        
        fprintf('*')
    end
    
    fprintf('\n')
    
    GsP(N,:,1)=GsP1_N;
    GsP(N,:,2)=GsP2_N;
    
    GsP_H1(N,:,1)=GsP1_H1;
    GsP_H1(N,:,2)=GsP2_H1;
    
    GsP_H2(N,:,1)=GsP1_H2;
    GsP_H2(N,:,2)=GsP2_H2;
    
    
    T2=toc;
    delta=T2-T1;
    ETA=T2*(endNode-N)/(N-fromNode)/60;
    fprintf('N=%4.0f complete, Delta=%2.1fs, ETA %2.1fmin \n',N,delta,ETA);
    
end

%% Save Result

if debug==2
    profile off
    profile report
    
elseif debug==0
    filename1 = sprintf('Data_GsP_%d_%d',fromNode,endNode);
    filename2 = sprintf('Data_GsP_H1_%d_%d',fromNode,endNode);
    filename3 = sprintf('Data_GsP_H2_%d_%d',fromNode,endNode);
    
    save(filename1,'GsP')
    save(filename2,'GsP_H1')
    save(filename3,'GsP_H2')
end


