im = imread('lab2-long exposure/1.jpg');
new_img = 0;

for i = 1:300
    filename = ['lab2-noise averaging/puppy_', num2str(i) '.jpg'];
    temp_img = double(imread(filename));
    new_img = new_img + temp_img;
end

new_img =  uint8(new_img / 300);
imshow(new_img);