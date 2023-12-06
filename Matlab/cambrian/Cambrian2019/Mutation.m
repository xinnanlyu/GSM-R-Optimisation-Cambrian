function [BTSPosition] = Mutation(BTSPosition,mutProb,range)

numElement=size(BTSPosition,2);

for n=1:size(BTSPosition,1)
    if rand<mutProb
        
        newPos=getRand(1,numElement,1);
        BTSPosition(n,newPos)=getRand(1,range,1);
        
    end
end

end