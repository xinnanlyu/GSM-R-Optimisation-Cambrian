

trackLength=3547;
load('relativeDistance.mat')
%TX=ones(trackLength,trackLength)*(txPower+antennaGain);
PL=zeros(trackLength,trackLength);

for i=1:trackLength
    for j=1:trackLength
        %PL(i,j)=plain_D(0.001*D(i,j));
        PL(i,j)=cutting_D(0.001*D(i,j));
    end
    if mod(i,100)==0
        fprintf('*');
    end
end

%PR=TX-PL;

% clear TX i j PL D