%{
    This is the formal version of Cambrian Line ABFS
    Scrip. Perform automatic search throughout
    the entire regions

    step 1: Aberystwyth - Dover Junction 
            (The Cambrian Main Line) + Cambrian Coast Line
    step 2: rest of the Cambrian Main Line

    whole area:  112420*59248
    Author @Xinnan Lyu

%}
clear 
profile on
tic
%load('CambrianData.mat')


RBCnum=1;  %initial number

percent=95; %this is the minimum coverage allowed
txPower0=37; % 43dBm=20Watt 37dBm=5W 40dBm=10W
antenna=17;
txPower = txPower0+antenna;
%threshold=-95;
minimum= -95;
threshold=-70;

samples=1074;
interval=300;               %sample interval
thresholdDistance=500;      %distance from track

fprintf('Coverage is %3.2f percent.\n',percent);
fprintf('Interval is %3.0fm.\n',interval);
fprintf('Finding RBC sites...(this may take a long time...)\n')
RBCoptimizer;


xmin=0;
ymin=0;
xmax=0;
ymax=0;

%% Step 0: Generate LUT to reduce scale

PL_LUT=zeros(1,200000);
RBC_LUT=[0,0];

for i=1:200000
    Train_LUT=[i,0];
    PL_LUT(i)=plain(Train_LUT,RBC_LUT);
end


%% Step 2: Dovey Junction - Shrewsbury 

ymin=1000;
ymax=101000;
xmin=1000;
xmax=112000;
breaker=1;

while ( breaker)
    
    fprintf('S1: Finding RBC%2.0f...\n',RBCnum);
    fprintf('Xmin=%1.0f,\tYmin=%1.0f\n',xmin,ymin);
    finder1=1;
    finder2=0;
    

    while finder1==1 && finder2==0
        RBCoptimizeFinder;
        Cambrian_1_RBC_v2;
        
        timer=toc;
        fprintf('Time=%5.1fmin\n',timer/60);
        
        if maxvalue<percent 
            finder1=0;
            finder2=1;
            ymax=ymax-900;
        elseif ymax<(101000+thresholdDistance)
            ymax=ymax+1000;
        else
            break
        end
    end
    
    while finder1==0 && finder2==1
        RBCoptimizeFinder;
        Cambrian_1_RBC_v2;
        
        timer=toc;
        fprintf('Time=%5.1fmin\n',timer/60);
        
        if maxvalue<percent
            ymax=ymax-100;
            finder2=0;
            
        elseif ymax<(59248+thresholdDistance)
            ymax=ymax+100;
        else
            break
        end
    end
    
        RBCoptimizeFinder;
        Cambrian_1_RBC_v2;
        
        RBC(RBCnum,1)=RBCoptimal(resulti,1);
        RBC(RBCnum,2)=RBCoptimal(resulti,2);
        
        fprintf('Optimal RBC site found at x=%4.0f\ty=%4.0f\n\n',RBC(RBCnum,1),RBC(RBCnum,2));
        RBCnum=RBCnum+1;
        ymin=ymax;
        
        if ymax>59248
            breaker=0;
            break
        end
end


%% Result
RBCnum=RBCnum-1;
timer=toc;
fprintf('All RBC found! RBCnum=%2.0f\n',RBCnum);
fprintf('Time=%5.1fs\n',timer);
profile off
profile report