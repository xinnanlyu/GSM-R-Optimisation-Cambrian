d=1:1:15e3;

TX=37;
GA=17;

PTX=TX+GA;

PRX = PTX - plain_D(d*0.001);
plot(d,PRX)