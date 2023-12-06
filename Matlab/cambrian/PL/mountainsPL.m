 %% calculate D
 
 fMHz = 925;
 
 ht=15;
 hr=3.8;

 
 PL_mt=PL_Emp(fMHz,ht,hr,2.4,3.88,relativeDistance);
 
 %% calculate based on d[]
 
 mountain = zeros(size(d));
 
 for i=1:length(d)
     mountain(i) = PL_Emp(923,15,3.8,2.4,3.88,d(i)*1000);
 end
 