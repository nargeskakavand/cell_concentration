clc; clear; close all;

%% Read the raw image
file_name = 'test_flow.jpg'; % Path to the raw image file
I_org = imread(file_name);
figure(), imshow(I_org), title('Original Image');

%% Check if the image is already grayscale
if size(I_org, 3) == 3
    IG_org = rgb2gray(I_org);
else
    IG_org = I_org;
end
figure(), imshow(IG_org), title('Grayscale Image');

%% Image processing steps
I_BG = median(double(IG_org), 3); % Calculate the background using the median
IG = double(IG_org) - I_BG; % Subtract the background
IG = imadjust(uint8(IG), stretchlim(uint8(IG)), []); % Adjust the contrast
figure(), imshow(IG), title('Processed Gray Scale Image');

%% Tophat filter
ITH = imtophat(IG, strel('disk', 80));
figure(), imshow(ITH), title('Top-hat Filtered Image');

%% Binarize
I_BW = imbinarize(ITH, 'adaptive', 'Sensitivity', 0.4);
figure(), imshow(I_BW), title('Binarized Image');

%% Region Properties
BW_areaFilt = bwpropfilt(I_BW, 'Area', [5 500]); % Adjust area range if needed
BW_extent = bwpropfilt(BW_areaFilt, 'Extent', [0.2 1]); % Adjust extent range if needed
figure(), imshow(BW_extent), title('Filtered Binary Image');

%% Convert the binary image to have white particles on a black background
I_segmented = imcomplement(BW_extent);
figure(), imshow(I_segmented), title('Segmented Image with White Cells on Black Background');

%% Save the segmented image
imwrite(I_segmented, '/mnt/data/segmented_output.jpg');

%% Display the number of particles and concentration
stats = regionprops('table', BW_extent, 'Area', 'Circularity');
count = length(stats.Area);
conc = count / (3.4 * 10^-3);

disp(['Number of particles: ', num2str(count)]);
disp(['Concentration: ', num2str(conc), ' particles per unit volume']);


