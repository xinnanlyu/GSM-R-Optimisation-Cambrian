%scenario=500;
%{
%figure(scenario)
figure(1)
scatter(xCorrected,yCorrected)
hold on
plot(RBCresult1(scenario,1),RBCresult1(scenario,2),'o','LineWidth',10,'color','r')
plot(RBCresult2(scenario,1),RBCresult2(scenario,2),'o','LineWidth',10,'color','r')
hold off
grid on
title('Optimal RBC site - 2 RBCs')
%}

%{
for i=1:sizeRBCresult
    RBC1=RBCresult1(i,:);
    RBC2=RBCresult2(i,:);
    %RBC3=RBCresult3(i,:);
    distanceRBC12=norm(RBC1 - RBC2);
    %distanceRBC23=norm(RBC3 - RBC2);
    %distanceRBC13=norm(RBC1 - RBC3);
    totalDistance(i)=distanceRBC12;%+distanceRBC23;
end

[maxDistance,pos]=max(totalDistance);

figure(4)
scatter(xCorrected,yCorrected)
hold on
plot(RBCresult1(pos,1),RBCresult1(pos,2),'o','LineWidth',10,'color','r')
plot(RBCresult2(pos,1),RBCresult2(pos,2),'o','LineWidth',10,'color','r')
%plot(RBCresult3(pos,1),RBCresult3(pos,2),'o','LineWidth',10,'color','r')
hold off
grid on
title('Best Optimal RBC site - 3 RBCs')
fprintf('RBC1 X=%d,\t Y=%d\n',RBCresult1(pos,1),RBCresult1(pos,2));
fprintf('RBC2 X=%d,\t Y=%d\n',RBCresult2(pos,1),RBCresult2(pos,2));
%fprintf('RBC3 X=%d,\t Y=%d\n',RBCresult3(pos,1),RBCresult3(pos,2));
%}
%figure(1)
%sizeRBCresult=size(RBCresult1,1);

%{
scatter(xCorrected,yCorrected)
hold on
plot(RBCresult1(1,1),RBCresult1(1,2),'o','LineWidth',10,'color','r')
plot(RBCresult2(1,1),RBCresult2(1,2),'o','LineWidth',10,'color','r')
plot(RBCresult1(2,1),RBCresult1(2,2),'o','LineWidth',8,'color','g')
plot(RBCresult2(2,1),RBCresult2(2,2),'o','LineWidth',8,'color','g')
grid on
title('Best Optimal RBC site - 2 RBCs')
fprintf('Optimal Result %d\n',1);
fprintf('RBC1 X=%d,\t Y=%d\n',RBCresult1(1,1),RBCresult1(1,2));
fprintf('RBC2 X=%d,\t Y=%d\n\n',RBCresult2(1,1),RBCresult2(1,2));



scatter(xCorrected,yCorrected)
hold on
plot(RBCresult1(1,1),RBCresult1(1,2),'o','LineWidth',10,'color','r')
plot(RBCresult2(1,1),RBCresult2(1,2),'o','LineWidth',10,'color','r')
grid on
title('Best Optimal RBC site - 2 RBCs')
fprintf('RBC1 X=%d,\t Y=%d\n',RBCresult1(1,1),RBCresult1(1,2));
fprintf('RBC2 X=%d,\t Y=%d\n\n',RBCresult2(1,1),RBCresult2(1,2));
%}

sizeRBCresult=size(RBCresult1,1);

for i=1:sizeRBCresult
    figure(i)
    scatter(trainX,trainY)
    hold on
    plot(RBCresult1(i,1),RBCresult1(i,2),'o','LineWidth',5,'color','r')
    plot(RBCresult2(i,1),RBCresult2(i,2),'o','LineWidth',5,'color','r')
    plot(RBCresult3(i,1),RBCresult3(i,2),'o','LineWidth',5,'color','r')
    grid on
    hold off
    fprintf('RBC1 X=%d,\t Y=%d\n',RBCresult1(i,1),RBCresult1(i,2));
    fprintf('RBC2 X=%d,\t Y=%d\n',RBCresult2(i,1),RBCresult2(i,2));
    fprintf('RBC3 X=%d,\t Y=%d\n\n',RBCresult3(i,1),RBCresult3(i,2));
end