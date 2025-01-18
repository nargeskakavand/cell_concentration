clc;
clear;
close all;

%% Read the Image
file_name = 'fc2_save_2024-11-21-175714-0160.jpg'; % Update with the correct image path
IG_org = imread(file_name);
figure(), imshow(IG_org), title('Original Image');

%% Convert to Gray Scale
if size(IG_org, 3) == 3 % Check if the image is RGB
    IG_org = rgb2gray(IG_org); % Convert to grayscale if it is RGB
end
figure(), imshow(IG_org), title('Grayscale Image');

%% Background Subtraction
% Adjust the median-based background subtraction
I_BG = medfilt2(IG_org, [50 50]); % Create a smoothed background
IG = imsubtract(IG_org, I_BG);    % Subtract the background
IG = imadjust(IG, stretchlim(IG), []); % Enhance contrast
figure(), imshow(IG), title('Background Subtracted and Adjusted Image');

%% Binarize
% Experiment with different threshold values
threshold = 0.55; % Adjust based on the particle intensity
I_BW = imbinarize(IG, threshold);
figure(), imshow(I_BW), title('Binarized Image');

%% Morphological Operations
% Remove small noise and fill gaps in particles
I_BW = bwareaopen(I_BW, 10); % Remove small objects (noise)
I_BW = imclose(I_BW, strel('disk', 2)); % Close small gaps
figure(), imshow(I_BW), title('Post Morphological Operations');

%% Region Properties Filtering
% Adjust the filtering range to capture the particles
minArea = 5; % Minimum particle size
maxArea = 100; % Maximum particle size (adjust based on particle size)
BW_areaFilt = bwpropfilt(I_BW, 'Area', [minArea maxArea]);
figure(), imshow(BW_areaFilt), title('Filtered by Area');

%% Count the number of cells
stats = regionprops(BW_areaFilt, 'Area', 'Centroid');
numCells = numel(stats);
disp(['Number of cells: ', num2str(numCells)]);

%% Create an Output Image with Black Background and White Particles
outputImage = zeros(size(BW_areaFilt));
outputImage(BW_areaFilt) = 255; % Set the detected particles to white (255)
outputImage = uint8(outputImage); % Convert to uint8 type for display
figure(), imshow(outputImage), title('Output Image with Black Background and White Particles');

%% Save the Output Image
imwrite(outputImage, 'output_image_filtered.jpg'); % Save the output image as a file

