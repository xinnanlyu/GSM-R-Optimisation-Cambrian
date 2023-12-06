function [PL] = PL_Emp(f_MHz,ht,hr,n1,n2,d)

eff=0.9; % reference distance correction

d0=Calculate_d0(f_MHz,ht,hr)*eff;

dSize=size(d);

if dSize(1,1)>1 || dSize(1,2)>1
    PL=zeros(dSize);
    for i=1:dSize(1,1)
        for j=1:dSize(1,2)
            if d(i,j)<=d0
                PL(i,j) = FSPLv2(f_MHz,n1,d(i,j));
            else
                PL(i,j) = FSPLv2(f_MHz,n1,d0) + 10*n2*log(d(i,j)/d0);
                %fprintf('.')
            end
        end
    end
else
    if d<=d0
        PL = FSPLv2(f_MHz,n1,d);
    else
        PL = FSPLv2(f_MHz,n1,d0) + 10*n2*log(d/d0);
    end
end








end

