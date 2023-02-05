function runtest(opt)
% %%%%% Image Segmentation Using Spatial Kernel Fuzzy C-Means Clustering on 
%%%%%%%%%%%%%Level Set Method %%%%%%%%%%
%%%%%%%%%%%%%Professor G.Raghotham Reddy, Dept.of ECE, KITSW%%%%%
%--------------------------------------------------------------------------
clc;
clear all;
close all;
%%%%%%%%%%%%%%Read Input Image%%%%%%%%%%%%%%
[f,p]=uigetfile('.jpg');
I=imread(strcat(p,f));

if size(I,3)>1
    img=rgb2gray(I);
end
%%%%%%%%%%%%%%%No.of cluster%%%
ncluster=5;
%%%%%%%%%Spatial FCM clustering algorithm%%%%%%
MF = SFCM2D(img,ncluster);

figure
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

close(gcf);

imgfcm=reshape(MF(nopt,:,:),size(img,1),size(img,2));

fuzzyLSM(img,imgfcm,1);