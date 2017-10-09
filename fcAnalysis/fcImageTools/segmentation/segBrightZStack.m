function [L,stats,CC ] = segBrightZStack(brightZstack,qpm,varargin)
%SEGBRIGHTZSTACK Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.edgeProfileZ     = [];
params.minArea          = 200;
params.clearBorder      = true;
params.breakApart       = true; 
     params.ballR       = 5;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if isempty(params.edgeProfileZ)
    params.edgeProfileZ = getEdgeProfileZ( brightZstack );
    plot(params.edgeProfileZ);drawnow;
end

foregroundMask = genMaskWOtsu(qpm);
foregroundMask = bwareaopen(foregroundMask,params.minArea);

edgeMask       = genEdgeMapFromZ(brightZstack,params.edgeProfileZ);

cells          = -edgeMask;
cells          = genMaskWOtsu(cells);

if params.clearBorder
    cells       = clearXYBorder(cells);
end

cells          = imreconstruct(foregroundMask,cells,4);
cells          = imfill(cells,'holes');
cells          = bwareaopen(cells,params.minArea);
if params.breakApart
   seeds = imerode(cells,strel('disk',params.ballR,4));
   seeds = bwareaopen(seeds,params.minArea);
   segmented = doWaterShedSeg(qpm,seeds,cells);
   cells = segmented.L;
end



CC      = bwconncomp(cells,4);
stats   = regionprops(CC);
L       = labelmatrix(CC);

end


