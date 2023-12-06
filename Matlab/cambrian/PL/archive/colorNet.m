% require cambrian_PL_processor to run first.


colornet=zeros(trackLength,trackLength);

P_TH1=-87;
P_TH2=-83;
P_TH3=-80;

for i=1:trackLength
    for j=1:trackLength
        
        temp=PR(i,j);
        
        if temp>P_ETCS2_HS
            colornet(i,j)=1;
            
            if temp>P_TH1
                colornet(i,j)=2;
                
                if temp>P_TH2
                    colornet(i,j)=3;
                    
                    if temp>P_TH3
                        colornet(i,j)=4;
                    end
                end
            end
        end
        
    end
    
    if mod(i,100)==0
        fprintf('*');
    end
    
end