input_file = 'input_feature_data.xlsx';
target_file = 'target_feature_data.xlsx';

%% Neural network 
data = xlsread(input_file);
target_mat = xlsread(target_file);
neural_network_trainer(data,target_mat, true);