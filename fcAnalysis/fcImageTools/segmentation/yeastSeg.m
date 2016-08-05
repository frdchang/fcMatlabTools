function [ output_args ] = yeastSeg(timeLapseFiles)
%YEASTSEG Summary of this function goes here
%   Detailed explanation goes here

% load last timepoint and segment it to seed the segmentation
lastFrame = timeLapseFiles{end};
lastFrame = importStack(lastFrame);
seeds = genSeedsFromDomes(lastFrame);
% hmm.. graph cut threshold is strange.
%
thresh = multithresh(lastFrame);
bwMask = lastFrame>thresh;
seeds = seeds.*bwMask;
%          plotOverlay(lastFrame,seeds);
%         global roimask;
%         getROI(lastFrame);
%         reply = input('are these ok? Y/N [Y]: ', 's');
%         if reply == 'N'
%             error('I don''t want to play anymore');
%         end
%         seeds = roimask;
% also think about doing multi label graph cut which will get more
% robust outlines
%         [L,S] = doRandomWalkerSeg(lastFrame,'seeds',seeds,'bwMask',bwMask);
%        imshow(plotLabels(lastFrame,[],L));
[L,S] = doWaterShedSeg(lastFrame,'seeds',seeds,'bwMask',bwMask,doWaterShedSegParams{:});
%         plotOverlay(lastFrame,L);

%         [L,S] = doRandomWalkerSeg(lastFrame,'seeds',seeds,'bwMask',bwMask);
%         [Dxx,Dxy,Dyy] = Hessian2D(double(lastFrame),2);
%         detHessian = Dxx.*Dyy - Dxy.^2;
%         doGraphCutSeg(detHessian,'seeds',seeds,'bwMask',bwMask);
Lcurated = curateSegmentation(L,curateSegmentationParams{:});
Lcurated = bwlabel(Lcurated);
output = doCellTracking(timeLapseFiles,'lastFrameSegmented',Lcurated,doCellTrackingParams{:});
% save output function
end

