
clc

display=input('If display specific BTS?');


fprintf('\n')
if(display==1)
    


N=input('Antenna No.');


figure()
scatter(trackX, trackY)
hold on
plot(BtsX(N),BtsY(N),'o','linewidth',5,'color','r')
axis equal
fprintf('BTS No.%d is %6.0f,%6.0f',N,BtsX(N)-xMin,BtsY(N)-yMin)

else
    
    for i=1:29
    fprintf('**.antenna[%d].mobility.initialX = %6.0f m\n',i-1,BtsX2(i)-xMin)
    fprintf('**.antenna[%d].mobility.initialY = %6.0f m\n',i-1,yMax-BtsY2(i))
    end
    
    
    
end