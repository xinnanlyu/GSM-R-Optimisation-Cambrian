function ShowGAResult(BTSLocationAll)

load('Data_Cambrian_track.mat')

max=size(BTSLocationAll,1);

if max>1
    fprintf('There are %d Results Available', max);
    display = input('Display No.=');
elseif max==1
    display=1;
else
    fprintf('Import Error!')
end

figure()


scatter(track(:,1)/1e3,track(:,2)/1e3);
hold on

BTSLocation = BTSLocationAll(display,:);
scatter(track(BTSLocation,1)/1e3,track(BTSLocation,2)/1e3,'LineWidth',5)


hold off
axis equal
grid on


end

