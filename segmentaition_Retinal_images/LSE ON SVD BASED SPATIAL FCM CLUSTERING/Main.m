
%% Retinal Blood Vessels Segmentation using SVD BASED MAXIMUM PRINCIPAL CURVATURES level sets
% Developed and Copyrighted by N C SANTOSH KUMAR , RESEARCH SCHOLAR, GITAM UNIVERSITY, VISHAKAPATNAM (2019)
% DATED 04.11.2019 FINAL CODE VERIFICATION %%%%%%%%%%%%%%%%%%
clc;
clear all;
close all;
% Read Image
[f,p]=uigetfile('.jpg');
I=imread(strcat(p,f));
%I = imread('10_dr.jpg');
figure(1);
imshow(I);
% Resize image for easier computation 
B = imresize(I, [300 300]);

% goundTruth = imread('10_dr.tif');
% goundTruth = imresize(goundTruth, [300 300]);
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
figure(2);
imshow(newprI);
%% Background Exclusion
% Apply Average Filter
h = fspecial('average', [9 9]);
JF = imfilter(newprI, h);
figure(3), imshow(JF)
% Take the difference between the gray image and Average Filter
Z = imsubtract(JF, newprI);
figure(4), imshow(Z)
% %%%%%%apply thresholding%%%%%%
% thresh = isodata(Z);
% vessels = im2bw(Z,thresh-.008);
% figure(5);
% imshow(vessels);

% %Filtering out small segments
% vessels = bwareaopen(vessels, 100);
% figure(6), imshow(vessels)
% segIm = vessels;
% %val = imresize(segIm, [210 200])
% validation(goundTruth,segIm);
% %%%%%%%%%Calculate the no.pixels covered in segmented Image%%%%%%%%%%%%%
% [m,n]=size(segIm);
% for i=1:m
%     for j=1:n
%         if segIm(i,j)<1;
%             a(i,j)=0;
%         else
%             a(i,j)=1;
%         end
%     end
% end
% sum(sum(a))
% %%%%%%%%5calculate area of the binary Image%%%%%%
% area=bwarea(segIm);
% %Find the perimeters of objects in the image.
% 
% BW3 = bwperim(segIm);
% %Display the original image and the image showing perimeters side-by-side.
% 
% % imshowpair(segIm,BW3,'montage')
tic;
% numberOfPixels = numel(segIm);
% numberOfTruePixels = sum(segIm(:));
Img=Z;
% k=imread(strcat(p,f));
% Img=imresize(k,[256 256]);
% Img = Img(:,:,1);
Img = double(Img);
% Img = 200*ones(100);
% Img(20:80,10:30)= 140;
% Img(20:80,40:70)= 180;
% Img(20:80,80:90)=50;
[row,col] = size(Img);
phi = ones(row,col);
phi(100:row-100,100:col-110) = -1;
u = - phi;
[c, h] = contour(u, [0 0], 'r');
title('Initial contour');
% hold off;

sigma = 1;
G = fspecial('gaussian', 5, sigma);

delt = 1;
Iter = 250;
mu = 70;%this parameter needs to be tuned according to the images

for n = 1:Iter
    [ux, uy] = gradient(u);
   
    c1 = sum(sum(Img.*(u<0)))/(sum(sum(u<0)));% we use the standard Heaviside function which yields similar results to regularized one.
    c2 = sum(sum(Img.*(u>=0)))/(sum(sum(u>=0)));
    
    spf = Img - (c1 + c2)/2;
    spf = spf/(max(abs(spf(:))));
    
    u = u + delt*(mu*spf.*sqrt(ux.^2 + uy.^2));
    
    if mod(n,10)==0
    imagesc(Img,[0 255]); colormap; hold on;
    [c, h] = contour(u, [0 0], 'g','linewidth', 1.5);
    iterNum = [num2str(n), 'iterations'];
    title(iterNum);
    pause(0.02);
    end
    u = (u >= 0) - ( u< 0);% the selective step.
    u = conv2(u, G, 'same');
end
imagesc(Img);colormap; hold on;
title('SVD BASED MPC using Level Set ');
[c, h] = contour(u, [0 0], 'g','linewidth', 1.25);
toc;
figure;imshow(u);
[m,n]=size(u);
for i=1:m
    for j=1:n
        if u(i,j)<0;
            a(i,j)=1;
        else
            a(i,j)=0;
        end
    end
end
sum(sum(a))

numberOfPixels = numel(Z);
% numberOfTruePixels = (90000)-numberOfPixels;

area=bwarea(u<0);

% areag=bwarea(goundTruth);

