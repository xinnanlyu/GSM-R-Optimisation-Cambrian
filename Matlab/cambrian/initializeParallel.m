%% Parallel Pool Enabler

% Change the N to the number of threads of your CPU
% i.e. for normal desktop i7 like i7-4790, use N=8;
 
% Mind that each N will take more than 0.5GB memory
% Take care of your total memory usage before running it.

% If you still want to use the PC while calculating,
% for maximum efficiency, recommend N= max(Your CPU Threads) - 1

% This script only need to run once, Matlab will kill pools when
% system idle for 30 minutes, if so, run this script again.


%% Please change the N here:
N=3;


myCluster=parcluster('local'); 
myCluster.NumWorkers=N; 
parpool(myCluster,N);