feature_vector = zeros(12, 3);

for i = 1:12
    filename = ['lab5-images/', num2str(i), '.jpg'];
    img = imread(filename);

    % ------------- Normalize color space -------------
    img_normalized = double(img);
    sum_rgb = sum(img_normalized, 3);

    for j = 1:3
        img_normalized(:,:,j) = img_normalized(:,:,j) ./ (sum_rgb);
    end
    % -------------------------------------------------
    
    img_hsv = rgb2hsv(img_normalized);

    a = img_normalized(:,:,1);
    b = img_normalized(:,:,2);
    c = img_normalized(:,:,3);
    
    k = find(img_hsv(:,:,2) > 0.3);

    R = mean(a(k));
    G = mean(b(k));
    B = mean(c(k));
    
    feature_vector(i,:) = [R, G, B];
end

Z = linkage(feature_vector, 'complete', 'euclidean');
c = cluster(Z, 'maxclust', 4);
disp(c);
scatter3(feature_vector(:,1), feature_vector(:,2), feature_vector(:,3),240,c,'fill');
