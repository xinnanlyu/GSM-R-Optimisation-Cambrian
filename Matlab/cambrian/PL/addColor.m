function [color] = addColor(index)
%ADDCOLOR Summary of this function goes here
%   Detailed explanation goes here

switch index
    case 1
        color='r';
    case 2
        color='b';
    case 3
        color='m';
    case 4
        color='g';
    otherwise
        color='k';
end
       
end

