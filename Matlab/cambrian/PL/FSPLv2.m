function [PL] = FSPLv2(f_MHz,n,d)
PL = 20*log10(d)+10*n*log10(f_MHz)-27.55;
end

