clc;
clear all;
close all;
[Img map]=imread('layers.jpg');
im2=rgb2gray(Img);
figure(1),imshow(im2),title('2.a. Original Image');
Im=imresize(Img, [256 256]);
Img=imresize(Img, [256 256]);
img2=Img(:,:,1);
figure
imagesc(img2);
% %% Image Initialising
% Img = imread('layers.jpg');
% figure;
% imshow(Img);
%% PSO
Iout = psoseg(img2,2,'dpso');
figure;
imshow(Iout);
Img = Iout(:,:,1);
Img = double(Img);
% Img = 200*ones(100);
% Img(20:80,10:30)= 140;
% Img(20:80,40:70)= 180;
% Img(20:80,80:90)=50;
%% Active Counters using Levelset approach
tic;
[row,col] =size(Img);
phi = ones(row,col);
phi(60:row-100,60:col-100) = -1;
u = - phi;
[c, h] = contour(u, [0 0], 'r','linewidth',2);
title('Initial contour');
% hold off;
%% Filter

sigma = 1;
G = fspecial('gaussian', 5, sigma);

delt = 1;
Iter = 100;
mu = 25;%this parameter needs to be tuned according to the images

%% Itterations

for n = 1:Iter
    [ux, uy] = gradient(u);
   
    c1 = sum(sum(Img.*(u<0)))/(sum(sum(u<0)));% we use the standard Heaviside function which yields similar results to regularized one.
    c2 = sum(sum(Img.*(u>=0)))/(sum(sum(u>=0)));
    
    spf = Img - (c1 + c2)/2;
    spf = spf/(max(abs(spf(:))));
    
    u = u + delt*(mu*spf.*sqrt(ux.^2 + uy.^2));
    
    if mod(n,10)==0
    imagesc(Img,[0 255]); colormap(gray);hold on;
    [c, h] = contour(u, [0 0], 'r','linewidth',2);
    iterNum = [num2str(n), 'iterations'];
    title(iterNum);
    pause(0.02);
    end
    u = (u >= 0) - ( u< 0);% the selective step.
    u = conv2(u, G, 'same');
end
% imagesc(Img,[0 255]);colormap(gray);hold on;
% [c, h] = contour(u, [0 0], 'r');
toc;
figure;
imagesc(Img);colormap(gray);hold on;
title('Proposed levelset Method');
[c, h] = contour(u, [0 0], 'r','linewidth',2);
figure;imshow(u);
 [m,n]=size(u);
for i=1:m
    for j=1:n
        if u(i,j)>0;
            a(i,j)=1;
        else
            a(i,j)=0;
        end
    end
end
sum(sum(a))


    
