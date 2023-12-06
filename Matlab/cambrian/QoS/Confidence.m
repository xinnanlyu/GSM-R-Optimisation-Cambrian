P = 0.001:0.001:1;
N=28;


% each time frame is 148bit, Test data is 4KB.
% therefore it takes 27.67 packet to send the test data
%{

Theory: 4.8Kbps
Guaranteed Bit Rate: 4Kbps
Actual Bit rate: around 1Kbps - consumed by ETCS system config
MA: 560B - 

%}


Pn=P.^N;

Pcorrection=0.9;


t0=150;
attempts=1e5;
totalSize = length(P);

ExpT=zeros(1,totalSize);
for n=1:totalSize
    Tsum=0;
    for i=1:attempts
        T = t0*i*Pcorrection*(1-Pn(n))^(i-1)*Pn(n);
        Tsum = Tsum+T;
    end
    ExpT(n)=Tsum;
    
    fprintf(".");
end

fprintf("\n");
ExpAll=[P;ExpT];

plot(P(900:1000),ExpT(900:1000))
grid on