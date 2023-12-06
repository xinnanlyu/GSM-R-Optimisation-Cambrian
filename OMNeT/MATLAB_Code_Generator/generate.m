clear all
clc

filename = 'Hefei.xls';
sheetD = 1;
sheetO = 2;
sheetE = 3;
sheetZC= 4;
% D:default, O: odd, E: even

Xoffset = 4037.79;
Yoffset = 1026.45;

oddMode=0;
evenMode=1;

% oddmode=0 and evenmode=0: all AP
% oddmode=1 and evenmode=0: AP at one side
% oddmode=0 and evenmode=1: AP at the other side

if (oddMode==0) && (evenMode==0)
    sheetAP = sheetD;
elseif (oddMode==1) && (evenMode==0)
    sheetAP = sheetO;
elseif (oddMode==0) && (evenMode==1)
    sheetAP = sheetE;
else
    fprintf('Parameter error!\n');
end

% File is accessed and copied 7 times, setting up animation (sort of) 
% to indicate the progress

fprintf('\n\nOpening Files...\n')
fprintf('--------------------------------------------------  0.0 percent\n');

tic
APxRaw=xlsread(filename,sheetAP,'B:B');clc
time=toc;
fprintf('\n\nOpening Files...\n')
fprintf('*******------------------------------------------- 14.3 percent\n');
fprintf('time passed: %2.1fs, remains: %2.1fs\n',time,time/1*6);

APyRaw=xlsread(filename,sheetAP,'C:C');clc
time=toc;
fprintf('\n\nOpening Files...\n')
fprintf('**************------------------------------------ 28.5 percent\n');
fprintf('time passed: %2.1fs, remains: %2.1fs\n',time,time/2*5);

ZCi = xlsread(filename,sheetAP,'G:G');clc
time=toc;
fprintf('\n\nOpening Files...\n')
fprintf('*********************----------------------------- 42.9 percent\n');
fprintf('time passed: %2.1fs, remains: %2.1fs\n',time,time/3*4);

ZCx = xlsread(filename,sheetZC,'B:B');clc
time=toc;
fprintf('\n\nOpening Files...\n')
fprintf('****************************---------------------- 57.1 percent\n');
fprintf('time passed: %2.1fs, remains: %2.1fs\n',time,time/4*3);

ZCy = xlsread(filename,sheetZC,'C:C');clc
time=toc;
fprintf('\n\nOpening Files...\n')
fprintf('***********************************--------------- 71.4 percent\n');
fprintf('time passed: %2.1fs, remains: %2.1fs\n',time,time/5*2);

SWx = xlsread(filename,sheetZC,'E:E');clc
time=toc;
fprintf('\n\nOpening Files...\n')
fprintf('******************************************-------- 85.7 percent\n');
fprintf('time passed: %2.1fs, remains: %2.1fs\n',time,time/6*1);

SWy = xlsread(filename,sheetZC,'F:F');clc
APx = (APxRaw+Xoffset).*0.8;
APy = 24537 - (APyRaw+Yoffset)*0.8;
n = size(APx);

boundary=0;
ZCindex=1;

if 0   %devide mode, into seperate ZCs
for i=1:1:n

    if ZCi(i)==1
        fprintf('\n\n[Config ZC%d]\n',ZCindex);
        fprintf('description = Zone %d of 6\n',ZCindex);
        fprintf('extends = AbstractHefei\n\n');
        fprintf('**.ZC[0].mobility.initialX = %6.0f m\n',ZCx(ZCindex));
        fprintf('**.ZC[0].mobility.initialY = %6.0f m\n',ZCy(ZCindex));
        fprintf('**.switch[0].mobility.initialX = %6.0f m\n',SWx(ZCindex));
        fprintf('**.switch[0].mobility.initialY = %6.0f m\n\n',SWy(ZCindex));        
        boundary=i;
        ZCindex=ZCindex+1;
    end
    
    fprintf('**.ap[%d].mobility.initialX = %6.0f m\n',i-boundary,APx(n(1)-i+1));
    fprintf('**.ap[%d].mobility.initialY = %6.0f m\n',i-boundary,APy(n(1)-i+1));        
    
    if ZCi(i)==2
        fprintf('\n**.numAP = %d \n',i-boundary+1);
    end
    
end
end

if 1  %all in one mode
        fprintf('\n\n[Config ZCall]\n');
        fprintf('description = Zone 1 to 6\n');
        fprintf('extends = AbstractHefei\n');
        fprintf('\n**.numAP = %d \n',116);
for i=1:1:n

    if ZCi(i)==1
        fprintf('\n\n')
        fprintf('**.ZC[%d].mobility.initialX = %6.0f m\n',ZCindex-1,ZCx(ZCindex));
        fprintf('**.ZC[%d].mobility.initialY = %6.0f m\n',ZCindex-1,ZCy(ZCindex));
        fprintf('**.switch[%d].mobility.initialX = %6.0f m\n',ZCindex-1,SWx(ZCindex));
        fprintf('**.switch[%d].mobility.initialY = %6.0f m\n\n',ZCindex-1,SWy(ZCindex));        
        boundary=i;
        ZCindex=ZCindex+1;
    end
    
    fprintf('**.ap[%d].mobility.initialX = %6.0f m\n',i-1,APx(n(1)-i+1));
    fprintf('**.ap[%d].mobility.initialY = %6.0f m\n',i-1,APy(n(1)-i+1));        
    
   % if ZCi(i)==2
   %     fprintf('\n**.numAP = %d \n',i-boundary+1);
   % end
    
end
    
end





fprintf('\n\nPlease copy the code above into settingsHefei.ini within OMNeT++\n\n\n');



