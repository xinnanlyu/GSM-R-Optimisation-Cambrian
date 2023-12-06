N= 29;
X=size(track,1);
Pr=zeros(N,X);

d=1:X;

Pt=30+13;

for i=1:N
   
    for j=1:X
        
        b = [BTSOptimal(i,1),BTSOptimal(i,2)];
       D= norm([track(j,1),track(j,2)] - b );
       if(D==0)
           D=1;
       end
       
       Pr(i,j)=Pt-Plain_LUT(round(D));
    end
    
    fprintf("*")
end

fprintf("\n");

PrMax=zeros(1,X);

TH=-20;

Pr(Pr>TH)=TH;

for i=1:X
    PrMax(i) = max(Pr(:,i));
end

%% plot result
figure()
plot(d,PrMax,'.')
grid on

figure()
hold on
for i=1:N
    plot(d,Pr(i,:),'.')
end


%% handover analysis

HO=6;
HOArea=zeros(1,X);
BreakArea=zeros(1,X);
d=0.5;
th=-95;
for i=1:X
    for j=1:N
        Pd = PrMax(i) - Pr(j,i);
        if(Pd>HO-d && Pd<HO+d)
            HOArea(i)=1;
        end
        
        if(Pr(j,i)<th+d && Pr(j,i)>th-d)
            BreakArea(i)=1;
        end
    end
end
figure()
plot(track(:,1),track(:,2),'.','color','k');
hold on

HO = track(HOArea==1,:);
BA = track(BreakArea==1,:);
plot(HO(:,1),HO(:,2),'*','linewidth',2,'color','r')
plot(BA(:,1),BA(:,2),'*','linewidth',2,'color','c')
axis equal
grid on

            

            
            
            
            
            