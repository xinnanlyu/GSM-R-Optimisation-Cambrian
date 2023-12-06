%maxvalue=max(max(coverage));
maxvalue=max(max(max(coverage)));
maxindex=indexA;

resultCounter=1;
%{
if 0
for i=1:maxindex
    for j=1:maxindex
        %for k=1:maxindex
            if (coverage(i,j)==maxvalue)
                RBCresult1(resultCounter,:)=RBCoptimal(i,:);
                RBCresult2(resultCounter,:)=RBCoptimal(j,:);
                %RBCresult3(resultCounter,:)=RBCoptimal(k,:);
                resultCounter=resultCounter+1;
            end
        %end
    end
end
end
%}
clear RBCresult1 RBCresult2 RBCresult3
for i=1:maxindex
    for j=(i+1):maxindex
        for k=(j+1):maxindex
            if (coverage(i,j,k)==maxvalue)
                RBCresult1(resultCounter,:)=RBCoptimal(i,:);
                RBCresult2(resultCounter,:)=RBCoptimal(j,:);
                RBCresult3(resultCounter,:)=RBCoptimal(k,:);
                resulti=i;
                resultj=j;
                resultk=k;
                resultCounter=resultCounter+1;
            end
        end
    end
end