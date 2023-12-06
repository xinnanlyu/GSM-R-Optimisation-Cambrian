%% The best Parallel is CPU=5
%clear

%figure(1)

report=0
if report
    profile off
    profile on
end


display=0;

BTS = 4;
tx = 39;
std = 4;
Pmin = -95;

groupSize = 500;
iteration = 300;
mutProb = 0.5;
crossProb = 0.5;

Range=selectedNode;
BTSRange = Range;
%Range=1:3547;

saveFile = 0

%% Scenario Single

[BTSLocation, maxFitness] = GA2D(BTS, tx, Pmin, std,...
    groupSize, iteration, mutProb, crossProb, display, Range, BTSRange, plainPL);

if report
    profile off
    profile report
end

%% Scenario Duplex
BTS = input('BTS=');
stdmin = input('stdmin=');
stdmax = input('stdmin=');
Range = input('Range=');
    for std=stdmin:stdmax
        BTSLocation = GA2D(BTS, tx, Pmin, std,...
            groupSize, iteration, mutProb, crossProb, display,Range);
        if savveFile
            filename = sprintf('BTSLocation_std%d_BTS%d',std,BTS);
            save(filename,'BTSLocation');
        end
    end

