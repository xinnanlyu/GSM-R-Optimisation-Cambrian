RBC1=RBCoptimal(resulti,:);
RBC2=RBCoptimal(resultj,:);
RBC3=RBCoptimal(resultk,:);

sampleSize=trackCounter-1;

txPower=37;
RX=zeros(1,sampleSize);

PLtemp=zeros(1,RBCnum);

for i=1:sampleSize
    train=[trainX(i),trainY(i)];
    
    PLtemp(1)=plain(RBC1,train);
    PLtemp(2)=plain(RBC2,train);
    PLtemp(3)=plain(RBC3,train);
    
    PL=min(PLtemp);
    
    RX(i)=txPower-PL;
    
end

scatter3(trainX,trainY,RX,[],RX);
colorbar