t0=60;
prob=0.95^28;

% each time frame is 148bit, Test data is 4KB.
% therefore it takes 27.67 packet to send the test data
%{

Theory: 4.8Kbps
Guaranteed Bit Rate: 4Kbps
Actual Bit rate: around 1Kbps - consumed by ETCS system config
MA: 560B - 

%}

Tsum=0;
for i=1:10000
    T = t0*i*(1-prob)^(i-1)*prob;
    Tsum = Tsum+T;
end
fprintf("Tsum=%4.1fs\n",Tsum);