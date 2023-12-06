% Need to load Cambrian World and Cambrian Data Core
% Calculate TRI Terrain Roughness Index

TRI = zeros(3547,1);

parfor i=1:3547
    tic
    x0=track(i,1);
    y0=track(i,2);
    
    
    %% minimize area
    xv = [x0+1.5e3,x0+1.5e3,x0-1.5e3,x0-1.5e3];
    yv = [y0+1.5e3,y0-1.5e3,y0-1.5e3,y0+1.5e3];
    in = inpolygon(world(:,1),world(:,2),xv,yv); 
    
    area = world(in,:);
    
    %% area -1,1
    xv=[x0-1.5e3,x0-0.5e3,x0-0.5e3,x0-1.5e3];
    yv=[y0+1.5e3,y0+1.5e3,y0+0.5e3,y0+0.5e3];
    
    in = inpolygon(area(:,1),area(:,2),xv,yv); 
    zm11=mean(area(in,3));
    
    
    %% area 0,1
    xv=[x0-0.5e3,x0+0.5e3,x0+0.5e3,x0-0.5e3];
    yv=[y0+1.5e3,y0+1.5e3,y0+0.5e3,y0+0.5e3];
    
    in = inpolygon(area(:,1),area(:,2),xv,yv); 
    z01=mean(area(in,3));
    
    
    %% area 1,1
    xv=[x0+0.5e3,x0+1.5e3,x0+1.5e3,x0+0.5e3];
    yv=[y0+1.5e3,y0+1.5e3,y0+0.5e3,y0+0.5e3];
    
    in = inpolygon(area(:,1),area(:,2),xv,yv); 
    z11=mean(area(in,3));
    
    
    %% area -1,0
    xv=[x0-1.5e3,x0-0.5e3,x0-0.5e3,x0-1.5e3];
    yv=[y0+0.5e3,y0+0.5e3,y0-0.5e3,y0-0.5e3];
    
    in = inpolygon(area(:,1),area(:,2),xv,yv); 
    zm10=mean(area(in,3));
    
    %% area 0,0
    xv=[x0-0.5e3,x0+0.5e3,x0+0.5e3,x0-0.5e3];
    yv=[y0+0.5e3,y0+0.5e3,y0-0.5e3,y0-0.5e3];
    
    in = inpolygon(area(:,1),area(:,2),xv,yv); 
    z00=mean(area(in,3));
    
    %% area 1,0
    xv=[x0+0.5e3,x0+1.5e3,x0+1.5e3,x0+0.5e3];
    yv=[y0+0.5e3,y0+0.5e3,y0-0.5e3,y0-0.5e3];
    
    in = inpolygon(area(:,1),area(:,2),xv,yv); 
    z10=mean(area(in,3));
    
    %% area -1,-1
    xv=[x0-1.5e3,x0-0.5e3,x0-0.5e3,x0-1.5e3];
    yv=[y0-0.5e3,y0-0.5e3,y0-1.5e3,y0-1.5e3];
    
    in = inpolygon(area(:,1),area(:,2),xv,yv); 
    zm1m1=mean(area(in,3));
    
    %% area 0,-1
    xv=[x0-0.5e3,x0+0.5e3,x0+0.5e3,x0-0.5e3];
    yv=[y0-0.5e3,y0-0.5e3,y0-1.5e3,y0-1.5e3];
    
    in = inpolygon(area(:,1),area(:,2),xv,yv); 
    z0m1=mean(area(in,3));
    
    %% area 1,-1
    xv=[x0+0.5e3,x0+1.5e3,x0+1.5e3,x0+0.5e3];
    yv=[y0-0.5e3,y0-0.5e3,y0-1.5e3,y0-1.5e3];
    
    in = inpolygon(area(:,1),area(:,2),xv,yv); 
    z1m1=mean(area(in,3));
    
    %% process
    TRI(i) = sqrt( (zm11-z00)^2+(z01-z00)^2+(z11-z00)^2+(zm10-z00)^2+(z10-z00)^2+(zm1m1-z00)^2+(z0m1-z00)^2+(z1m1-z00)^2);
    
    T=toc;
    fprintf('%4.0f of 3547 completed, TRI=%3.1f, Time=%2.1f seconds\n',i,TRI(i),T);
end