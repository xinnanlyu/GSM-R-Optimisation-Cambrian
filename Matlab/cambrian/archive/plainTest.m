% path loss of plain
clear all
txPower = 43; % in dBm
frequency = 900e6;
Height=5;
distance = 1:1:10000;

for d=1:1:10000
%PL(d)=46.17 + 34.19*log10(d/1000)+20*log10(frequency/1e6);

if d>400
    PL(d)=54.95-(0.2*Height-16.5)*log10(d);
else
    PL(d)=(0.61*Height+91.75)-(0.43*Height-2.36)*log10(d);
end

FSPL(d)=32.45 + 20* log10(d/1000)+10*log10(frequency/1e6);
Rx(d)=txPower - PL(d);
RxFS(d)=txPower - FSPL(d);
end

plot(distance,Rx)
hold on
plot(distance,RxFS)
hold off