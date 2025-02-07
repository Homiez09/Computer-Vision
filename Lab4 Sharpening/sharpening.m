img = imread('dark_rays.jpg');

img = im2double(img);

blur_img = imgaussfilt(img, 20);

unsharp_mask = img - blur_img;
gamma = 2.5;
sharp_img = img + gamma * unsharp_mask;

figure;
subplot(1, 2, 1), imshow(img), title('Original Image');
subplot(1, 2, 2), imshow(imgaussfilt(sharp_img, 2)), title('Sharpened Image');
