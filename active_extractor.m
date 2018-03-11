%% User interface to select happy and unhappy folder
[happy_folder,unhappy_folder] = user_interface;
data = [];
if isfloat(happy_folder) || isfloat(unhappy_folder)
    fprintf('Please set the folder database');
else
    %% Load happy images database
    [h_num,data] = read_img_v2(data, happy_folder);

    %% Load unhappy images database
    [u_num,data] = read_img_v2(data, unhappy_folder);

    %% Generate input data 
    input_file = 'input_feature_data.xlsx';
    xlswrite(input_file, data);

    %% Generate target data
    target_file = 'target_feature_data.xlsx';
    h_matrix = [0; 1];
    u_matrix = [1; 0];
    h_mat_set = repmat(h_matrix,1,h_num);
    u_mat_set = repmat(u_matrix,1,u_num);
    target_mat = cat(2,h_mat_set,u_mat_set);
    xlswrite(target_file, target_mat);

    %% DONE TRAINING
    fprintf('Extracting feature is completed. ');
end