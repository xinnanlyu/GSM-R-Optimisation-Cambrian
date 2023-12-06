function [ K ] = Kviaduct( RBC, train , denseSuburban)
Height=5; %height of viaduct
distance = 0.001*norm(RBC - train);
%denseSuburban = true;

if denseSuburban
    if distance>0.4
        K=(-0.00037*Height-0.18/(Height-19.71)+0.024)*distance+(0.148*Height+72/(Height-19.71)-0.56);
    else
        K=0.025*distance-0.84;
    end %dense
else
    if distance>0.4
        K=(-0.00037*Height-0.18/Height+0.017)*distance+(0.148*Height+72/Height-1.71);
    else
        K=0.012*distance+0.29;
    end %not dense
end %output K

end

