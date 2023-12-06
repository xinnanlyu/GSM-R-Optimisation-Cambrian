function [distance] = nodeDistance(node1,node2,track)
%NODEDISTANCE Summary of this function goes here
%   Detailed explanation goes here

node1=track(node1,:);
node2=track(node2,:);

distance=norm(node1 - node2);
distance=round(distance);
end

