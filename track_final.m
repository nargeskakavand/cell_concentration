clc;
clear;
close all;

%% Read the Image
file_name = 'test_flow.jpg'; % Update with the correct image file name
IG_org = imread(file_name);
figure(), imshow(IG_org), title('Original Image');

%% Convert to Gray Scale
%IG_org = rgb2gray(I_org);
figure(), imshow(IG_org), title('Grayscale Image');

%% Background Subtraction
I_BG = double(median(IG_org(:))) * ones(size(IG_org)); % Create a background of the same size as IG_org
I_BG = imcomplement(uint8(I_BG));
IG_org = imcomplement(IG_org);
IG = imsubtract(IG_org, I_BG);
IG = imadjust(IG, stretchlim(IG), []);
figure(), imshow(IG), title('Background Subtracted and Adjusted Image');

%% Top-hat and Bottom-hat Filtering
se = strel('disk', 80);
%ITH = imtophat(IG, se);
%IBH = imbothat(IG, se);
%figure(), imshow(ITH), title('Top-hat Filtered Image');
%figure(), imshow(IBH), title('Bottom-hat Filtered Image');

%% Binarize
I_BW = imbinarize(IG, 0.85);
figure(), imshow(I_BW), title('Binarized Image');

%% Region Properties Filtering
BW_areaFilt = bwpropfilt(I_BW, 'Area', [10 49]);
BW_extent = bwpropfilt(BW_areaFilt, 'Extent', [0 1]);
figure(), imshow(BW_extent), title('Filtered by Area and Extent');

%% Count the number of cells
stats = regionprops(BW_extent, 'Area', 'Centroid');
numCells = numel(stats);
disp(['Number of cells: ', num2str(numCells)]);

%% Create an Output Image with Black Background and White Particles
outputImage = zeros(size(BW_extent));
outputImage(BW_extent) = 255; % Set the detected particles to white (255)
outputImage = uint8(outputImage); % Convert to uint8 type for display
figure(), imshow(outputImage), title('Output Image with Black Background and White Particles');

%% Save the Output Image (Optional)
imwrite(outputImage, 'output_image.jpg'); % Save the output image as a file


