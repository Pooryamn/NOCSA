

% -------------------------------------------------
% Citation details:
% G. Sayed, A. Hassanien and A. Taher, “Feature selection via a novel chaotic crow search algorithm”,
% Neural Computing and Applications, DOI  10.1007/s00521-017-2988- , 1-32,
% 2017.

% Programmed by Gehad Ismail Sayed
% Faculty of Computers and Information, Cairo University
% Date of programming: October 2017 %
% -------------------------------------------------
% This demo implements chaotic CSA as feature selection aglorithm
% -------------------------------------------------
function [Worst,Best,Mean,SD,ASS,ECSA_fit_Mean9,ECSA_ACC_Mean]=BCCSA(x,ft,N,tmax,l,u,pd,fobj,AP,fl,ChaosVec)

    % this is global DAP that we calculated 
    % in initialization step.
    global DAP

    % do not show numbers in scientific symbol
    format long; 
    
    % initialize the algorithm variables
    
    % xn is a vector for saving positions 
    % it will use for position updating
    xn=x;
    
    % each crow has a position memory
    % mem vector save crows memories
    % at the begin first position is the memory
    mem=x; % Memory initialization
    
    % this vector save the fitness values.
    fit_mem=ft; % Fitness of memory positions
    
    
    % this is the main loop
    % crows will search the search space tmax times
    for t=1:tmax
        % print number of iteration
        fprintf('    Iter: %i\n', t)
        % ********************** Chaotic Part *********************
        % in each iteration we use one of the chaos values
        rvalue=ChaosVec(t);
        
        % idx is the index of the crow
        idx = 1;
        
        % in this two nested loops we set a crow neighbors
        % each crow is neighbor with 10 corws after its position
        % so "crow i" is our main crow
        % and "crow k" is the neighbors of "crow i"
        % this condition generate 100 positions
        % we have neighbors list of each crow 
        % based on this loops :
        % corw 1 : 2 - 11
        % corw 2 : 3 - 12
        % corw 3 : 4 - 13
        % corw 4 : 5 - 14
        % corw 5 : 6 - 15
        % corw 6 : 7 - 16
        % corw 7 : 8 - 17
        % corw 8 : 9 - 18
        % corw 9 : 10 - 19
        % corw 10 : 11 - 20
        for i=1:10
            for k=i+1:i+10
                
                % we set DAP to 0.2 so 
                % first 70 crows will search localy
                % next 30 crows will search globaly
                if DAP(i) <= 0.2 
                    
                    % this is the main formula of CSA
                    % X(t+1) = X(t) + fl * chaosValue * (memory(neighbor) - X(t))
                    % this formula has a condition 
                    % so we have a logical array here
                    xnew(idx,:)= (x(i,:)+fl*rvalue*(mem(k,:)-x(i,:)))>0.5; % Generation of a new position for crow i (state 1)
                    
                    % this part is a little confusing
                    % but it adds 1 or 2 feature to selected position 
                    v1=sigmf(xnew(i,:),[10 0.9]);%eq. 25
                    
                    % transfer function (V2)
                    r=rand;
                    v1 = tanh(v1);
                    v1(v1<r)=0;
                    v1(v1>=r)=1;
                    xnew(idx,:)=(xnew(idx,:)+v1)>=1;
                    
                    
                    idx = idx + 1 ;
                else
                    % here we are in global search part
                    % first we generate a vector for 
                    % our chaos values
                    Chaos_Values = chaos(11,pd,1);
                    
                    % this loop runs for each feature
                    for j=1:pd
                       
                        % if our Chaos_value is bigger than
                        % some value this will selected.
                        xnew(idx,j)= Chaos_Values(j) > 0.5; % Generation of a new position for crow i (state 2)
                        
                        % this part is a little confusing
                        % but it adds 1 or 2 feature to selected position
                        v1=sigmf(xnew(i,j),[10 0.9]);%eq. 25
                        % transfer function (V2)
                        v1 = tanh(v1);
                        if v1<rand
                           v1=0;
                        else
                           v1=1;
                        end
                        xnew(idx,j)=(xnew(idx,j)+v1)>=1;
                    end
                     
                    idx = idx +1;
                end
           end
        end
        
        % after generating positions 
        % save them to xn
        xn=xnew;
        
        % calculate each crow fitness
        for ii = 1 : idx-1
            ft( ii ) = feval(fobj,xn(ii,:));
        end

        % sort fitnesses and positions 
        % now we have sorted crows from best to worst
        [xn,ft] = MySort(xnew,ft,length(xn));

        % for update position:
        % we set new position for our crows
        % from best to worst
        % and then check fitness
        % if fitness gets better so 
        % we replace it with old fitness
        % and new good position will be 
        % memory of our crow.
        for i=1:50 % Update position and memory
            x(i,:)=xn(i,:); % Update position
            if ft(i)>=fit_mem(i)
                mem(i,:)=xn(i,:); % Update memory
                fit_mem(i)=ft(i);
            end
        end



        % we take the value and index of the best crow here
        [ffit(t) maxidx]=max(fit_mem); % Best found value until iteration t
        
        % BS(t) is the position of the best crow in "t" iteration
        BS(t) = sum(xn(maxidx,:))/ pd;

        
        % call ECSA calculator 
        % send the best solution 
        [ffit_ecsa9(t) ffit_ecsa8(t) ffit_ecsa7(t) Acc_ecsa(t) Solution_len] = Ecsa_obj(xn(maxidx,:));

    end
    % the best value of fitness in this run of algorithm
    Destination_fitness=max(fit_mem);
    
    % the position of the best crow
    ngbest=find(fit_mem== min(fit_mem));
    g_best=mem(ngbest(1),:); % Solutin of the problem
    Destination_position=g_best;
    
    Convergence_curve=ffit;
    Sum_of_fitness = sum(Convergence_curve);
    Mean_val = Sum_of_fitness / tmax;

    Sum_of_ffit = sum(ffit);
    mean_based_on_bestes = Sum_of_ffit / tmax;

    % SD
    Mean_of_ffit = mean(ffit);
    for p=1:tmax
        bs_minus_mean(p) = ffit(p)- Mean_of_ffit;
        bs_minus_mean_2(p) = bs_minus_mean(p) ^ 2; 
    end

    sum_of_bs_minus_mean_2 = sum(bs_minus_mean_2);

    under_sqrt = sum_of_bs_minus_mean_2 / tmax;

    SD = sqrt(under_sqrt);


    Sum_of_BS = sum(BS);
    ASS = Sum_of_BS / tmax;

    Best = max(ffit);

    Worst = min(ffit);

    Mean = mean_based_on_bestes;

    ECSA_fit_Mean9 = mean(ffit_ecsa9);
    ECSA_ACC_Mean = mean(Acc_ecsa);

end
