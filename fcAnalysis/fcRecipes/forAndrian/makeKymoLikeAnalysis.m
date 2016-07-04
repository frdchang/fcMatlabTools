function output = makeKymoLikeAnalysis(vipp1Cell,autoCell,windowSize)
%MAKEKYMOLIKEANALYSIS Summary of this function goes here
%   Detailed explanation goes here


% find important peaks in LLRatio data (parameters for peakfinder are
% embedded in findPeaksInData()
[peaksInData,peakMagInData] = findPeaksInData(vipp1Cell);
% center aligned the data to the found peaks
vipp1Aligned = doAlignment(vipp1Cell,peaksInData);
autoAligned = doAlignment(autoCell,peaksInData);
% montage the center alignment without the data cropped 
vipp1Montaged = montageAlignment(vipp1Aligned);
autoMontaged = montageAlignment(autoAligned);
% now center crop the data to the smallest line segment
vipp1Cropped = cropDataToSmallest(vipp1Aligned,windowSize);
autoCropped  = cropDataToSmallest(autoAligned,windowSize);
% make montage of cropped
vipp1CroppedMontaged = montageAlignment(vipp1Cropped);
autoCropedMontaged   = montageAlignment(autoCropped);
% expand montage to include flipped version
% vipp1CroppedWithFlipped = createTransposed(vipp1Cropped);
% autoCroppedWithFlipped = createTransposed(autoCropped);
% do heirarchical clustering so it is easier to see patterns
optimalIndices = heirarchicalClustering(autoCropped);

output.vipp1AlignedCropped = vipp1Cropped(optimalIndices);
output.autoAlignedCropped = autoCropped(optimalIndices);
output.vipp1Aligned = vipp1Aligned(optimalIndices);
output.autoAligned = autoAligned(optimalIndices);

end

