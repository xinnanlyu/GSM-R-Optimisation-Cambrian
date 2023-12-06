clear

load('Data_Cambrian_track.mat')

relativeDistance = zeros(trackLength,trackLength);

for i=1:trackLength
    for j=1:trackLength
        relativeDistance(i,j) = norm( track(i,:) - track(j,:)  );
        
        if relativeDistance(i,j)==0
            relativeDistance(i,j)=10;
        end
    end
end

clear i j track trackLength
