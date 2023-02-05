
%% Computer Assisted Retinal Blood Vessel Segmentation Algorithm
%
%
clc;clear all;close all;
% Read Image
I = imread('13_right.jpeg');
figure;
imshow(I);
% Resize image for easier computation 
B = imresize(I, [350 300])
goundTruth = imread('11_dr.tif');
goundTruth = imresize(goundTruth, [181 181]);
goundTruth=im2double(goundTruth);
% Read image
im = im2double(B);
% Convert RGB to Gray via svd
lab = rgb2lab(im);
figure;
imshow(lab);
display(lab);

wlab = reshape(bsxfun(@times,cat(3,1,0,0),lab),[],3);
%figure;
%imshow(wlab);
%display(wlab);
%[C,S,V] = svd(wlab,'econ');
%C = reshape(C,size(lab));
%C = C(:,:,1);
%gray = (C-min(C(:)))./(max(C(:))-min(C(:)));
%figure;
%imshow(gray);
a_tp = wlab';
Z1 = a_tp*wlab;
[ Z1_vec,Z1_val] = eig(Z1);
[k p] = size(wlab); [m n] = size(Z1_vec); [o p] = size(Z1_val);
U = zeros(k,m); % Size of U
for i = 1:m
        U(:,i) = (wlab*Z1_vec(:,n))/sqrt(Z1_val(o,p)); % U in SVD
        o = o-1; p = p-1;
        n = n-1;
end
[o p] = size(Z1_val);
Sigma = sqrt(Z1_val);
Sig= zeros(o,p);
for i=1:p
        Sig(i,i) = Sigma(o-i+1,p-i+1);  % Diagnol matix
end
%V = fliplr(Z1_vec); % r in SVD

U = reshape(U,size(lab));
U = U(:,:,1);
gray = (U-min(U(:)))./(max(U(:))-min(U(:)));
figure;
imshow(gray);
figure;
histogram(gray);
%% Contrast Enhancment of gray image using CLAHE
J = adapthisteq(gray,'numTiles',[8 8],'nBins',128);
figure;
imshow(J);
%% Histogram after CLAHE
figure;
histogram(J);
%% Background Exclusion
% Apply Average Filter
h = fspecial('average', [9 9]);
JF = imfilter(J, h);
figure, 
imshow(JF);

% Take the difference between the gray image and Average Filter
Z = imsubtract(JF, J);
 figure, 
 imshow(Z);

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

%%%%%%%%%%%%%%%%%%%%%%%THE END%%%%%%%%%%%%%%%%%%%%%%%%%%
validation(goundTruth,fuzzyLSM(img,imgfcm,1))





