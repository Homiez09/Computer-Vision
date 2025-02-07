load('scramble_code.mat');
im = imread("scrambled_image.tif");
new_img = zeros(size(im));

for i = 1:length(c)
    new_img(:, c(i),:) = im(:, i, :);
end

temp_img = new_img;
for i = 1:length(r)
    new_img(r(i), :, :) = temp_img(i, :, :);
end

imshow(uint8(new_img));