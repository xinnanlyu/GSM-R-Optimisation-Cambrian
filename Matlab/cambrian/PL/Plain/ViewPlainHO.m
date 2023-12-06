dmax=30; %$ in km
TH1=-92;
TH2=-82;
TX=37;
GA=17;
BS1=5;
BS2=16;

T=8;
S=300 /3.6;
L=T*S/1000

d=0:0.01:dmax;
PTX=TX+GA;

PRX1 = PTX - plain_D(abs(d-BS1));
PRX2 = PTX - plain_D(abs(d-BS2));

Delta=PRX1-PRX2;
figure()
plot(d,PRX1,'LineWidth',2)
hold on
plot(d,PRX2,'LineWidth',2)
grid on
x=[0,dmax];
y1=[TH1,TH1];
y2=[TH2,TH2];
plot(x,y1,'LineWidth',2,'Color','k')
plot(x,y2,'LineWidth',2,'Color','k')
hold off
axis([0,dmax,-100,0])
%figure()
%plot(d,Delta)
%grid on



%% add rand

std1=2*3*(rand(1,length(d))-0.5);
std2=2*3*(rand(1,length(d))-0.5);
PRX1std=PRX1+std1;
PRX2std=PRX2+std1;
figure()
plot(d,PRX1std,'LineWidth',2)
hold on
plot(d,PRX2std,'LineWidth',2)
grid on
x=[0,dmax];
y1=[TH1,TH1];
y2=[TH2,TH2];
plot(x,y1,'LineWidth',2,'Color','k')
plot(x,y2,'LineWidth',2,'Color','k')
axis([0,dmax,-100,0])
hold off