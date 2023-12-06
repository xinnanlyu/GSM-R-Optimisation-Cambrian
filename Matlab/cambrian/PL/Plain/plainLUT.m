close all

d=1:1:115e3; %20km
d=[d,200e3];
log10d = log10(d);

f=923;
hbs=20;
dbp = 4*19*2*923e6/3e8/1000;


%% Calculate LUT
plain=46.17 + 34.19*log10(d/1000)+20*log10(f);
cutting = 71.83 + 43*log10(d/1000);
suburban = 40*log10(d)+10.5-18.5*log10(20)-18.5*log10(3)+1.5*log10(0.93/5);

for i=1:length(d)
    if(d(i)<=dbp)
        suburban(i)=21.5*log10(d(i))+44.2+20*log10(0.93/5);
    else
        break;
    end    
end

 
PL = [d;plain;cutting;suburban];

for i=1:length(d)
    
    if PL(2,i)<0
        PL(2,i)=0;
    end
    
    if PL(3,i)<0
        PL(3,i)=0;
    end
    
    if PL(4,i)<0
        PL(4,i)=0;
    end
    
end



%% Generate LUT based on relativeDistance

load('relativeDistance.mat')

% fix relative distance

D(find(D==0))=1;
clear index

PL_RD = zeros(3547,3547,3);
for x=1:3547
    for y=1:3547        
        PL_RD(x,y,1)=PL(2,D(x,y));
        PL_RD(x,y,2)=PL(3,D(x,y));
        PL_RD(x,y,3)=PL(4,D(x,y));
    end
    fprintf("*")
end
fprintf("\n")
plain=1;
cutting=2;
suburban=3;

