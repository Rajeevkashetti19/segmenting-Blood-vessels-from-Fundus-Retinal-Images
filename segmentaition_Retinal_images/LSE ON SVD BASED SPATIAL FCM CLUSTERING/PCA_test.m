%%  Retinal Blood Vessel Segmentation using PCA PLUS PC Algorithm 
% Developed and Copyrighted by Tyler L. Coye (2015) 
% 
% Read Image 
clc;
clear all;
close all;
I = imread('10_dr.jpg')

% Resize image for easier computation 
B = imresize(I, [300 300])

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

%Generation of image mask
mask = im2bw(im,20/255);
se = strel('diamond',20);
erodedmask = im2uint8(imerode(mask,se));


%Apply gaussian filter to the image where s=1.45
img3= imgaussfilt(im(:,:,2) ,1.45);
figure;
imshow(img3);


%Finding lamda - principal curvature
lamda2=prinCur(img3);
maxprincv = im2uint8(lamda2/max(lamda2(:)));
maxprincvmsk = maxprincv.*(erodedmask/255);

%Contrast enhancement. 
newprI = adapthisteq(maxprincvmsk,'numTiles',[8 8],'nBins',128);

%% Contrast Enhancment of gray image using CLAHE 
J = adapthisteq(gray,'numTiles',[8 8],'nBins',128);

%% Background Exclusion 
% Apply Average Filter

h1 = fspecial('average', [9 9]); 
JF1 = imfilter(newprI, h1); 
figure, imshow(JF1)


h = fspecial('average', [9 9]); 
JF = imfilter(J, h); 
figure, imshow(JF)

% Take the difference between the gray image and Average Filter 
Z1 = imsubtract(JF1, newprI); 
figure, imshow(Z1)

Z = imsubtract(JF, J); 
figure, imshow(Z)


%% Threshold using the IsoData Method 
level1=isodata(Z1) % this is our threshold level
level=isodata(Z)
%% Convert to Binary 
BW1 = im2bw(Z1, level1-.008)
BW = im2bw(Z, level-.008)
%% Remove small pixels 
BW21 = bwareaopen(BW1, 100)
BW2 = bwareaopen(BW, 100)
%% Overlay 
BW21 = imcomplement(BW21) 
out1 = imoverlay(B, BW21, [0 0 0]) 
figure, imshow(out1)

BW2 = imcomplement(BW2) 
out = imoverlay(B, BW2, [0 0 0]) 
figure, imshow(out) 
[m,n]=size(out);
for i=1:m
    for j=1:n
        if out(i,j)<1;
            a(i,j)=0;
        else
            a(i,j)=1;
        end
    end
end
sum(sum(a))