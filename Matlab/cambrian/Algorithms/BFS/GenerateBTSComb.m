

%% select a BTS in every /threeshold nodes
% interval=50m


threshold=2;  % BTS every 200m 
bts=4;
%selectedNode= 101:1000;



selectedBTS = [];
counter=1;
NodeCounter = length(selectedNode);


for i=1:NodeCounter;
    if counter == threshold
        selectedBTS = [selectedBTS;selectedNode(i)];
        counter=1;
    else
        counter=counter+1;
    end
end
    
N=length(selectedBTS);

%size=nchoosek(N,bts);



%% generate combinations based on BTS selected
% gap = every /threshold
% distance = gap*threshold * averageDistance
% i.e. distance=4*5*50 = 1km, this is the minumum distance between two BTS

%CombBTS = nchoosek(selectedBTS,4);
threshold=10; 


counter=0;
for b1=1:N
    for b2=b1:N
        for b3=b2:N
            for b4=b3:N
                if (b2-b1>threshold && b3-b2>threshold && b4-b3>threshold)
                    counter=counter+1;
                end
            end
        end
    end
    fprintf("*")
end
fprintf("\n")


CombBTS=zeros(counter,bts);
counter=1;
for b1=1:N
    for b2=b1:N
        for b3=b2:N
            for b4=b3:N
                
                if (b2-b1>threshold && b3-b2>threshold && b4-b3>threshold )
                    
                    CombBTS(counter,:)=[selectedBTS(b1),selectedBTS(b2),selectedBTS(b3),selectedBTS(b4)];
                    
                    counter=counter+1;
                    
                end
            end
        end
    end
    fprintf("*")
end
fprintf("\n")


averageTime=0.01;
estimateTimeH = counter*averageTime/60/60;