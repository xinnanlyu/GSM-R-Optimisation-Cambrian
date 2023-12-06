profile on

a=[0.25,0.74];
b=[10.37,15.32];
dist=[a;b];

repeat=100000;

tic
for i=1:1:repeat
    c=pdist2(a,b);    
end
toc

tic
for i=1:1:repeat
    c=pdist2(a,b,'squaredeuclidean');    
end
toc

tic
for i=1:1:repeat
    e=norm(a-b);
end
toc

profile off
profile report
    

%% Result: norm() win!