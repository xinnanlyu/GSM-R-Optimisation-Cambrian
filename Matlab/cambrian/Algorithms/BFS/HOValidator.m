function [isOK] = HOValidator(Pr,Range,HOMargin)

Pr = sort(Pr,2,'descend');

HOoccur = zeros(size(Pr,1),1);

if abs(Pr(:,1)-Pr(:,2))<=HOMargin
    HOoccur(:,1)=1;
end




end

