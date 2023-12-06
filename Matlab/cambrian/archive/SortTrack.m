[trackSorted,I]=sort(track,1);
for i=1:3
    trackSorted(:,i)=track( I(:,1),i );
end
 scatter3(trackSorted(:,1),trackSorted(:,2),trackSorted(:,3),[],trackSorted(:,3))
 colorbar
 