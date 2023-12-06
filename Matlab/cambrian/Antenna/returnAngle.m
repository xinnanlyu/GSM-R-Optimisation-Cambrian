function [angle] = returnAngle(pointStart,pointEnd)

relativeOriginal=pointEnd-pointStart; %3D

relative = [relativeOriginal(1),relativeOriginal(2)]; %% to 2D

reference = [1,0];

angle = acosd( dot(relative,reference)/ norm(relative,2) );

if relative(2)<0
    angle = -angle+360;
end

end

