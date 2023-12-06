function [BTSPosition] = GAplain2D(BTS, tx, Pmin, std, groupSize, iteration, mutProb, crossProb, display)

tic

report=0;
%display=1;
if report
    profile on
end

load('Data_Cambrian_track.mat')


BTS; % number of BTS - Input
BTSLocation = [track(:,1),track(:,2)]; % loaded value
trackLength; % loaded value


BTSPosition=zeros(groupSize,BTS);
fitness=zeros(groupSize,1);
Fitness=zeros(iteration,1);



%% 1st gen

BTSPosition= floor(rand(groupSize,BTS)*trackLength)+1;

%% to make sure all genes layout are in asending order
for nInitial=1:groupSize
    BTSPosition(nInitial,:) =  sort(BTSPosition(nInitial,:));
end


for iMain=1:iteration
    % Step 1 - mutation
    BTSPosition = Mutation(BTSPosition,mutProb,trackLength);
    
    % Step 2 - cross
    BTSPosition = Cross(BTSPosition,crossProb);
    
    % Step 3 - fitness
    fitness = CalcFitness(BTSPosition,BTSLocation, tx, std, Pmin);
    best=BTSPosition(fitness==max(fitness),:);
    Fitness(iMain) = max(fitness);
    if display
        ShowResult(best(1,:),BTSLocation, tx, std, Pmin);
        
    end
    
    
    % Step 4 - survivals
    t=toc;
    BTSPosition = Survival(BTSPosition,fitness,groupSize);
    fprintf('I=%d, Std=%1.1f, BTS=%d, Prob=%2.2f, T=%3.1fs\n',iMain,std,BTS, max(fitness),t);
    
    
end



end




%% fitness function
function [result] = CalcFitness(BTSPosition,BTSLocationAll, tx, std, Pmin)

debug=0;

N=size(BTSPosition,1);
BTS=size(BTSPosition,2);
trackLength=length(BTSLocationAll);
CovProbMean=zeros(N,1);
CovProbMin=zeros(N,1);

%% calculate PL

parfor nFitness=1:N
    PL=zeros(trackLength,BTS);
    Pt=ones(trackLength,BTS)*tx;
    PrMax = zeros(trackLength,1);
    BTSLocationX = BTSLocationAll(BTSPosition(nFitness,:),1);
    BTSLocationY = BTSLocationAll(BTSPosition(nFitness,:),2);
    
    
    %distance = 0.001*norm(RBC - train);
    for bts=1:BTS
        for iTrack=1:trackLength
            distance = 0.001*norm([BTSLocationX(bts),BTSLocationY(bts)] -  BTSLocationAll(iTrack,:));
            PL(iTrack,bts)=105.255 + 34.19*log10(distance);
        end
    end
    
    Pr=Pt-PL;
    PrMax=max(Pr,[],2);
    
    CovProb = 100*(1-0.5*erfc((  PrMax  -Pmin)/(std*sqrt(2))));
    CovProbMean(nFitness) = mean(CovProb);
    CovProbMin(nFitness) = min(CovProb);
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
    
    survival(fitness>threshold) = 1;
    
    BTSPosition = BTSPosition(survival==1,:);
end

end



function ShowResult(best,BTSLocationAll, tx, std, Pmin)

BTS=length(best);
trackLength=length(BTSLocationAll);

PL=zeros(trackLength,BTS);
Pt=ones(trackLength,BTS)*tx;
PrMax = zeros(trackLength,1);

BTSLocation = BTSLocationAll(best,:);

%% calculate PL

for bts=1:BTS
    for iTrack=1:trackLength
        distance = 0.001*norm([BTSLocation(bts,1),BTSLocation(bts,2)] -  BTSLocationAll(iTrack,:));
        PL(iTrack,bts)=105.255 + 34.19*log10(distance);
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



