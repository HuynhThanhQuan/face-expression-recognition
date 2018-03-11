function I = convert_grayscale(I)

if size(I,3) == 3;
    I = rgb2gray(I);
end