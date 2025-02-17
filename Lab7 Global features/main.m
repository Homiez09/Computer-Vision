rows = 5;  
cols = 5; 

load('trainLabel.mat');
load('testLabel.mat');

X = [];
XTest = [];

properties = {'Perimeter', 'Circularity','MajorAxisLength', 'MinorAxisLength', 'Orientation'};


for i = 1:25
    filename = ['trainset/', num2str(i), '.jpg'];
    img = imread(filename);

    % ----------------- Binary Image -----------------
    gray_img = im2double(rgb2gray(img));
    blur_img = im2double(imboxfilt(gray_img, 5555));

    output = gray_img ./ blur_img;
    output = imgaussfilt(output, 10);

    level = graythresh(output);
    BW = ~imbinarize(output, level);
    
    BW_filled = imfill(BW, 'holes');
    

    % --------------- Feature Extraction---------------
    STATS = regionprops(BW_filled, properties);

    X = [X; struct2table(STATS)];
    % -------------------------------------------------

end

Mdl = fitcecoc(X,trainLabel);


% -------------------------------- Prediction --------------------------------
for i = 1:15
    filename = ['testset/', num2str(i), '.jpg'];
    img = imread(filename);

    % ----------------- Binary Image -----------------
    gray_img = im2double(rgb2gray(img));
    blur_img = im2double(imboxfilt(gray_img, 5555));

    output = gray_img ./ blur_img;
    output = imgaussfilt(output, 10);

    level = graythresh(output);
    BW = ~imbinarize(output, level);
    
    BW_filled = imfill(BW, 'holes');
    

    % --------------- Feature Extraction---------------
    STATS = regionprops(BW_filled, properties);

    XTest = [XTest; struct2table(STATS)];
    % -------------------------------------------------
end

predictedLabels = predict(Mdl,XTest);
table(testLabel(:),predictedLabels (:),'VariableNames',{'TrueLabels','PredictedLabels'})