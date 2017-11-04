function [result] = task3(input_directory, output_directory)
    filenames = dir(fullfile(input_directory, '*.jpg'));
    num_images = length(filenames);
    result = [];
    fileID = fopen(strcat(output_directory,'/output.txt'), 'w');
    for i = 1 : num_images
        filename = fullfile(input_directory, filenames(i).name);
        img = imread(filename);
        features_row = calculate_features(img);
        result = [result; features_row];
        fprintf(fileID, '%s ', filenames(i).name);
        fprintf(fileID, '%10.5f ', features_row);
        fprintf(fileID, '\n');
    end
end