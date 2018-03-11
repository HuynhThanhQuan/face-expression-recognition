directory = 'D:\Thesis\Thesis\database\official\test\';
format = '*.tiff';
dir_path = strcat(directory,format);
src_Files = dir(dir_path);
num_jpg_img = length(src_Files);
for i = 1 : num_jpg_img
  file_name = strcat(directory,src_Files(i).name);
  I = imread(file_name);
  if strcmp(format,'*.gif')==1
    I = imcomplement(I);
  end
  I = convert_grayscale(I);
  I = repmat( I, [1,1,3] );
  detector = buildDetector();
  detectFaceParts(detector,I,3);
end