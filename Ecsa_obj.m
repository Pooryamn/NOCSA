function [ECSA_Fit9 ECSA_Fit8 ECSA_Fit7 ECSA_Acc Solution_len ]=Ecsa_obj(solution)
    
    % this variabe is for check the lenght of solution in each iteration
    Solution_len = sum(solution);
    
    if sum(solution)==0 %no feature is selected
        ECSA_Fit9=0;
        ECSA_Fit8=0;
        ECSA_Fit7=0;
        ECSA_Acc = 0;
        return;
    end
    
    global Data
    
    groups=Data(:,size(Data,2));
    meas=Data(:,solution);
    Data_All=[meas groups];
    
    k=5;
    Alp9 = 0.9;
    Alp8= 0.8;
    Alp7 = 0.7;
    
    indices = crossvalind('Kfold',size(Data_All,1),k);
    
    Accuracy=0;
    class=0;
    
     for i = 1:k
        test = (indices == i); train = ~test;
        Mdl = fitcknn(meas(train,:),groups(train,:),'Distance','cityblock','NumNeighbors',8,'Standardize',1,'BreakTies','nearest'); 
        class = predict(Mdl,meas(test,:));
        Actual=groups(test,:);
        for j=1:length(class)
            if class(j)== Actual(j)
                    Accuracy=Accuracy+1;
            end
        end
     end
     
     
     Accuracy = (Accuracy/length(Data));
     ECSA_Fit9 = Alp9*(1-Accuracy)+((1-Alp9)*((sum(solution)/(length(solution)))));
     ECSA_Fit8 = Alp8*(1-Accuracy)+((1-Alp8)*((sum(solution)/(length(solution)))));
     ECSA_Fit7 = Alp7*(1-Accuracy)+((1-Alp7)*((sum(solution)/(length(solution)))));
     ECSA_Acc = Accuracy;
end
