
report=0
if report
    profile off
    profile on
end

display=0;

BTS = 28;
tx = 39;
std = 4;
Pmin = -95;
guided = 0;

%selectedNode=101:1000;


bestFitness=0;
bestBTS=[];
NodeCounter = length(selectedNode);


%% Scenario

N=length(CombBTS);

estSizeGB = N*NodeCounter/1e9*7.45;
fprintf("Combinitions=%10.0f\n",N)
fprintf("Estimate Memory Size=%2.1fGB\n",estSizeGB)

ram=4e6; %3e6 for 32GB

% this need to divide for every 3e6 combinitions for 32GB RAM

if guided
    if estSizeGB>20
        startPoint=input("From=");
        endPoint=input("To=");
        
        if endPoint>N
            endPoint=N;
        end
        
    else
        startPoint=1;
        endPoint=N;
    end
    
    Fitness = BFS2D(CombBTS(startPoint:endPoint,:), tx, std, Pmin,plainPL, selectedNode);
    
    [maxFitness,I] = max(Fitness);
    
    if maxFitness>bestFitness
        bestFitness = maxFitness;
        bestBTS = CombBTS(I,:);
    end
    
    fprintf("Max fitness=%2.2f\n",maxFitness)
    
else
    
    for startPoint = 1:ram:N
        tic
        endPoint = startPoint + ram;
        if endPoint>N
            endPoint=N;
        end
        
        Fitness = BFS2D(CombBTS(startPoint:endPoint,:), tx, std, Pmin,plainPL, selectedNode);
        
        [maxFitness,I] = max(Fitness);
        
        if maxFitness>bestFitness
            bestFitness = maxFitness;
            bestBTS = CombBTS(I,:);
        elseif maxFitness == bestFitness
            bestFitness = [bestFitness, maxFitness];
            bestBTS = [bestBTS; CombBTS(I,:)];
        end
        T=toc;
        fprintf("%3.0f/100 Entry Point %2.0f calculated, Max=%2.2f, T=%3.0fs\n",endPoint/N*100,startPoint/ram,bestFitness,T);
        
    end
    
    %BTSResult = 
    
end
    
    
    
    
    
    
    if report
        profile off
        profile report
    end