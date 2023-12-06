pre='https://maps.googleapis.com/maps/api/elevation/json?locations=';
%key='&key=AIzaSyDjj-qOycY7HHaAT-pNAW4zvkyJHw-sug4';
%key='&key=AIzaSyBcB_FW7c_SnDms_tkKC58f2eHQoCz02Ks';
%key='&key=AIzaSyDfX5J7cCOj6yZtnIkax29Hgqg_rTBM-mk';
key='&key=AIzaSyD-Telt0pG1yi6jcZvoUzhATsWstKxINqA';
%AIzaSyD-Telt0pG1yi6jcZvoUzhATsWstKxINqA
%elevation=zeros(3547,1);
%key=key1;
parfor i=1:3547
    if elevation(i,1)==0 
    url=[pre num2str(xCo(i)) ',' num2str(yCo(i)) key];
    try
    read=webread(url);
    elevation(i,1)=read.results.elevation;
    catch
        fprintf('i=%d timeout!\n',i)
        
    end
    
    end
end
n=0;
for i=1:3547
    if elevation(i,1)==0 
        n=n+1;
        fprintf('i=%d is zero\n',i);
        url=[pre num2str(xCo(i)) ',' num2str(yCo(i)) key];
        fprintf(url)
    end
end
fprintf('%d results remains!\n',n)

%'https://maps.googleapis.com/maps/api/elevation/json?locations=39.7391536,-104.9847034&key=AIzaSyDfKEEkE93BFrLPswJoI74oA6_LHIHMg-4'