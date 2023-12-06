clear

% iniPar(8)
tic
report=0;
display=0;
if report
    profile on
end
dmax=150e3;  % range in km
d=1:dmax;

BTS=6; % number of BTS
N=100;

mutProb=0.5;
crossProb=0.5;
iteration=200;



BTSPosition=zeros(N,BTS);
fitness=zeros(N,1);
Fitness=zeros(iteration,1);
survival = ones(N,1);

%% 1st gen

BTSPosition= floor(rand(N,BTS)*dmax)+1;

for n=1:N
    BTSPosition(n,:) =  sort(BTSPosition(n,:));
end


for i=1:iteration
    % Step 1 - mutation
    BTSPosition = Mutation(BTSPosition,mutProb,dmax);
    
    % Step 2 - cross
    BTSPosition = Cross(BTSPosition,crossProb);
    
    % Step 3 - fitness
    fitness = CalcFitness(BTSPosition,d);
    best=BTSPosition(fitness==max(fitness),:);
    Fitness(i) = max(fitness);
    if display
        ShowResult(best(1,:),d);
    end
    
    % Step 4 - survivals
    t=toc;
    BTSPosition = Survival(BTSPosition,fitness,N);
    fprintf('Iteration=%d, fitness=%2.4f, T=%3.1fs\n',i, max(fitness),t);
    
    if length(BTSPosition)==0
        fprintf('All Died...\n')
        break
    end
    
end

if report
    profile off
    profile report
end


%% fitness function
function [result] = CalcFitness(BTSPosition,d)
tx=26+30; %%EIRF in dBm
Pmin=-92;
std=3;

debug=0;

N=size(BTSPosition,1);
BTS=size(BTSPosition,2);
dmax=length(d);


CovProbMean=zeros(N,1);
CovProbMin=zeros(N,1);

%% calculate PL

parfor n=1:N
    PL=zeros(dmax,BTS);
    Pt=ones(dmax,BTS)*tx;
    PrMax = zeros(dmax,1);
    
    for bts=1:BTS
        PL(:,bts)=105.255 + 34.19*log10(0.001*abs(BTSPosition(n,bts)-d));
    end
    
    Pr=Pt-PL;
    PrMax=max(Pr,[],2);
    
    CovProb = 100*(1-0.5*erfc((  PrMax  -Pmin)/(std*sqrt(2))));
    CovProbMean(n) = mean(CovProb);
    CovProbMin(n) = min(CovProb);
end


if debug
    for n=1:N
        figure(1)
        subplot(2,1,1)
        plot(d,PrMax(n,:))
        subplot(2,1,2)
        plot(d,CovProb(n,:))
        pause(0.5)
    end
end
result= CovProbMin;

end

%% Mutation Function
function [BTSPosition] = Mutation(BTSPosition,mutProb,dmax)

Child=[];
try
    for n=1:length(BTSPosition)
        if rand<mutProb
            newPos=floor(dmax*rand)+1;
            distance=abs(BTSPosition(n,:)-newPos);
            position = distance==min(distance);
            child = BTSPosition(n,:);
            child(position)=newPos;
            % replace the bit which is cloest with the mutation bit
            Child=[Child;child];
        end
    end
catch
    fprintf('Mutation Failure\n')
end

BTSPosition = [BTSPosition;Child];

end

function [BTSPosition] = Cross(BTSPosition,crossProb)

N=size(BTSPosition,1);
BTS=size(BTSPosition,2);

Child=[];
try
    for n=1:N
        if rand<crossProb
            parent1 = BTSPosition(n,:);
            parent2pos = floor(length(BTSPosition)*rand)+1;
            parent2 = BTSPosition(parent2pos,:);
            
            cutBit = floor((BTS-1)*rand)+1;
            
            child1=zeros(1,BTS);
            child2=zeros(1,BTS);
            
            for bts=1:BTS
                if bts<=cutBit
                    child1(bts)=parent1(bts);
                    child2(bts)=parent2(bts);
                else
                    child1(bts)=parent2(bts);
                    child2(bts)=parent1(bts);
                end
            end
            
            
            Child=[Child;child1;child2];
            
        end
    end
catch
    fprintf('Cross Failure\n')
end
BTSPosition = [BTSPosition;Child];

end

function [BTSPosition] = Survival(BTSPosition,fitness,N)

% if samples is over N, then choose first N samples
% otherwise, choose those better than averages. 


if length(BTSPosition)>N
    [fitness,I]=sort(fitness,'descend');
    BTSPosition = BTSPosition(I,:);
    BTSPosition=BTSPosition(1:N,:);
elseif length(BTSPosition)<=10
    % do nothing, to make sure there is a next generation.
else
    threshold = mean(fitness);
    survival = zeros(length(BTSPosition),1);
    
    survival(fitness>=threshold) = 1;
    
    BTSPosition = BTSPosition(survival==1,:);
end

end



function [] = ShowResult(best,d)
tx=26+30; %%EIRF in dBm
Pmin=-92;
std=3;


BTS=length(best);
dmax=length(d);

PL=zeros(dmax,BTS);
Pt=ones(dmax,BTS)*tx;
PrMax = zeros(dmax,1);

%% calculate PL

for bts=1:BTS
    PL(:,bts)=105.255 + 34.19*log10(0.001*abs(best(bts)-d));
end
Pr=Pt-PL;

PrMax=max(Pr,[],2);

CovProb = 100*(1-0.5*erfc((  PrMax  -Pmin)/(std*sqrt(2))));



figure(1)
subplot(2,1,1)
plot(d,PrMax)
subplot(2,1,2)
plot(d,CovProb)
%pause(0.5)


end

function [] = iniPar(N)

myCluster=parcluster('local'); 
myCluster.NumWorkers=N; 
parpool(myCluster,N);

end