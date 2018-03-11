input_file = 'input_feature_data.xlsx';
target_file = 'target_feature_data.xlsx';

%% Neural network 
data = xlsread(input_file);
target_mat = xlsread(target_file);
net = neural_network_trainer(data,target_mat, false);

%% TEST
data = [];
[test_folder, test_files, data] = test_img(data);
for i=1:size(data,2)
    x = data(:,i);
    y = net(x)
    if (y(1)>y(2))
        test_files{2,i} = 'unhappy';
    else
        test_files{2,i} = 'happy';
    end
end

%% Generate result excel file
if isfloat(test_folder)
    fprintf(' No result is generated');
else
    name = strcat(test_folder,'result.txt');
    filePh = fopen(name,'w');
    for i=1:size(data,2)
        formatSpec = '%s    %s\n';
        fprintf(filePh,formatSpec,test_files{1,i},test_files{2,i});
    end
    fclose(filePh);
end