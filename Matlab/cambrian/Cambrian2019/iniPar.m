function [] = iniPar(N)

myCluster=parcluster('local'); 
myCluster.NumWorkers=N; 
parpool(myCluster,N);

end