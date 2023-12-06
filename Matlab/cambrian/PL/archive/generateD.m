% Load Cambrian Track First

D=zeros(trackLength,trackLength);


for i=1:trackLength
    for j=1:trackLength
        
        relativeNode=norm(track(i,:) - track(j,:));
        D(i,j)=round(relativeNode);
        
    end
end

save('relativeDistance','D')

