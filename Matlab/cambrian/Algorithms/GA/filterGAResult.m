function [BTSResult] = filterGAResult(BTSLocations, relativeDistance)
N=size(BTSLocations,1);
BTS=size(BTSLocations,2);
distance = zeros(BTS,BTS);

for n=1:N
    
    for bts=1:BTS
        
       for btsSelect=1:BTS
           bts1=BTSLocations(n,bts);
           bts2=BTSLocations(n,btsSelect);
           
           if bts1==bts2
               distance(bts,btsSelect)=Inf;
           else
               distance(bts,btsSelect) = relativeDistance(bts1,bts2);
           end
           
       end
    end
    
end
fitness = min(distance,[],2);

[fitness,I] = sort(fitness,'descend');

BTSLocations = BTSLocations(I,:);

BTSResult = BTSLocations(1,:);

end

function [BTSResult] = filterGAResult_V1(BTSLocations, BTSCoord)
N=size(BTSLocations,1);
BTS=size(BTSLocations,2);
fitness = zeros(N,1);
distance = zeros(BTS,BTS);

for n=1:N
    
    for bts=1:BTS
        
       for btsSelect=1:BTS
           bts1=BTSCoord(BTSLocations(n,bts),:);
           bts2=BTSCoord(BTSLocations(n,btsSelect),:);
           distance(bts,btsSelect) = norm(bts1-bts2);
           if distance(bts,btsSelect)==0
               distance(bts,btsSelect)=1e8;
           end
           
       end
    end
    
    fitness(n) = min(min(distance));
    
end

[fitness,I] = sort(fitness,'descend');

BTSLocations = BTSLocations(I,:);

BTSResult = BTSLocations(1,:);

end

