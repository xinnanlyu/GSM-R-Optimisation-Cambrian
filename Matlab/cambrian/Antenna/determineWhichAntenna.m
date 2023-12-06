%{

load('Data_Cambrian_track.mat')
load('Data_Antenna_60.mat')

%}
clear

load('Data_DetermineWhichAntenna.mat')

AntennaBelong = zeros(trackLength,trackLength);

for i=1:trackLength
    
    angle_1=BtsA(i,1);
    angle_2=BtsA(i,2);
    
    for j=1:trackLength
        if i==j
            AntennaBelong(i,j)=1;
        else
            angle=returnAngle(track(i,:),track(j,:));
            
            compare_1 = abs(angle - angle_1);
            compare_2 = abs(angle - angle_2);
            
            if compare_1<compare_2
                AntennaBelong(i,j)=1; %closer to 1st antenna
            else
                AntennaBelong(i,j)=2; %closer to 2nd antenna
            end
            
        end
    end
    fprintf('*')
end
        