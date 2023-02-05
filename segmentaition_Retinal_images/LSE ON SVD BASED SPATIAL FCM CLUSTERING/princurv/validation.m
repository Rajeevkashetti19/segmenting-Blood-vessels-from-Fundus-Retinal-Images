function []= validation(manual,image)
%This function perform validation of vessel segmentation
%manual : Image considered as ground truth.
%Ground truth image is taken from drive data base.
%image : Segmented image output

image=im2uint8(image);

%TP - True Positives 
%True positive - Anypixel marked as vessel in both ground truth and
%segemented image

%FP - False positive : Anypixel Market as a vessel pixel in segmented image
%which is marked as background pixel in ground truth

%TN - True Negative : Anypixel marked as backgrounf in both ground truth
%and segmented image

TP=0;
TN=0;
FP=0;


vGT = 0;      
bGT = 0;

[row,col]= size(manual);

for r=1:row
    for c = 1:col
        if manual(r,c)==255
            vGT=vGT+1;
            if image(r,c)==255
                TP=TP+1;
            end

        else
            bGT=bGT+1;
            if image(r,c)==0
                TN=TN+1;
            else
                FP=FP+1;
            end

        end
    end
end
%%



TPR = TP/vGT; %vGT : Number of vessel pixels - Ground truth
FPR = FP/bGT; %vGT : Number of non-vessel pixels - Ground truth


AC= (TP+TN)/(row*col);%Accuracy = (True negative+ True Positive)/all pixels


model = {'Principal curvature'};
A = table(model,TPR,FPR,AC)

