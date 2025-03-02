starbucks_dataset = dir('starbucks35_dataset/*.jpg');
ref_img = imread('reference_sm.jpg');
ref_gray_img = im2double(im2gray(ref_img));

for i = 1:length(starbucks_dataset)
    test_img = im2double(imread(['starbucks35_dataset/', starbucks_dataset(i).name]));
    test_gray_img = rgb2gray(test_img); 
  
    showMatches(ref_gray_img, test_gray_img, starbucks_dataset(i).name, ref_img, test_img);
end
