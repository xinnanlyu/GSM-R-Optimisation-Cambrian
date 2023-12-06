profile on

N=3547;

load('Data_Gs_60.mat')
load('Data_AntennaBelong_60.mat')
load('relativeDistance.mat')



PL_index=zeros(N,N);
std=zeros(N,N);

for i=1:N
    for j=1:N
        
        distance = D(i,j);
        antennaIndex = AntennaBelong(i,j);
        Gs_bts = Gs(i,:,antennaIndex);
        
        rangeIndex = distance<distanceDeviation;
        
        for k=1:deviationLength
            if rangeIndex(k)==1
                locationIndex=k;
                break
            end
        end
        
        Gs_bts(locationIndex+1:deviationLength)=[];
        
        [PL_index(i,j),std(i,j)]=StdProcessor(Gs_bts);
        
    end
    fprintf('*')
end


profile off
profile report