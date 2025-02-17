rows = 5;  
cols = 5; 

load('trainLabel.mat');
load('testLabel.mat');

X = [];
XTest = [];

properties = {'Area', 'Perimeter', 'Circularity', 'Eccentricity', 'MajorAxisLength', 'MinorAxisLength', 'Orientation'};

FILTERSIZE = 5555;


for i = 1:25
    filename = ['trainset/', num2str(i), '.jpg'];
    img = imread(filename);

    % ----------------- Binary Image -----------------
    gray_img = im2double(rgb2gray(img));
    blur_img = im2double(imboxfilt(gray_img, FILTERSIZE));

    output = gray_img ./ blur_img;
    output = medfilt2(output, [3 3]);

    level = graythresh(output);
    BW = ~imbinarize(output, level);
    
    BW_filled = imfill(BW, 'holes');   

    % --------------- Feature Extraction---------------
    STATS = regionprops(BW_filled, properties);     

    if ~isempty(STATS)
        [~, maxIdx] = max([STATS.Area]);
        largestRegion = struct2table(STATS(maxIdx));  
        X = [X; largestRegion(:, 2:end)]; 
    end
    % -------------------------------------------------

end

Mdl = fitcecoc(X,trainLabel);


% -------------------------------- Prediction --------------------------------
 for i = 1:15
     filename = ['testset/', num2str(i), '.jpg'];
     img = imread(filename);
 
     % ----------------- Binary Image -----------------
     gray_img = im2double(rgb2gray(img));
     blur_img = im2double(imboxfilt(gray_img, FILTERSIZE));
 
     output = gray_img ./ blur_img;
     output = medfilt2(output, [3 3]);
 
     level = graythresh(output);
     BW = ~imbinarize(output, level);
 
     BW_filled = imfill(BW, 'holes');
 
     % --------------- Feature Extraction---------------
     STATS = regionprops(BW_filled, properties);
 
     if ~isempty(STATS)
        [~, maxIdx] = max([STATS.Area]);
        largestRegion = struct2table(STATS(maxIdx));  
        XTest = [XTest; largestRegion(:, 2:end)]; 
    end
     % -------------------------------------------------
end

predictedLabels = predict(Mdl, XTest);
table(testLabel(:),predictedLabels (:),'VariableNames',{'TrueLabels','PredictedLabels'})