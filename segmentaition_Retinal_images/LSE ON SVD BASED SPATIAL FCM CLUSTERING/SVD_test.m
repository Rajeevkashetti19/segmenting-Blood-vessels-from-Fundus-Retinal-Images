%% Retinal Blood Vessel Segmentation Algorithm using PCA based Maximum Principal Curvature%%%%%%%
% Developed and Copyrighted by Santosh Kumar, KITSW) 
% 
% Read Image 
%I = imread('21_training.tif')

clc;clear all;close all;
I = imread('21_training.tif');
figure;
imshow(I);
% Resize image for easier computation 
B = imresize(I, [181 181])

goundTruth = imread('21_manual1.gif');
goundTruth = imresize(goundTruth, [181 181]);

% Read image 
im = im2double(B);

% Convert RGB to Gray via PCA 
lab = rgb2lab(im); 
f = 0; 
wlab = reshape(bsxfun(@times,cat(3,1-f,f/2,f/2),lab),[],3); 
[C,S] = pca(wlab); 
S = reshape(S,size(lab)); 
S = S(:,:,1); 
gray = (S-min(S(:)))./(max(S(:))-min(S(:)));

%% Contrast Enhancment of gray image using CLAHE
J = adapthisteq(gray,'numTiles',[8 8],'nBins',128);


%Generation of image mask
mask = im2bw(J,20/255);
se = strel('diamond',20);
erodedmask = im2uint8(imerode(mask,se));

%Finding lamda - principal curvature
lamda2=prinCur(J);
maxprincv = im2uint8(lamda2/max(lamda2(:)));
maxprincvmsk = maxprincv.*(erodedmask/255);

%Contrast enhancement. 
newprI = adapthisteq(maxprincvmsk,'numTiles',[8 8],'nBins',128);
figure;
imshow(newprI);

thresh = isodata(newprI);
vessels = im2bw(newprI,thresh);
figure;
imshow(vessels);

%Filtering out small segments
vessels = bwareaopen(vessels, 200);
figure, imshow(vessels)
segIm = vessels;
%val = imresize(segIm, [210 200])
validation(goundTruth,segIm);





