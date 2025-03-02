function showMatches(reference_gray, test_gray, test_img_name, ref_img, img)
    points_ref = detectSURFFeatures(reference_gray, 'MetricThreshold', 250);
    points_test = detectSURFFeatures(test_gray, 'MetricThreshold', 250);
    
    [features_ref, valid_points_ref] = extractFeatures(reference_gray, points_ref);
    [features_test, valid_points_test] = extractFeatures(test_gray, points_test);
    
    indexPairs = matchFeatures(features_ref, features_test, ...
        'Method', 'Exhaustive', ...
        'MatchThreshold', 50, ...
        'MaxRatio', 0.60);
    
    if ~isempty(indexPairs)
        matchedPoints_ref = valid_points_ref(indexPairs(:, 1));
        matchedPoints_test = valid_points_test(indexPairs(:, 2));
        
        try
            [tform, inlierIdx] = estimateGeometricTransform2D(...
                matchedPoints_test, matchedPoints_ref, 'affine');
            
            inlierPoints_ref = matchedPoints_ref(inlierIdx);
            inlierPoints_test = matchedPoints_test(inlierIdx);

            showMatchedPoints(ref_img, img, inlierPoints_ref, inlierPoints_test, test_img_name, true, size(inlierPoints_ref, 1));
            
        catch
            showMatchedPoints(ref_img, img, matchedPoints_ref, matchedPoints_test, test_img_name, false, size(indexPairs, 1));
        end
    else
        disp(['Not enough matches found in ', test_img_name, ' (', num2str(size(indexPairs, 1)), ' matches)']);
    end
end

function showMatchedPoints(reference_gray, test_gray, matchedPoints_ref, matchedPoints_test, test_img_name, use_inliers, num_matches)
    figure('Name', ['Matches found in ', test_img_name]);
    
    if use_inliers
        title(['Found ', num2str(num_matches), ' inliers']);
    else
        title(['Found ', num2str(num_matches), ' matches (no geometric filtering)']);
    end
    
    showMatchedFeatures(reference_gray, test_gray, ...
        matchedPoints_ref, matchedPoints_test, 'montage');
end
