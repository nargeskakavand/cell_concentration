clc; clear; 
close all;

%% Crop
[Icropped,Irec] = imcrop(I_org);
figure(), imshow(Icropped);
[Icropped2] = imcrop(I_org,Irec);
figure(), imshow(Icropped2);

%% Read video 3374_B1_T2
file_name = '3374 - B1 - T2.mp4';
vidObj = VideoReader(file_name);
vidframes = read(vidObj,[1 Inf]);
% vidframes_org = zeros(size(vidframes,1), size(vidframes,2), size(vidframes,4));
for i = 1:size(vidframes,4)
    i
    I_org = vidframes(:,:,:,i);
    IG_org = rgb2gray(I_org);
%     imshow((IG_org));
    vidframes_org(:,:,i) = IG_org;
end
I_BG = median((vidframes_org),3);
% figure(), imshow((I_BG));

%% Convert to Gray Scale
% for j = 1:size(vidframes,4)
I_BG = imcomplement(uint8(I_BG));
IG_org = imcomplement(IG_org);
IG = (IG_org-I_BG);
IG = imadjust(IG,stretchlim(IG),[]);
% figure(), imshow(IG);
% figure(), imshow((I_org));

%% tophat filter
ITH = imtophat(IG, strel('disk', 80));
IBH = imbothat(IG, strel('disk', 80));
% figure(), imshow(ITH)
% figure(), imshow(IBH)

%% Binarize
I_BW = imbinarize(IG,0.85);
figure(), imshow(I_BW);

%% regionproperties
BW_areaFilt = bwpropfilt(I_BW,'Area',[100 220]);
BW_extent = bwpropfilt(BW_areaFilt,'Extent',[0.5 0.79]);
figure(), imshow(BW_extent);

stats = regionprops('table',BW_extent,'Area','Circularity');
count = length(stats.Area);
conc(j) = count/(3.4*10^-3);
% end
concmean = mean(conc);

