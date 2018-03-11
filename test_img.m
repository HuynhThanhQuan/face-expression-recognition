% Get list of all JPG, GIF and TIFF files in the given directory
% DIR returns as a structure array.
% Input: directory to read
% Output: number of images and an array stored all images
function [test_folder, test_files, data] = test_img(data)
test_folder = uigetdir('','Select test folder');
test_files = [];
if test_folder ~= 0
    test_folder = strcat(test_folder,'\');
end
% Read JPG format images
if isfloat(test_folder)
    fprintf('Please set the test folder database');
else
    jpg_format = '*.jpg';
    dir_path = strcat(test_folder,jpg_format);
    src_Files = dir(dir_path);
    num_jpg_img = length(src_Files);
    directory = test_folder;
    for i = 1 : num_jpg_img
      file_name = strcat(directory,src_Files(i).name);
      I = imread(file_name);
      I = preprocess_v2(I);
      test_files{i} = src_Files(i).name;
      [face, nose, mouth, right, left, bbox] = extract_face_component_v2(I);
      img_data = extract_feature(face,nose,mouth,right,left, bbox);
      data = [data img_data];
    end

    % Read TIFF format images
    jpg_format = '*.tiff';
    dir_path = strcat(directory,jpg_format);
    src_Files = dir(dir_path);
    num_tiff_img = length(src_Files);
    for i = 1 : num_tiff_img
      file_name = strcat(directory,src_Files(i).name);
      I = imread(file_name);
      I = preprocess_v2(I);
      total = i + num_jpg_img;
      test_files{total} = src_Files(i).name;
      [face, nose, mouth, right, left, bbox] = extract_face_component_v2(I);
      img_data = extract_feature(face,nose,mouth,right,left, bbox);
      data = [data img_data];
    end

    % Read GIF format images
    gif_format = '*.gif';
    dir_path = strcat(directory,gif_format);
    src_Files = dir(dir_path);
    num_gif_img = length(src_Files);
    for i = 1 : num_gif_img
      file_name = strcat(directory,src_Files(i).name);
      I = imread(file_name);
      % Convert to negative imgs
      I = imcomplement(I);
      I = preprocess_v2(I);
      total = i + num_jpg_img + num_tiff_img;
      test_files{total} = src_Files(i).name;
      [face, nose, mouth, right, left, bbox] = extract_face_component_v2(I);
      img_data = extract_feature(face,nose,mouth,right,left, bbox);
      data = [data img_data];
    end   
end