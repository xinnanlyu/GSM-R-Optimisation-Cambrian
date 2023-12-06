%% begin generating possible combinations
%distance=20m
minimumGap = 100; %2km

counter=0;

for a1=1:770

    for a2=a1:770
        
        for a3=a2:770
            
            for a4=a3:770
                
                
                if(a2-a1>=minimumGap && a3-a2>=minimumGap && a4-a3>=minimumGap)
                    counter=counter+1;
                end
                
            end
        end
    end
end

averageTime=0.01;
estimateTimeH = counter*averageTime/60/60;
