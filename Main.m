close all
clear all 
clc

% ================================================
% PARAMETERS
MAIN_RUN = 30;

% in this part we choose that how many 
%crows do we need to search in search space
SearchAgents_no=50; % Number of search agents

% our crows search the search space in Max_iter times.
Max_iter = 10; % Maximum numbef of iterations


OUTPUT_FILE_NAME = 'TMP';
% ================================================
% load data
global Data
Data=load('wine.csv');

% each dataset has some columns.
% one of them is class of group for classifing
% other are our features
dim=size(Data,2)-1;


% this is name of out fitness function
fobj='obj';

% create a vector to save the value of chaos maps
ChaosVec=zeros(11,Max_iter);

%Calculate chaos vectors
% it is 11:11 because we need chaos 11 only.
for i=11:11
    ChaosVec(i,:)=chaos(i,Max_iter,1);
end

% algorithm parameters
AP = 0.1;
fl = 2;

% this is the main loop of program.
% we can set number of algorithm runs.
% this loop has three steps:
%   1) initialize the crows
%   2) run the main algorithm
%   3) export data to an array 
for mainloop=1:MAIN_RUN
    fprintf('Run: %i\n', mainloop)
    [Positions Fitness]=BinaryInitialization(fobj,SearchAgents_no,dim,1,0);
    [Worst,Best,Mean,SD,ASS,ECSA_fit_Mean9,ECSA_ACC_Mean] = BCCSA(Positions, Fitness,SearchAgents_no,Max_iter,  0, 1,dim, fobj,AP,fl,ChaosVec(7,:)  );
    out_xls(mainloop,:) = [Worst,Best Mean SD ASS ECSA_fit_Mean9 ECSA_ACC_Mean];
end

% this line writes the outputs in a csv file. 
xlswrite(OUTPUT_FILE_NAME,out_xls);

% alert that the algorithm was finished !
