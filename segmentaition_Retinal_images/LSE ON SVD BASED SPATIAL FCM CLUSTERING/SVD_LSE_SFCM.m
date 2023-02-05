
%% Retinal Blood Vessel Segmentation USING Level set Evolution on SVD based spatial FCM Clustering Algorithm

clc;
clear all;
close all;
% Read Image
I = imread('11_dr.jpg');
%I = imread('21_training.tif');
figure;
imshow(I);
% Resize image for easier computation 
B = imresize(I, [181 181]);

%goundTruth = imread('21_manual1.gif');

%goundTruth = imresize(goundTruth, [350 300]);
goundTruth = imread('11_dr.tif');
goundTruth = imresize(goundTruth, [181 181]);
goundTruth=im2double(goundTruth);
% Read image
im = im2double(B);
% Convert RGB to Gray via SVD
lab = rgb2lab(im);
f = 0;
wlab = reshape(bsxfun(@times,cat(3,1-f,f/2,f/2),lab),[],3);
[C,S,V] = svd(wlab,'econ');
C = reshape(C,size(lab));
C = C(:,:,1);
gray = (C-min(C(:)))./(max(C(:))-min(C(:)));

%% Contrast Enhancment of gray image using CLAHE
J = adapthisteq(gray,'numTiles',[8 8],'nBins',128);
%% Background Exclusion
% Apply Average Filter
h = fspecial('average', [9 9]);
JF = imfilter(J, h);
figure, imshow(JF)
% Take the difference between the gray image and Average Filter
Z = imsubtract(JF, J);
figure, imshow(Z)

%%%%%%%%%%%%%%%No.of cluster%%%
ncluster=5;
%%%%%%%%%Spatial FCM clustering algorithm%%%%%%
img=Z;
MF = SFCM2D(img,ncluster);

figure;
subplot(231); imshow(img,[])
for i=1:ncluster
    imgfi=reshape(MF(i,:,:),size(img,1),size(img,2));
    subplot(2,3,i+1); imshow(imgfi,[])
    title(['Index No: ' int2str(i)])
end

temp=1;
while temp
    nopt = input('Input the Index No that you are interested\n');
    if ~isempty(nopt), temp=0; end
end

figure;
imgfcm=reshape(MF(nopt,:,:),size(img,1),size(img,2));
%%%%%%%%%%%%Level Set Evolution on SVD Based Spatial FCM Clustering%%%%%%
fuzzyLSM(img,imgfcm,1);

%%%%%%%%%%%%%%%%%%%%%%%THE END%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%












