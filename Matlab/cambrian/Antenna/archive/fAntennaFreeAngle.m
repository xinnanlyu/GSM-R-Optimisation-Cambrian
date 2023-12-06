function [ a1,a2 ] = fAntennaFreeAngle( i,trackX,trackY,angle)

angleHalf=angle/2;
delta=2;
R=10e3;

Xi=trackX(i);
Yi=trackY(i);





%% determine a1

angleResult=1:delta:361;
sizeResult=1:delta:361;
counter=1;

for atemp=1:delta:361

    a1s1=atemp-angleHalf;
    a1s2=atemp+angleHalf;
    
    xv=[Xi,Xi+R*cosd(a1s1),Xi+R*cosd(a1s2),Xi];
    yv=[Yi,Yi+R*sind(a1s1),Yi+R*sind(a1s2),Yi];
    
    in = inpolygon(trackX,trackY,xv,yv);
    
    size=length(in(in==1));
    
    angleResult(counter)=atemp;
    sizeResult(counter)=size;
    counter=counter+1;
    
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
    
    xv=[Xi,Xi+R*cosd(a1s1),Xi+R*cosd(a1s2),Xi];
    yv=[Yi,Yi+R*sind(a1s1),Yi+R*sind(a1s2),Yi];
    
    in = inpolygon(trackX,trackY,xv,yv);
    
    trackX(in)=[];
    trackY(in)=[];
    %these areas are covered by a1, now let's see r2
    


%% determine a2
angleResult=1:delta:361;
sizeResult=1:delta:361;
counter=1;
for atemp=1:delta:361  
    
    if(abs(atemp-a1)>=60)
    
        a2s1=atemp-angleHalf;
        a2s2=atemp+angleHalf;
    
        xv=[Xi,Xi+R*cosd(a2s1),Xi+R*cosd(a2s2),Xi];
        yv=[Yi,Yi+R*sind(a2s1),Yi+R*sind(a2s2),Yi];
    
        in = inpolygon(trackX,trackY,xv,yv);
    
        size=length(in(in==1));
        sizeResult(counter)=size;
        
    else
        sizeResult(counter)=0;
    end
    
    
    angleResult(counter)=atemp;
    counter=counter+1;
    
    
end

maxAngle= max(sizeResult);

maxAngleResult=[];
for i=1:length(sizeResult)
    if(sizeResult(i)==maxAngle)
        maxAngleResult=[maxAngleResult,angleResult(i)];
    end
end
a2=median(maxAngleResult);


%fprintf("Antenna 1 = %3.0f degrees\nAntenna 2 = %3.0f degrees\n",a1,a2);
end

