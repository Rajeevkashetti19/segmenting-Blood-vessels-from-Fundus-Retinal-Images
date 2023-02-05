clc;
clear all;
close all;
% Read Image
[f,p]=uigetfile('.jpg');
inputImage=imread(strcat(p,f));
% inputImage = imread('10_dr.jpg');
inputImage = imresize(inputImage,[300 300]);
% goundTruth = imread('10_dr.tif');
% goundTruth = imresize(goundTruth,[300 300]);
figure;
imshow(inputImage);
inputImage=rgb2gray(inputImage);
% %% Image Initialising
% Img = imread('5.jpg');
% imshow(Img);figure;
%%%%%%%%%%%%%%%%%%%%MPC%%%%%%%%%%%%%%%%
segIm = vesselSegPC(inputImage);   
figure;
imshow(segIm);
% validation(goundTruth,segIm)
[m,n]=size(segIm);
for i=1:m
    for j=1:n
        if segIm(i,j)<1;
            a(i,j)=0;
        else
            a(i,j)=1;
        end
    end
end
sum(sum(a))
