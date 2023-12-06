function [Fitness] = BFS2D(Combinations, tx, std, Pmin,plainPL, Range)

debug=0;

N=size(Combinations,1);
BTS=size(Combinations,2);

rangeLength=length(Range);
PrAll = zeros(N,rangeLength);
CovProbAll = zeros(N,rangeLength);

%% calculate PL

for nFitness=1:N  % fitness for all combinitions 
    %fprintf('%d/%d\n',nFitness,N)
    PL=zeros(rangeLength,BTS);
    %Pt=ones(trackLength,BTS)*tx;
    %PrMax = zeros(rangeLength,1);
    
    %distance = 0.001*norm(RBC - train);
    for bts=1:BTS
        PL(:,bts)=plainPL( Combinations(nFitness,bts), Range );
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

Fitness= min(CovProbAll,[],2);



end

