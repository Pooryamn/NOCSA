function [X,fit]=BinaryInitialization(fobj,SearchAgents_no,dim,ub,lb)

    % this global variable is for
    % saving the AP of each crow
    % we use Dynamin Awareness Probability
    global DAP

    % this loop is the main step of initialization
    % it has 2 main steps :
    %   1) create a random array.
    %      size of array equals Dimentions
    %      in the begining array elements are
    %      between [0 1]
    %      then we set a cindition for them 
    %      if an element is bigger than some number 
    %      it is true else it is false 
    %      so finally we have a logical array
    %      if element is 1(True) it has been selected 
    %      obviously if the Limit number is small 
    %      more features pass the condition 
    %      and our crow select more features
    
    %      after selection features we calculate the fitness
    for i = 1 : SearchAgents_no
        X( i, : ) = rand( 1, dim) > 0.2; 
        fit( i ) = feval(fobj,X(i,:));    
    end
    
    %sort fitness and posttions
    for j=1:SearchAgents_no
        for k=j:SearchAgents_no
            
            if(fit(j)<fit(k))
                
                % swap fitness
                tmp = fit(j);
                fit(j) = fit(k);
                fit(k) = tmp;
                
                % swap position because of swaping fitness
                tmp_arr = X(j,:);
                X(j,:) = X(k,:);
                X(k,:) = tmp_arr;
            end
        end
    end
    
    % calculate DAP vector
    % its formula is :
    % DAP(i) = AP_min + ( AP_max - AP_min)*(Rank / number_of_crows)
    % AP_min = 0.1
    % AP_max = 0.8
    % our rank is in order because we sort our crows in Descending order
    % that means best crow is first crow.
    for i=1:SearchAgents_no
        DAP(i) = 0.1 + (0.7*(i/SearchAgents_no));
    end      
end