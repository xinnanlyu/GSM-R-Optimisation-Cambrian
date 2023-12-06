

for size=1e2:1e2:1e3


area=zeros(size, size);

for i=1:size
    for j=1:size
        area(i,j)=mod(i+j,3);
    end
end
result=std(area);


fprintf("size=%3.0f, std=%3.2f\n",size,result);

end