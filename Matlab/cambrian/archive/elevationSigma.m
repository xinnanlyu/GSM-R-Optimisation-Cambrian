%tic
fprintf('1-3547\n');

scanAll=input('Scan All=');

if(scanAll==0)
    start=input('Scan from=');
    finish=input('Scan to=');
else
    start=1;
    finish=3547;
end

radius=input('Scan Radius=');

try
    trackLength=length(trackX);
    worldLength=length(world);
catch
    load('CambrianData4withElevation.mat')
    load('CambrianWorld2.mat')
    trackLength=length(trackX);
end

trackSigma=zeros(trackLength,1);

tic
for i=start:finish
    %{
    track=[trackX(i),trackY(i)];
    rangeElevation=[];
    parfor j=1:worldLength
        world=[worldX(j),worldY(j)];
        distance=norm(track - world);
        if distance<=radius
            rangeElevation=[rangeElevation;worldZ(j)];
        end
    end
    %}
    trackXmin=trackX(i)-radius;
    trackXmax=trackX(i)+radius;
    trackYmin=trackY(i)-radius;
    trackYmax=trackY(i)+radius;
    rangeIndex=find(world(:,1)<=trackXmax & world(:,1)>=trackXmin & world(:,2)<=trackYmax & world(:,2)>=trackYmin);
    
    trackSigma(i)= std(world(rangeIndex,3));
    T=toc;
    timeRemain=T/(i-start+1)*(finish-i)/60;
    fprintf('track %4.0f complete! Sigma=%3.2f, Time remain=%3.1fmin\n',i,trackSigma(i),timeRemain);
    
end

save(['trackSigma',num2str(radius),'.mat'],'trackSigma');
fprintf('Total Time=%1.0fh %2.0fmin\n',fix(T/3600),mod(T,3600)/60)
%profile off
%profile report

%figure()
%scatter3(trackX/1000,trackY/1000,trackSigma,[],trackSigma);
%colorbar


%toc