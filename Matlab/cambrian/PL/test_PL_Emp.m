d=1:1:10e3;

 fMHz = 925;
 
 ht=15;
 hr=3.8;
 n=5;
 
 PL = PL_Emp(fMHz,ht,hr,n,d);
 
 TX=50;
 RX = TX-PL;
 figure
 plot(d,RX)