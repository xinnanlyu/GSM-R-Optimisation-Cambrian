function [BTSPosition] = BFS2D(Combinations, Range, tx, Pmin, std, display)

%tic

load('Data_Cambrian_track_relativeDistanceKM.mat')
load('plainPL.mat')


relativeDistance =relativeDistanceKM; %use KM
trackLength = length(relativeDistance);

bts = size(Combinations,2);
BTS = zeros(bts,1);
N=27;
maxFitness=0;
maxBTS= zeros(bts,1);

% generate a sequence

for BTS(1)=1:trackLength
    for BTS(2)=1+BTS(1):trackLength
        for BTS(3)=1+BTS(2):trackLength
            for BTS(4)=1+BTS(3):trackLength
                for BTS(5)=1+BTS(4):trackLength
                    for BTS(6)=1+BTS(5):trackLength
                        for BTS(7)=1+BTS(6):trackLength
                            for BTS(8)=1+BTS(7):trackLength
                                for BTS(9)=1+BTS(8):trackLength
                                    for BTS(10)=1+BTS(9):trackLength
                                        for BTS(11)=1+BTS(10):trackLength
                                            for BTS(12)=1+BTS(11):trackLength
                                                for BTS(13)=1+BTS(12):trackLength
                                                    for BTS(14)=1+BTS(13):trackLength
                                                        for BTS(15)=1+BTS(14):trackLength
                                                            for BTS(16)=1+BTS(15):trackLength
                                                                for BTS(17)=1+BTS(16):trackLength
                                                                    for BTS(18)=1+BTS(17):trackLength
                                                                        for BTS(19)=1+BTS(18):trackLength
                                                                            for BTS(20)=1+BTS(19):trackLength
                                                                                for BTS(21)=1+BTS(20):trackLength
                                                                                    for BTS(22)=1+BTS(21):trackLength
                                                                                        for BTS(23)=1+BTS(22):trackLength
                                                                                            for BTS(24)=1+BTS(23):trackLength
                                                                                                for BTS(25)=1+BTS(24):trackLength
                                                                                                    for BTS(26)=1+BTS(25):trackLength
                                                                                                        for BTS(27)=1+BTS(26):trackLength
                                                                                                            PLarray=plainPL(BTS,:);
                                                                                                            
                                                                                                            PL=min(PLarray,[],2);
                                                                                                            
                                                                                                            Pr=tx-PL;
                                                                                                            
                                                                                                            CovProb = 100*(1-0.5*erfc((  Pr  -Pmin)/(std*sqrt(2))));
                                                                                                            
                                                                                                            fitness=min(CovProb);
                                                                                                            
                                                                                                            if fitness>maxFitness
                                                                                                                maxBTS=BTS;
                                                                                                           end
                                                                                                            % do the fitness function
                                                                                                        end
                                                                                                    end
                                                                                                end
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
                                                                    




end