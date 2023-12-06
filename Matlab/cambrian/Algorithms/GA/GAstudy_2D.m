

par= 0;

if par
    iniPar(3)
end

tic
report=0;
display=1;
if report
    profile on
end

% Track Vector Data, environmenbt data
% load('Data_Cambrian_track.mat')

% parallel computing
%iniPar(4)

BTS=15; % number of BTS
BTSLocation = [track(:,1),track(:,2)];
trackLength;

% GA Setting
N=500;
mutProb=0.4;
crossProb=0.4;
iteration=500;

record = zeros(1,500);

BTSPosition=zeros(N,BTS);
fitness=zeros(N,1);
Fitness=zeros(iteration,1);



%% 1st gen

BTSPosition= floor(rand(N,BTS)*trackLength)+1;

%% to make sure all genes layout are in asending order
for n=1:N
    BTSPosition(n,:) =  sort(BTSPosition(n,:));
end


for i=1:iteration
    % Step 1 - mutation
    BTSPosition = Mutation(BTSPosition,mutProb,trackLength);
    
    % Step 2 - cross
    BTSPosition = Cross(BTSPosition,crossProb);
    
    % Step 3 - fitness
    fitness = CalcFitness(BTSPosition,BTSLocation);
    best=BTSPosition(fitness==max(fitness),:);
    Fitness(i) = max(fitness);
    if display
        ShowResult(best(1,:),BTSLocation);
    end
    
    % Step 4 - survivals
    t=toc;
    BTSPosition = Survival(BTSPosition,fitness,N);
    fprintf('Iteration=%d, fitness=%2.4f, T=%3.1fs\n',i, max(fitness),t);
    
    record(i)=max(fitness);
end

if report
    profile off
    profile report
end


%% fitness function
function [result] = CalcFitness(BTSPosition,BTSLocationAll)
tx=36+13; %% DL EIRF=56, UL EIRF=36(4W)
Pmin=-87;
std=3;

debug=0;

N=size(BTSPosition,1);
BTS=size(BTSPosition,2);
trackLength=length(BTSLocationAll);
CovProbMean=zeros(N,1);
CovProbMin=zeros(N,1);

%% calculate PL

parfor n=1:N
    PL=zeros(trackLength,BTS);
    Pt=ones(trackLength,BTS)*tx;
    PrMax = zeros(trackLength,1);
    BTSLocationX = BTSLocationAll(BTSPosition(n,:),1);
    BTSLocationY = BTSLocationAll(BTSPosition(n,:),2);
    
    
    %distance = 0.001*norm(RBC - train);
    for bts=1:BTS
        for i=1:trackLength
            distance = 0.001*norm([BTSLocationX(bts),BTSLocationY(bts)] -  BTSLocationAll(i,:));
            PL(i,bts)=105.255 + 34.19*log10(distance);
        end
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
function [BTSPosition] = Mutation(BTSPosition,mutProb,range)

Child=[];
try
    for n=1:length(BTSPosition)
        if rand<mutProb
            newPos=floor(range*rand)+1;
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
    
    for i=1:length(BTSPosition)
        if(fitness>threshold)
            
            if(rand(1)>0.4)
                survival(i) = 1;
            end
            
        else
            if(rand(1)>0.6)
                survival(i) = 1;
            end
        end
    end
    
    BTSPosition = BTSPosition(survival==1,:);
end

end



function [] = ShowResult(best,BTSLocationAll)
tx=43; %%DL EIRF=56dBm, UL EIRF=39-3
Pmin=-87;
std=3;


BTS=length(best);
trackLength=length(BTSLocationAll);

PL=zeros(trackLength,BTS);
Pt=ones(trackLength,BTS)*tx;
PrMax = zeros(trackLength,1);

BTSLocation = BTSLocationAll(best,:);

%% calculate PL

    for bts=1:BTS
        for i=1:trackLength
            distance = 0.001*norm([BTSLocation(bts,1),BTSLocation(bts,2)] -  BTSLocationAll(i,:));
            PL(i,bts)=105.255 + 34.19*log10(distance);
        end
    end
Pr=Pt-PL;

PrMax=max(Pr,[],2);

CovProb = 100*(1-0.5*erfc((  PrMax  -Pmin)/(std*sqrt(2))));

d=1:trackLength;

figure(1)
subplot(2,1,1)
plot(d,PrMax, '.')
subplot(2,1,2)
plot(d,CovProb, '.')
%pause(0.5)


end

function [] = iniPar(N)

myCluster=parcluster('local'); 
myCluster.NumWorkers=N; 
parpool(myCluster,N);

end

