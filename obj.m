function Fitness=obj(solution)

    % if a crow doesn't select an feature,
    % it's fitness will be 0
    if sum(solution)==0 %no feature is selected
        Fitness=0;
        return;
    end
    
    global Data
    
    % this is the last column of the dataset
    % this columns is exacly groups of the instance
    % we use this column to calculate our accuracy
    groups=Data(:,size(Data,2));
    
    % these are other columns 
    meas=Data(:,solution);
    
    % all of the data
    Data_All=[meas groups];
    
    % our "k" value for classification
    k=3;
    indices = crossvalind('Kfold',size(Data_All,1),k);
    
    % initialize accuracy and class values
    Accuracy=0;
    class=0;
    
     for i = 1:k
        % split train and test data
        test = (indices == i); 
        train = ~test;
        
        % run the main KNN funtion 
        % calss is the KNN output
        Mdl = fitcknn(meas(train,:),groups(train,:),'Distance','cityblock','NumNeighbors',8,'Standardize',1,'BreakTies','nearest'); 
        class = predict(Mdl,meas(test,:)); 
        
        
        % actual data from dataset
        Actual=groups(test,:);
        
        % calculate the accuracy 
        for j=1:length(class)
            if class(j)== Actual(j)
                    Accuracy=Accuracy+1;
            end
        end
     end
     
     % calculate accuract in percents
     Accuracy = (Accuracy/(k*length(class)));
     
     % main fitness formula
     % it is obvious that our fitness 
     % encourage the solutions to select
     % less feature because of high weight 
     % fio the secend part of formula
     Fitness = Accuracy+ 0.8*(1-(sum(solution)/(length(solution))));
     
end
