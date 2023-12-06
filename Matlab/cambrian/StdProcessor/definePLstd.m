function [PL_index, std] = definePLstd(gs)

deviation1=50; %plain
deviation2=100; %plain tough
deviation3=200; %mountain
deviation4=300; %mountain tough


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

