%function [ area ] = fAntennaElevation( iBts ,R)


%Need to Load CambrianWorld to make it work.

% The best combination is 325e3, 320e3, 0

%angle=30;

angleHalf=15;

startDistance=0.5;
endDistance=10;
deviation=0.5;

RAll = startDistance:deviation:endDistance;
SigmaAll_1= startDistance:deviation:endDistance;
SigmaAll_2= startDistance:deviation:endDistance;

numAntenna=input('Number of Antenna=');
any=input('Get any point?');

if(any==1)
    
    
    Xi=input('X=');
    Yi=input('Y=');
    
    
    
    
    
    if(numAntenna==2)
    
    a1=input('Antenna Angle 1=');
    a2=input('Antenna Angle 2=');
    
    counter=1;


a1s1=a1-angleHalf;
a1s2=a1+angleHalf;

a2s1=a2-angleHalf;
a2s2=a2+angleHalf;

    
for i=startDistance:deviation:endDistance
    
R=i*1e3;

xv1=[Xi,Xi+R*cosd(a1s1),Xi+R*cosd(a1s2),Xi];
yv1=[Yi,Yi+R*sind(a1s1),Yi+R*sind(a1s2),Yi];

xv2=[Xi,Xi+R*cosd(a2s1),Xi+R*cosd(a2s2),Xi];
yv2=[Yi,Yi+R*sind(a2s1),Yi+R*sind(a2s2),Yi];

%fprintf("*")
in1 = inpolygon(world(:,1),world(:,2),xv1,yv1);
in2 = inpolygon(world(:,1),world(:,2),xv2,yv2);
%fprintf("*")
%area=world(in,:,:);
%fprintf("*\n")

deviation1 = std(world(in1,3));
deviation2 = std(world(in2,3));
fprintf("R=%5.0f, Deviation1=%3.2f, Deviation2=%3.2f\n",R,deviation1,deviation2);

RAll(counter)=R;
SigmaAll_1(counter)=deviation1;
SigmaAll_2(counter)=deviation2;

counter=counter+1;

end

    else
        
        
            a1=input('Antenna Angle 1=');
    
    counter=1;


a1s1=a1-angleHalf;
a1s2=a1+angleHalf;
  
for i=startDistance:deviation:endDistance
    
R=i*1e3;

xv1=[Xi,Xi+R*cosd(a1s1),Xi+R*cosd(a1s2),Xi];
yv1=[Yi,Yi+R*sind(a1s1),Yi+R*sind(a1s2),Yi];


%fprintf("*")
in1 = inpolygon(world(:,1),world(:,2),xv1,yv1);
%fprintf("*")
%area=world(in,:,:);
%fprintf("*\n")

deviation1 = std(world(in1,3));
fprintf("R=%5.0f, Deviation1=%3.2f\n",R,deviation1);

RAll(counter)=R;
SigmaAll_1(counter)=deviation1;

counter=counter+1;

end
        
        
        
        
    end



else

iBts=input('Load Antenna No.');

Xi=trackX(iBts);
Yi=trackY(iBts);

a1s1=BtsA1(iBts)-angleHalf;
a1s2=BtsA1(iBts)+angleHalf;

a2s1=BtsA2(iBts)-angleHalf;
a2s2=BtsA2(iBts)+angleHalf;

counter=1;
for i=startDistance:deviation:endDistance
    
R=i*1e3;

xv1=[Xi,Xi+R*cosd(a1s1),Xi+R*cosd(a1s2),Xi];
yv1=[Yi,Yi+R*sind(a1s1),Yi+R*sind(a1s2),Yi];

xv2=[Xi,Xi+R*cosd(a2s1),Xi+R*cosd(a2s2),Xi];
yv2=[Yi,Yi+R*sind(a2s1),Yi+R*sind(a2s2),Yi];

%fprintf("*")
in1 = inpolygon(world(:,1),world(:,2),xv1,yv1);
in2 = inpolygon(world(:,1),world(:,2),xv2,yv2);
%fprintf("*")
%area=world(in,:,:);
%fprintf("*\n")

deviation1 = std(world(in1,3));
deviation2 = std(world(in2,3));
fprintf("R=%5.0f, Deviation1=%3.2f, Deviation2=%3.2f\n",R,deviation1,deviation2);

RAll(counter)=R;
SigmaAll_1(counter)=deviation1;
SigmaAll_2(counter)=deviation2;

counter=counter+1;

end

end





figure()
subplot(2,1,1)
plot(RAll,SigmaAll_1,'color','r','Linewidth',2)
grid on

if(numAntenna>1)
subplot(2,1,2)
plot(RAll,SigmaAll_2,'color','b','Linewidth',2)
grid on
end
%title('BTS No.%3.0f, Angle=%2.0f',iBts,angle);
%end


figure()
plot(trackX,trackY,'o','color','k')
hold on
grid on
axis equal
plot(Xi,Yi,'o','LineWidth',5,'color','r')
plot(xv1,yv1,'color','r','Linewidth',2)
if(numAntenna>1)
plot(xv2,yv2,'color','b','Linewidth',2)
end


displayArea=input('display area?');

if (displayArea==1)
    area=world(in1,:);
    figure()
    scatter3(area(:,1),area(:,2),area(:,3),[],area(:,3))
    colorbar
end

