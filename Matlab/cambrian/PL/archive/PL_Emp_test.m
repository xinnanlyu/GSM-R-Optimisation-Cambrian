d=1:1e4;
tx=55;
G=10;

f_MHz=925;
ht=30;
hr=2;
n=2.5;

PL = PL_Emp(f_MHz,ht,hr,n,d);
RX = tx+G -PL;
plot(d,RX)