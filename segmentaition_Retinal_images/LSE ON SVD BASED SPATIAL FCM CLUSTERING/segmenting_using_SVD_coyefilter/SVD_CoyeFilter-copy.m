
%% Computer Assisted Retinal Blood Vessel Segmentation Algorithm
% Developed and Copyrighted by Tyler L. Coye (2015)
%
clc;clear all;close all;
% Read Image
%I = imread('13_right_training.jpeg');
I = imread('13_right.jpeg');
figure;
imshow(I);
% Resize image for easier computation 
B = imresize(I, [350 300])

%goundTruth = imread('test2.jpeg');

%goundTruth = imresize(goundTruth, [350 300]);
goundTruth = imread('13_right_test.jpeg');
goundTruth = imresize(goundTruth, [350 350]);
goundTruth=im2double(goundTruth);
% Read image
im = im2double(B);
% Convert RGB to Gray via PCA
lab = rgb2lab(im);
figure;
imshow(lab);
f = 0;
wlab = reshape(bsxfun(@times,cat(3,1-f,f/2,f/2),lab),[],3);
figure;
imshow(wlab);
[C,S,V] = svd(wlab,'econ');
C = reshape(C,size(lab));
C = C(:,:,1);
gray = (C-min(C(:)))./(max(C(:))-min(C(:)));
%% Contrast Enhancment of gray image using CLAHE
J = adapthisteq(gray,'numTiles',[8 8],'nBins',128);












