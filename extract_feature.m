function data = extract_feature(face,nose,mouth,right,left, bbox)
%% Position
%Bounding box
% bbox(1: 4) is bounding box for face
x1_face = bbox(1);
y1_face = bbox(2);
x2_face = bbox(3);
y2_face = bbox(4);

% bbox(5: 8) is bounding box for left eye
x1_left = bbox(5);
y1_left = bbox(6);
x2_left = bbox(7);
y2_left = bbox(8);

% bbox(9:12) is bounding box for right eye
x1_right = bbox(9);
y1_right = bbox(10);
x2_right = bbox(11);
y2_right = bbox(12);

% bbox(13:16) is bounding box for mouth
x1_mouth= bbox(13);
y1_mouth = bbox(14);
x2_mouth = bbox(15);
y2_mouth = bbox(16);

% bbox(17:20) is bounding box for nose
x1_nose = bbox(17);
y1_nose = bbox(18);
x2_nose = bbox(19);
y2_nose = bbox(20);

%% Preparing variables to calculate
% Convert to gray scale image, check if the image is RGB already or not
if size(face,3) == 3
    face = rgb2gray(face);
end;
if size(nose,3) == 3
    nose = rgb2gray(nose);
end;
if size(mouth,3) == 3
    mouth = rgb2gray(mouth);
end;
if size(right,3) == 3
    right = rgb2gray(right);
end;
if size(left,3) == 3
    left = rgb2gray(left);
end;

% Dimensions
[h_face, w_face] = size(face);
[h_nose, w_nose] = size(nose);
[h_mouth, w_mouth] = size(mouth);
[h_right, w_right] = size(right);
[h_left, w_left] = size(left);

% Areas
a_face = h_face * w_face;
a_nose = h_nose * w_nose;
a_mouth = h_mouth * w_mouth;
a_right = h_right * w_right;
a_left = h_left * w_left;

%% Extract feature
% HOG feature of face
[hog,visual] = extractHOGFeatures(mouth,'CellSize',[16 16]);
% 1 HOG mean value of face
hog_mean = mean(hog);
% 2 HOG median value of face
hog_median = median(hog);
% 3 HOG variance of face
hog_variance = var(hog);
% HOG RMS of face
hog_rms = rms(hog);

% 4 Areas of 2 eyes over face area
r_eyes_face = (a_right+a_left)/a_face;
% 5 Number of point of Harris Features on eyes
Harris_right = detectHarrisFeatures(right);
Harris_left = detectHarrisFeatures(left);
Harris_eyes = Harris_right.length + Harris_left.length;
% 6 Number of point of BRISK Features on eyes
Brisk_right = detectBRISKFeatures(right);
Brisk_left = detectBRISKFeatures(left);
Brisk_eyes = Brisk_right.length + Brisk_left.length;
% 7 Number of point of Harris Features on mouth
Harris_mouth = detectHarrisFeatures(mouth);

% Histogram of face
%  RMS of intensity histogram of face
[counts,binLocations] = imhist(gray);
hist_rms = rms(counts);
%  Median of intensity histogram of face
hist_mean = mean(counts);
%  Variance of intensity histogram of face
hist_variance = var(counts);

% Relations between face components and region properties
% 8 Mouth area over face area
r_mouth_face = a_mouth / a_face;
% 9 Nose area over mouth area
r_nose_mouth = a_nose / a_mouth;
% 10 Number of regions of MSER Features on eyes
MSER_right = detectMSERFeatures(right);
MSER_left = detectMSERFeatures(left);
MSER_eyes = MSER_right.length + MSER_left.length;
% 11 Distance of 2 eyes over face width
d_eyes_facewidth = w_face/abs(x1_right - x2_left);
% Nose height over mouth width
r_noseheight_mouthwidth = h_nose/w_mouth;
% Face height over face width
r_faceheight_facewidth = h_face/w_face;
% Mouth width over face width
r_mouthwidth_facewidth = w_mouth/w_face;
% Distance of nose to mouth over nose width
r_dnosemouth_nosewidth = abs(y2_nose - y1_mouth)/w_nose;
% Distance of eyes to mouth over mouth width
r_deyemouth_mouthwidth = abs(mean(y2_right + y2_left) - y1_mouth)/w_mouth;

% Entropy
% Intensity entropy of mouth
e_mouth = entropy(mouth);
% Intensity entropy of face surface
e_face = entropy(face);
% Intensity entropy of right eye area
e_right = entropy(right);
% Intensity entropy of left eye area
e_left = entropy(left);

