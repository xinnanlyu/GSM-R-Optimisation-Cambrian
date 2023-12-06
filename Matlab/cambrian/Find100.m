    while finder1==0 && finder2==1
        RBCoptimizeFinder;
        Cambrian_1_RBC_v2;
        
        timer=toc;
        fprintf('Time=%5.1fmin\n',timer/60);
        
        if maxvalue<percent
            ymax=ymax-100;
            finder2=0;
            
        elseif ymax<(59248+thresholdDistance)
            ymax=ymax+100;
        else
            break
        end
    end