    finder1=1;
    finder2=0;
    
    while finder1==1 && finder2==0
        RBCoptimizeFinder;
        Cambrian_1_RBC_v2;
        
        timer=toc;
        fprintf('Time=%5.1fmin\n',timer/60);
        
        if maxvalue<percent 
            finder1=0;
            finder2=1;
            ymax=ymax-900;
        elseif ymax<(59248+thresholdDistance)
            ymax=ymax+1000;
        else
            break
        end
    end