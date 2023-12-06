c1=80;
c2=116;
c3=161;
c4=239;
c5=497;
c6=958;
c7=4367;

TRI_range=zeros(3547,1);
std = zeros(3547,1);

for i=1:3547
    if TRI(i)<c7
        TRI_range(i)=7;
        std(i)=6;
    end
    if TRI(i)<c6
        TRI_range(i)=6;
        std(i)=4;
    end
    if TRI(i)<c5
        TRI_range(i)=5;
        std(i)=4;
    end
    if TRI(i)<c4
        TRI_range(i)=4;
        std(i)=3;
    end
    if TRI(i)<c3
        TRI_range(i)=3;
        std(i)=3;
    end
    if TRI(i)<c2
        TRI_range(i)=2;
        std(i)=2;
    end
    if TRI(i)<c1
        TRI_range(i)=1;
        std(i)=2;
    end
end
