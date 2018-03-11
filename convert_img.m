directory = 'C:\Users\ASUS\Pictures\Camera Roll\';
new_src = 'D:\Thesis\Thesis\database\official\test\';
format = '*.jpg';
dir_path = strcat(directory,format);
src_Files = dir(dir_path);
num_jpg_img = length(src_Files);
for i = 1 : num_jpg_img
  file_name = strcat(directory,src_Files(i).name);
  I = imread(file_name);
%   I = preprocess_v2(I);
I = rgb2gray(I);
  new_file = strrep(src_Files(i).name,'jpg','tiff');
  imwrite(I,strcat(new_src,new_file));
end