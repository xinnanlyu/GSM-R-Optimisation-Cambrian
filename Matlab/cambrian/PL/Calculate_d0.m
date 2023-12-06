function [d0] = Calculate_d0(f_MHz,ht,hr)

d0=4*ht*hr*f_MHz*1e6/3e8;

end

