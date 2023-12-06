%{
    This is the formal version of Cambrian Line BFS
    Script will perform automatic search throughout
    the entire 4 regions, seperated by 4 steps.

    step 1: Aberystwyth - Dover Junction 
            (The Cambrian Main Line)
    step 2: areas at Dovey Junction
            (which require 2 RBC search)
    step 3: Cambrian Coast Line
    step 4: rest of the Cambrian Main Line

    whole area:  112420*59248
    
    version 2: reduce area definition time before calculation
    
    version 3: find one RBC at a time only, too see difference vs v2.

    Author @Xinnan Lyu

%}
%clear 
%profile on
tic
%load('CambrianData.mat')


RBCnum=1;  %initial number

percent=100; %this is the minimum coverage allowed
txPower=30; % 43dBm=20Watt 37dBm=5W 40dBm=10W
antenna=13;
txPower = txPower+ antenna;
txPower
%threshold=-95;
threshold=-85;

samples=3547;
interval=300;               %sample interval
thresholdDistance=500;      %distance from track
fprintf('Coverage is %3.2f percent.\n',percent);
fprintf('Interval is %3.0fm.\n',interval);
fprintf('Finding RBC sites...(this may take a long time...)\n')
RBCoptimizer;
fprintf('RBC sites found! Total=%4.0f\n',OptimalSize);

xmin=0;
ymin=0;
xmax=0;
ymax=0;

step1=1;
step2=0;
step3=0;
step4=0;


%% Step 0: Generate LUT to reduce scale

PL_LUT=zeros(1,200000);
RBC_LUT=[0,0];

for i=1:200000
    Train_LUT=[i,0];
    PL_LUT(i)=plain(Train_LUT,RBC_LUT);
end

%% Step 1: Aberystwyth - Pwillheli
fprintf('Step 1 Start!\n');
xmax=35000;
ymax=1000;
yExpand=1;
while yExpand %ymax<61001
    
    fprintf('Finding RBC%2.0f...\n',RBCnum);
    
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
        elseif ymax<(59248+thresholdDistance)
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
            yExpand=0;
        end
                
end




%% Step 2: Dovey Junction - Shrewsbury 
fprintf('Step 4 Start!\n');
ymin=0;
ymax=59300;
xmin=xmax;
xExpand=1;

while xExpand %xmax<113001
    
    fprintf('Finding RBC%2.0f...\n',RBCnum);
    
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
            xmax=xmax-900;
        elseif xmax<(112420+thresholdDistance)
            xmax=xmax+1000;
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
            xmax=xmax-100;
            finder2=0;
            
        elseif xmax<(113000+thresholdDistance)
            xmax=xmax+100;
        else
            break
        end
    end
    
        RBCoptimizeFinder;
        Cambrian_1_RBC_v2;
        
        timer=toc;
        fprintf('Time=%5.1fmin\n',timer/60);    
        
        RBC(RBCnum,1)=RBCoptimal(resulti,1);
        RBC(RBCnum,2)=RBCoptimal(resulti,2);
        
        fprintf('Optimal RBC site found at x=%4.0f\ty=%4.0f\n\n',RBC(RBCnum,1),RBC(RBCnum,2));
        RBCnum=RBCnum+1;
        xmin=xmax;
        if xmax>112420
            xExpand=0;
        end
        
        
end

RBCnum=RBCnum-1;
timer=toc;
fprintf('All RBC found! RBCnum=%2.0f\n',RBCnum);
fprintf('Time=%5.1fs\n',timer);
%profile off
%profile report