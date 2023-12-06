tx=0;
figure()
distance=zeros(1,10000);
RX=zeros(1,10000);
RBC_LUT=[0,0];

for i=1:10000
    Train_LUT=[i,0];
    PL=plain(Train_LUT,RBC_LUT);
    RX(i)=tx-PL;
    distance(i)=i;
    
end

plot(log10(distance/1000),-RX);
grid on
xlabel('distance in log10()');
ylabel('path loss in dB');
title('Path Loss - Plain Area')
hold on
