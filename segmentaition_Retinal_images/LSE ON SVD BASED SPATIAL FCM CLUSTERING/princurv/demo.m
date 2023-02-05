 %%%%%%%%%%%%%%Maximum Principal Curvature using LevelSet Method%%%%%%


clc;
 clear all;
 close all;

inputImage = imread('21_training.tif');
goundTruth = imread('21_manual1.gif');
figure;
imshow(inputImage)
segIm = vesselSegPC(inputImage);   

figure;
 imshow(segIm);
%%%%%%%%%%%%%Level Set Implementation%%%%%%%%%%%%
Img=segIm;
[row,col] = size(Img);
phi = ones(row,col);
phi(30:row-156,90:col-196) = -1;
u = - phi;
[c, h] = contour(u, [0 0], 'r');
title('Initial contour');
% hold off;

sigma = 1;
G = fspecial('gaussian', 5, sigma);

delt = 1;
Iter = 180;
mu = 40;%this parameter needs to be tuned according to the images

for n = 1:Iter
    [ux, uy] = gradient(u);
   
    c1 = sum(sum(Img.*(u<0)))/(sum(sum(u<0)));% we use the standard Heaviside function which yields similar results to regularized one.
    c2 = sum(sum(Img.*(u>=0)))/(sum(sum(u>=0)));
    
    spf = Img - (c1 + c2)/2;
    spf = spf/(max(abs(spf(:))));
    
    u = u + delt*(mu*spf.*sqrt(ux.^2 + uy.^2));
    
    if mod(n,10)==0
    imagesc(Img,[0 255]); colormap(gray);hold on;
    [c, h] = contour(u, [0 0], 'r');
    iterNum = [num2str(n), 'iterations'];
    title(iterNum);
    pause(0.02);
    end
    u = (u >= 0) - ( u< 0);% the selective step.
    u = conv2(u, G, 'same');
end
imagesc(Img,[0 255]);colormap(gray);hold on;
title('previous method');
[c, h] = contour(u, [0 0], 'r');
toc;
figure;imshow(u);
[row,col] = size(u);
    phi = ones(row,col); k = 10; 
    phi(k:row-k,k:col-k) = -1;
    obj = - phi; objPos = obj >= 0; objNeg = ~objPos;
    itr = 0; 
    Area1 = sum(objNeg(:)); Area2 =sum(objPos(:));
    tic;
    Img=u;
        while abs(Area2-Area1)>0                                            
            c1 = sum(sum(Img.*objNeg))/sum(sum(objNeg));
            c2 = sum(sum(Img.*objPos))/sum(sum(objPos)); 
            nImg = Img - (c1 + c2)/2;
            obj = nImg /max(abs(nImg(:)));            
            objPos = obj >= 0; 
            objPos=bwareaopen(objPos,20);
            objPos=imclose(objPos,strel('disk',3)); objNeg = ~objPos;            
            obj = objPos - objNeg;            
            Area1= Area2;  Area2 =sum(objPos(:));    
            itr = itr + 1;        
                imshow(u,[]); hold on; 
                contour(obj, [0 0], 'r','LineWidth',1.2);hold on; 
                contour(obj, [0 0], 'r','LineWidth',1.2);hold on; 
                title(['Previous method : ',int2str(itr),'th iteration, the total area of the object:',int2str(abs(Area2))]);axis off; 
                drawnow;
                    end
    time = toc;    
tostore=u;
imwrite(tostore,'C:\Users\R@MJO\Desktop\''proposed levelset.jpg');
[m,n]=size(u);

validation(goundTruth,u)
