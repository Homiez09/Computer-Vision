load('trainLabel.mat');
load('testLabel.mat');
X = [];
XTest = [];

for i = 1:25
    filename = ['trainset/' num2str(i) '.jpg'];
    im = imread(filename);
    gray_im = rgb2gray(im);

    shade_im = double(imboxfilt(gray_im, 6001));
    shade_del_im = double(gray_im);
    shade_output = shade_del_im ./ shade_im;
    im_filtered = medfilt2(shade_output, [3 3]);

    level = graythresh(im_filtered);  
    binaryIm = ~imbinarize(im_filtered, level);  
    binaryIm_cleaned = imfill(binaryIm, 'holes');

    STATS = regionprops(binaryIm_cleaned, 'Perimeter', 'Circularity','Eccentricity','MajorAxisLength', 'MinorAxisLength', 'Orientation');
    X = [X; struct2table(STATS)];

end

Mdl = fitcecoc(X, trainLabel);

for i = 1:15
    filename = ['testset/' num2str(i) '.jpg'];
    im = imread(filename);
    gray_im = rgb2gray(im);

    shade_im = double(imboxfilt(gray_im, 5555));
    shade_del_im = double(gray_im);
    shade_output = shade_del_im ./ shade_im;
    im_filtered = medfilt2(shade_output, [3 3]);

    level = graythresh(im_filtered);  
    binaryIm = ~imbinarize(im_filtered, level);  
    binaryIm_cleaned = imfill(binaryIm, 'holes');

    STATS = regionprops(binaryIm_cleaned, 'Perimeter', 'Circularity','Eccentricity','MajorAxisLength', 'MinorAxisLength', 'Orientation');
    XTest = [XTest; struct2table(STATS)];
end



predictedLabels = predict(Mdl,XTest);
table(testLabel(:),predictedLabels (:),'VariableNames',{'TrueLabels','PredictedLabels'})