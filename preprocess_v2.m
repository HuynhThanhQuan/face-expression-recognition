function rgb_img = preprocess_v2(img)
% if size(img,3)==1
%     rgb_img = repmat( img, [1,1,3] );
% else
%     rgb_img = img;
% end  
if size(img,3)==3
    img = rgb2gray(img);
end
img = medfilt2(img);
rgb_img = repmat( img, [1,1,3] );