function [BTSPosition] = Cross(BTSPosition,crossProb)

N=size(BTSPosition,1);
numElement=size(BTSPosition,2);
mutPop = floor(N*crossProb);

if(mod(mutPop,2)==1)
    mutPop = mutPop +1;
end

crossPopulation=getRand(1,N,mutPop);
crossPair=zeros(mutPop/2,2);

for i=1:mutPop/2
    crossPair(i,1)=crossPopulation(1);
    crossPopulation(1)=[];
    crossPair(i,2)=crossPopulation(1);
    crossPopulation(1)=[];
end

childs=zeros(mutPop/2,numElement);

for i=1:mutPop/2
    childs(i,:)=BTSPosition(crossPair(i,1),:);
    
    cutBit=getRand(1,numElement,1);
    
    for j=1:numElement
        if(j>=cutBit)
            childs(i,j)=BTSPosition(crossPair(i,2),j);
        end
    end
    
end

BTSPosition = [BTSPosition;childs];

end