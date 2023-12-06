function [BTSPosition, maxFitness] = GA2D(BTS, tx, Pmin, std, groupSize, iteration, mutProb, crossProb, display, Range, BTSRange, PL_Model)

tic

report=0;
%display=1;
if report
    profile on
end

Fitness=zeros(iteration,1);

load('Data_Cambrian_track_relativeDistanceKM.mat')

relativeDistance =relativeDistanceKM; %use KM
rangeLength = length(Range);
BTSRangeLength = length(BTSRange);

%% 1st gen
BTSPositionIndex = floor(rand(groupSize,BTS)*BTSRangeLength)+1;

BTSPosition= BTSRange(BTSPositionIndex);
% this generate the starting point, based on Range


%% to make sure all genes layout are in asending order
for nInitial=1:groupSize
    BTSPosition(nInitial,:) =  sort(BTSPosition(nInitial,:));
end


for iMain=1:iteration
    % Step 1 - mutation
    Child1 = Mutation(BTSPosition,mutProb,BTSRange); % TO DO
    
    % Step 2 - cross
    Child2 = Cross(BTSPosition,crossProb);
    
    BTSPosition = [BTSPosition; Child1; Child2];
    
    % Step 3 - fitness
    [fitness, PrMax, CovProb] = CalcFitness(BTSPosition, tx, std, Pmin,PL_Model, Range);
    Fitness(iMain) = max(fitness);
    
    if display
        ShowLiveResult(iMain, fitness, PrMax, CovProb);
    end
    
    
    % Step 4 - survivals
    t=toc;
    BTSPosition = Survival(BTSPosition,fitness,groupSize);
    
    fprintf('I=%d, Std=%1.1f, BTS=%d, Prob=%2.2f, T=%3.1fs\n',iMain,std,BTS, max(fitness),t);
    
    
end

maxFitness = max(fitness);

BTSPosition = filterGAResult(BTSPosition, relativeDistance);

if display
    ShowGAResult(BTSPosition);
end

end




%% fitness function

function [fitness, PrAll, CovProbAll] = CalcFitness(BTSPosition, tx, std, Pmin,PL_Model, Range)

debug=0;

N=size(BTSPosition,1);
BTS=size(BTSPosition,2);

rangeLength=length(Range);
PrAll = zeros(N,rangeLength);
CovProbAll = zeros(N,rangeLength);

%% calculate PL

for nFitness=1:N  % fitness for all combinitions 
    %fprintf('%d/%d\n',nFitness,N)
    PL=zeros(rangeLength,BTS);
    %Pt=ones(trackLength,BTS)*tx;
    PrMax = zeros(rangeLength,1);
    
    %distance = 0.001*norm(RBC - train);
    for bts=1:BTS
        PL(:,bts)=PL_Model( BTSPosition(nFitness,bts), Range );
    end
    
    Pr=tx-PL;
    PrMax=max(Pr,[],2);
    
    CovProb = 100*(1-0.5*erfc((  PrMax  -Pmin)/(std*sqrt(2))));
    CovProbAll(nFitness,:) = CovProb';
    PrAll(nFitness,:) = PrMax';
end


if debug
    for nDebug=1:N
        figure(1)
        subplot(2,1,1)
        plot(d,PrMax(nDebug,:))
        subplot(2,1,2)
        plot(d,CovProb(nDebug,:))
        pause(0.5)
    end
end

% CovProbMin(nFitness) = min(CovProb);

%CovProbSelected = zeros(N,rangeLength); 
%CovProbSelected = CovProbAll(:,Range);  % resultFilter
% N rows for all combinitions, each row is the CovProb for the nodes

fitness= min(CovProbAll,[],2);

end


%% Mutation Function
function [Child] = Mutation(BTSPosition,mutProb,BTSRange) 

Child=[];
try
    for n=1:length(BTSPosition)
        if rand<mutProb
            rangeLength = length(BTSRange);
            
            newPos=BTSRange( floor(rangeLength*rand)+1 );
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

end

function [Child] = Cross(BTSPosition,crossProb)

N=size(BTSPosition,1);
BTS=size(BTSPosition,2);

Child=[];
try
    for nPos=1:N
        if rand<crossProb
            parent1 = BTSPosition(nPos,:);
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

end

function [BTSPositionNew] = Survival(BTSPosition,fitness,N)

% if samples is over N, then choose first N samples
% otherwise, choose those better than averages.

 %% Method 1 - round gamble
 %{
meanValue = mean(fitness);
goodGroup = BTSPosition(fitness>=meanValue,:);
badGroup = BTSPosition(fitness<meanValue,:);
BTSPositionNew = zeros(N,size(BTSPosition,2));

for n=1:N
    if rand <0.9 && size(goodGroup,1)>0
        pointer = floor(rand*size(goodGroup,1))+1;
        BTSPositionNew(n,:) = goodGroup(pointer,:);
        goodGroup(pointer,:) = [];
    else
        pointer = floor(rand*size(badGroup,1))+1;
        BTSPositionNew(n,:) = badGroup(pointer,:);
        badGroup(pointer,:) = [];
    end
end
 
 %}
 %% Method 2 - choose better ones. 

if length(BTSPosition)>N
    
    [fitness,I]=sort(fitness,'descend');
    BTSPosition = BTSPosition(I,:);
    BTSPositionNew = BTSPosition(1:N,:);
    
elseif length(BTSPosition)<=10
    % do nothing, to make sure there is a next generation.
else
    threshold = mean(fitness);
    survival = zeros(length(BTSPosition),1);
    
    survival(fitness>threshold) = 1;
    
    BTSPositionNew = BTSPosition(survival==1,:);
end

%BTSPosition = BTSPositionNew;
%}

end



function ShowLiveResult(iMain, fitness, PrMax, CovProb)

[maxValue, I] = max(fitness);

% Kill the spares.
fitness = fitness(I);
PrMax = PrMax(I,:);
CovProb = CovProb(I,:);

n=1:length(PrMax);

figure(1)
subplot(3,1,1)
plot(n,PrMax(1,:),'.')
subplot(3,1,2)
plot(n,CovProb(1,:),'.')
subplot(3,1,3)
hold on
%plot(iMain, max(fitness), '.','LineWidth',3)
plot(iMain, fitness(1),'.','Color','k')
hold off
%pause(0.5)


end

function [pl] = plain_D(distanceKM)

%pl=46.17 + 34.19*log10(distance)+20*log10(900);

pl=105.2549+34.19*log10(distanceKM);
end

