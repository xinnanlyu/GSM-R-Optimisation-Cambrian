function inipar(N)

myCluster=parcluster('local'); 
myCluster.NumWorkers=N; 
parpool(myCluster,N);

end

