function [RetX,RetFit]= MySort(X,fitness,arr_size)
    for j=1:arr_size
        for k=j:arr_size
            
            if(fitness(j)<fitness(k))
                
                % swap fitness
                tmp = fitness(j);
                fitness(j) = fitness(k);
                fitness(k) = tmp;
                
                % swap position because of swaping fitness
                tmp_arr = X(j,:);
                X(j,:) = X(k,:);
                X(k,:) = tmp_arr;
            end
        end
    end
    RetX = X;
    RetFit = fitness;
end