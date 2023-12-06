
clear
%profile off
%profile on

%% Initialize

display=1;

BTS = 30;
tx = 39;
std = 3;
Pmin = -95;

groupSize = 300;
iteration = 200;
mutProb = 0.5;
crossProb = 1.0;

%% Scenario Single

BTSLocations = GAplain2D(BTS, tx, Pmin, std,...
    groupSize, iteration, mutProb, crossProb, display);


bestOne = filterGAResult(BTSLocations);
ShowGAResult(bestOne);
%profile off
%profile report
%%
for std=3:3:6
    for BTS=25:30
        filename = sprintf('BTSLocation_std_%d_BTS_%d',std,BTS);
        BTSLocations = GAplain2D(BTS, tx, Pmin, std,...
            groupSize, iteration, mutProb, crossProb, display);
        save(filename,'BTSLocations')
    end
end

