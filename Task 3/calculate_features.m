function [features] = calculate_features(image_vector)
    features = [];
    image_vector = rgb2gray(image_vector);
    [H, W] = size(image_vector);
    N = H * W;
    image_vector = reshape(image_vector, 1, N);
    image_vector = cast(image_vector, 'double');
    % Calculate The Mean
    mean = sum(image_vector) / N;
    features = [features mean];
    
    % Calculate Variance
    sigma2 = sum((image_vector - mean).^2) / N;
    features = [features sigma2];
    
    % Calculate Standard deviation
    sigma = sqrt(sigma2);
    features = [features sigma];
    
    % Calculate Smoothness
    R = 1 - (1 / (1 + sigma2));
    features = [features R];
    
    % Calculate Skewness
    M3 = sum((image_vector - mean).^3) / (N * sigma^3);
    features = [features M3];
    
    % Calculate Kurtosis
    M4 = sum((image_vector - mean).^4) / (N * sigma^4);
    features = [features M4];
    
    % Normalizing image
    Z = (image_vector - min(image_vector)) / (max(image_vector) -min(image_vector));
   
    % Calculate Uniformity
    IL = unique(Z);
    L = numel(IL);
    p = hist(Z, L);
    U =  p.^2 * transpose(IL);
    
    features = [features U];
    
    % Calculate Entropy
    e = -sum(p * transpose(log2(p)));
    
    features = [features e];
    
    % Applying GLCM
    image_vector = (image_vector - min(image_vector)) / (max(image_vector) -min(image_vector));
    image_vector = round((7 * image_vector) + 1);
    
    % Restoring Image to H * W for GLCM
    image_vector = reshape(image_vector, H, W);
    
    C = zeros(8,8);
    
    for y = 1 : H
        for x = 1 : W - 2
            C(image_vector(y, x), image_vector(y, x + 2)) =  C(image_vector(y, x), image_vector(y, x + 2)) + 1;
        end
    end
    
    % Make matrix symmetric 
    C  = C + transpose(C);
    
    % Normalize the matrix
    C = C / sum(sum(C));
    
    % Calculating Contrast
    contrast = 0;
    for i = 1 : 8
        for j = 1 : 8
            contrast = contrast + ((i - j)^2 * C(i,j));
        end
    end
    features = [features contrast];
    
    % Calculating Entropy
    e = 0;
    for i = 1 : 8
        for j = 1 : 8
            e = e - C(i,j) * log2(C(i,j));
        end
    end
    features = [features e];
    
    % Calculating Energy
    e = 0;
    for i = 1 : 8
        for j = 1 : 8
          e = e + (C(i,j)^2);
        end
    end
    features = [features e];
    
    % Calculating Homogenity
    H = 0;
    for i = 1 : 8
        for i = 1 : 8
            H = H + (C(i,j) / (1 + abs(i-j)));
        end
    end
    features = [features H];
end