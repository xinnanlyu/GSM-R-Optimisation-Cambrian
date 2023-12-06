function [PL] = FSPL(f_MHz,d)
PL = 20*log10(d)+20*log10(f_MHz)-27.55;
end