%% Region property of mouth
% % Thresholding
median_mouth = median(median(mouth));
BW_mouth = mouth > median_mouth;
% Find the connected-component with 8-connectivity
CC_mouth = bwconncomp(BW_mouth,8);
regionprop_mouth = regionprops(CC_mouth,mouth,{'Centroid','Area', 'Orientation','Perimeter'});
% Find the maximum area of all connected components
area_mat_mouth =  cat(1, regionprop_mouth.Area);
[max_area_face, index] = max(area_mat_mouth);
% x location centroid of biggest region of mouth area
x_mouthcentroid = regionprop_mouth(index).Centroid(1);
% y location centroid of biggest region of mouth area
y_mouthcentroid = regionprop_mouth(index).Centroid(2);
% Orientation of biggest region of mouth area
orientation_mouth = regionprop_mouth(index).Orientation;
% Perimeter of biggest region of mouth area
perimeter_mouth = regionprop_mouth(index).Perimeter;

% Region property of face
% Thresholding
median_face = median(median(face));
BW_face = face > median_face;
% Find the connected-component with 8-connectivity
CC_face = bwconncomp(BW_face,8);
regionprop_face = regionprops(CC_face,face,{'Area'});
% Find the maximum area of all connected components
area_mat_face =  cat(1, regionprop_face.Area);
maxarea_face = max(area_mat_face);

% Region property of right eye
% Thresholding
BW_right = right < median(median(right));
% Find the connected-component with 8-connectivity
CC_right = bwconncomp(BW_right,8);
regionprop_right = regionprops(CC_right,right,{'Area', 'Orientation','Perimeter', 'BoundingBox'});
% Find the maximum area of all connected components
area_mat_right = cat(1, regionprop_right.Area);
[maxarea_right, index_right] = max(area_mat_right);
% Info of right eyebrow
orientation_right = regionprop_right(index_right).Orientation;
perimeter_right =  regionprop_right(index_right).Perimeter;
width_right = abs(regionprop_right(index_right).BoundingBox(1) - regionprop_right(index_right).BoundingBox(3));
height_right = abs(regionprop_right(index_right).BoundingBox(2) - regionprop_right(index_right).BoundingBox(4));
r_rightwidth_rightheight = width_right/height_right;
% Region property of left eye
% Thresholding
BW_left = left < median(median(left));
% Find the connected-component with 8-connectivity
CC_left = bwconncomp(BW_left,8);
regionprop_left = regionprops(CC_left,left,{'Area', 'Orientation','Perimeter', 'BoundingBox'});
% Find the maximum area of all connected components
area_mat_left = cat(1, regionprop_left.Area);
[maxarea_left, index_left] = max(area_mat_left);
% Info of left eyebrow
orientation_left = regionprop_left(index_left).Orientation;
perimeter_left =  regionprop_left(index_left).Perimeter;
width_left = abs(regionprop_left(index_left).BoundingBox(1) - regionprop_left(index_left).BoundingBox(3));
height_left= abs(regionprop_left(index_left).BoundingBox(2) - regionprop_left(index_left).BoundingBox(4));
r_leftwidth_leftheight = width_left/height_left;

%% Collect and structure data

data = hog_mean;                        %1
data = [data; hog_median];              %2
data = [data; hog_variance];            %3
data = [data; r_eyes_face];             %4
data = [data; Harris_eyes];             %5
data = [data; Brisk_eyes];              %6
data = [data; Harris_mouth.length];     %7
data = [data; r_mouth_face];            %8
data = [data; r_nose_mouth];            %9
data = [data; MSER_eyes];               %10
data = [data; d_eyes_facewidth];
data = [data; r_noseheight_mouthwidth];
data = [data; r_mouthwidth_facewidth];  %13
data = [data; r_dnosemouth_nosewidth];
data = [data; r_deyemouth_mouthwidth];  %15
data = [data; e_mouth];
data = [data; e_face];                  %17
data = [data; e_right];
data = [data; e_left];
data = [data; x_mouthcentroid];         %20
data = [data; y_mouthcentroid];
data = [data; orientation_mouth];
data = [data; perimeter_mouth];         %23
data = [data; maxarea_face];
data = [data; orientation_right];       %25
data = [data; perimeter_right];
data = [data; r_rightwidth_rightheight];%27
data = [data; orientation_left];
data = [data; perimeter_left];
data = [data; r_leftwidth_leftheight];  %30
