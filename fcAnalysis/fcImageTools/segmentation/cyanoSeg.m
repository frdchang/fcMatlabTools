function [L,stats,qpm] = cyanoSeg(brightZstack,edgeProfileZ)
%CYANOSEG Summary of this function goes here
%   Detailed explanation goes here
% edgeZProfile = [16962 17033 17319 17392 18426 21676 23678 24500 24320]

brightZstack = double(brightZstack);
qpm = genQPM(brightZstack);

[seeds,foregroundMask] = genSeedsFromDomes(qpm);
edgeMask = genEdgeMapFromZ(brightZstack,edgeProfileZ);
cells = -edgeMask;
threshCells = multithresh(cells(:));
cells = cells > threshCells;
cells =imreconstruct(foregroundMask,cells);
cells = imfill(cells,'holes');
CC = bwconncomp(cells,4);
stats = regionprops(CC);
L  = labelmatrix(CC);



