function [L,stats,qpm] = cyanoSeg(brightZstack)
%CYANOSEG Summary of this function goes here
%   Detailed explanation goes here
% edgeZProfile = [16962 17033 17319 17392 18426 21676 23678 24500 24320]

brightZstack = double(brightZstack);

[x,y] = getline_zoom(maxintensityproj(brightZstack,3));
% average all the points to get one edgeProfile
edgeProfileZ = zeros(numel(x),size(brightZstack,3));
for i = 1:numel(x);
    currProfile = brightZstack(round(y(i)),round(x(i)),:);
    edgeProfileZ(i,:) = currProfile(:);
end
edgeProfileZ = mean(edgeProfileZ);
figure;plot(edgeProfileZ);
qpm = genQPM(brightZstack,'ballSize',20);

[seeds,foregroundMask] = genSeedsFromDomes(qpm);
edgeMask = genEdgeMapFromZ(brightZstack,edgeProfileZ);
cells = -edgeMask;
threshCells = multithresh(cells(:));
cells = cells > threshCells;
cells =imreconstruct(foregroundMask,cells,4);
cells = imfill(cells,'holes');
CC = bwconncomp(cells,4);
stats = regionprops(CC);
L  = labelmatrix(CC);



