function [PL_index, std] = StdProcessor(Gs_bts)

deviation1=20; %plain
deviation2=50; %plain tough
deviation3=75; %mountain
deviation4=100; %mountain tough

gs=Gs_bts(length(Gs_bts));

if gs>deviation4
    PL_index=2;
    std=9;
elseif gs>deviation3
    PL_index=2;
    std=7.5;
elseif gs>deviation2
    PL_index=2;
    std=6;
elseif gs>deviation1
    PL_index=1;
    std=4;
else
    PL_index=1;
    std=3;
end

end

