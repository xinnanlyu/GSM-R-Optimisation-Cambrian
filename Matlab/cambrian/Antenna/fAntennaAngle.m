function [ a1,a2 ] = fAntennaAngle( i,trackX,trackY,angle,R)

angleHalf=angle/2;
delta=2;
R0=1e3;  % for distance within 1km, it is considered as full coverage.

Xi=trackX(i);
Yi=trackY(i);

angleResult=[];
sizeResult=[];


%% determine a1


for atemp=1:delta:181

    a1s1=atemp-angleHalf;
    a1s2=atemp+angleHalf;
    
    a1s0=atemp-90;
    a1s3=atemp+90;
    
    xv=[Xi,Xi+R*cosd(a1s1),Xi+R*cosd(a1s2),Xi,...
        Xi+R0*cosd(a1s0),Xi+R0*cosd(atemp),Xi+R0*cosd(a1s3),Xi];
    yv=[Yi,Yi+R*sind(a1s1),Yi+R*sind(a1s2),Yi,...
        Yi+R0*sind(a1s0),Yi+R0*sind(atemp),Yi+R0*sind(a1s3),Yi];
    
    in = inpolygon(trackX,trackY,xv,yv);
    
    size=length(in(in==1));
    
    angleResult=[angleResult,atemp];
    sizeResult=[sizeResult,size];
    
end

maxAngle= max(sizeResult);

maxAngleResult=[];
for i=1:length(sizeResult)
    if(sizeResult(i)==maxAngle)
        maxAngleResult=[maxAngleResult,angleResult(i)];
    end
end
a1=median(maxAngleResult);

%% get rid of a1 coverage area

    a1s1=a1-angleHalf;
    a1s2=a1+angleHalf;
    a1s0=a1-90;
    a1s3=a1+90;

    xv=[Xi,Xi+R*cosd(a1s1),Xi+R*cosd(a1s2),Xi,...
        Xi+R0*cosd(a1s0),Xi+R0*cosd(atemp),Xi+R0*cosd(a1s3),Xi];
    yv=[Yi,Yi+R*sind(a1s1),Yi+R*sind(a1s2),Yi,...
        Yi+R0*sind(a1s0),Yi+R0*sind(atemp),Yi+R0*sind(a1s3),Yi];
    
    in = inpolygon(trackX,trackY,xv,yv);
    
    trackX(in)=[];
    trackY(in)=[];
    %these areas are covered by a1, now let's see r2
    


%% determine a2
angleResult=[];
sizeResult=[];

for atemp=a1+angle+30:delta:360+a1-angle-30    
    
    a2s1=atemp-angleHalf;
    a2s2=atemp+angleHalf;
    
    a2s0=atemp-90;
    a2s3=atemp+90;
    
    xv=[Xi,Xi+R*cosd(a2s1),Xi+R*cosd(a2s2),Xi,...
        Xi+R0*cosd(a2s0),Xi+R0*cosd(atemp),Xi+R0*cosd(a2s3),Xi];
    yv=[Yi,Yi+R*sind(a2s1),Yi+R*sind(a2s2),Yi,...
        Yi+R0*sind(a2s0),Yi+R0*sind(atemp),Yi+R0*sind(a2s3),Yi];
    
    in = inpolygon(trackX,trackY,xv,yv);
    
    size=length(in(in==1));
    
    angleResult=[angleResult,atemp];
    sizeResult=[sizeResult,size];
    
    
end

maxAngle= max(sizeResult);

maxAngleResult=[];
for i=1:length(sizeResult)
    if(sizeResult(i)==maxAngle)
        maxAngleResult=[maxAngleResult,angleResult(i)];
    end
end
a2=median(maxAngleResult);

if a2>360
    a2=a2-360;
end

%fprintf("Antenna 1 = %3.0f degrees\nAntenna 2 = %3.0f degrees\n",a1,a2);
end

