filename = ['lymphomalplzhang03_shade.jpg'];
img = imread(filename);

I = rgb2gray(img);
I = im2double(I);

B = imboxfilt(I, 413);
B = im2double(B);
% imshow(B);
output = I ./ B;

output = imgaussfilt(output, 9);

level = graythresh(output);
BW = ~imbinarize(output, level);


imshow(drawBoundary(img, BW));