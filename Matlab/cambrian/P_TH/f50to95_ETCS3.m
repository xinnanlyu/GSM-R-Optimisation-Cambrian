function [P_TH] = f50to95_ETCS3(std)
%F50TO95_ETCS3 Summary of this function goes here
%   Detailed explanation goes here
P_TH=-92+erfcinv(0.1)*2^0.5*std;
end

