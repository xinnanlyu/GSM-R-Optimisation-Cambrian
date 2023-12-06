%%
%   20/06/2016
%   basic modelling with 2 RBC

clear all
tic
%%

playground = 30e3; %30km

RBC1x = 5000;
RBC1y = 9500;
RBC2x = 17000;
RBC2y = 10500;

RBCx = [RBC1x, RBC2x];
RBCy = [RBC1y, RBC2y];
RBC1 = [RBC1x, RBC1y];
RBC2 = [RBC2x, RBC2y];

figure(1)
subplot(2,3,1)
plot(RBCx,RBCy,'o','LineWidth',3,'Color','r')
axis([0 playground 0 playground])
hold on
title('Track and RBC Layout');

trackX = 1:1:playground;
trackY = 0.*trackX + 10000;
plot(trackX,trackY,'LineWidth',3,'Color','b')
grid on
hold off

%%
txPower = 37; %% 43dBm=20W 37dBm=5W
frequency = 900e6;
threshold = 0*trackX-92;

%%
for i=1:1:playground
    train =[trackX(i),trackY(i)];
    
    PL1=plain(RBC1,train);
    PL2=plain(RBC2,train);
    RX1(i)=txPower-PL1;
    RX2(i)=txPower-PL2;   
    
    PL1vs=viaductSimple(RBC1,train);
    PL2vs=viaductSimple(RBC2,train);
    RX1vs(i)=txPower-PL1vs;
    RX2vs(i)=txPower-PL2vs;
    
    PL1cs=cuttingSimple(RBC1,train);
    PL2cs=cuttingSimple(RBC2,train);
    RX1cs(i)=txPower-PL1cs;
    RX2cs(i)=txPower-PL2cs;
    
    PL1c=cutting(RBC1,train);
    PL2c=cutting(RBC2,train);
    RX1c(i)=txPower-PL1c;
    RX2c(i)=txPower-PL2c;
    
    K1v(i)=Kviaduct(RBC1,train,false);
    K2v(i)=Kviaduct(RBC2,train,false);
    K1vd(i)=Kviaduct(RBC1,train,true);
    K2vd(i)=Kviaduct(RBC2,train,true);
    
end

%%
subplot(2,3,2)
plot(trackX,RX1)
hold on
plot(trackX,RX2)
plot(trackX,threshold,'LineWidth',3)
hold off
grid on
title('Received power in plain area')

subplot(2,3,3)
plot(trackX,RX1vs)
hold on
plot(trackX,RX2vs)
plot(trackX,threshold,'LineWidth',3)
hold off
grid on
title('Received power in viaduct area')

subplot(2,3,4)
plot(trackX,RX1cs)
hold on
plot(trackX,RX2cs)
plot(trackX,threshold,'LineWidth',3)
hold off
grid on
title('Received power in cutting area')

%{
figure(2)
plot(trackX,RX1vs,'Linewidth',2)
hold on
plot(trackX,RX2vs,'Linewidth',2)
plot(trackX,threshold,'LineWidth',3)
plot(trackX,RX1v)
plot(trackX,RX2v)
hold off
grid on


figure(3)
plot(trackX,RX1cs,'Linewidth',2)
hold on
plot(trackX,RX2cs,'Linewidth',2)
plot(trackX,threshold,'LineWidth',3)
plot(trackX,RX1c)
plot(trackX,RX2c)
hold off
grid on
%}


figure(2)
subplot(2,2,1)
plot(RBCx,RBCy,'o','LineWidth',3,'Color','r')
axis([0 playground 0 playground])
hold on
title('Track and RBC Layout');
plot(trackX,trackY,'LineWidth',3,'Color','b')
grid on
hold off

subplot(2,2,3)
plot(trackX,K1v)
hold on
plot(trackX,K2v)
hold off
grid on
title('Rician K in viaduct area, moderate')

subplot(2,2,4)
plot(trackX,K1vd)
hold on
plot(trackX,K2vd)
hold off
grid on
title('Rician K in viaduct area, dense')
toc
