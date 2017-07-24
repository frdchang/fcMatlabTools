function [L,stats,CC ] = segBrightZStack(brightZstack,varargin )
%SEGBRIGHTZSTACK Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.edgeProfileZ     = [];
params.minArea          = 200;
params.clearBorder      = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if isempty(params.edgeProfileZ)
    [x,y] = getline_zoom(maxintensityproj(brightZstack,3));
    % average all the points to get one edgeProfile
    edgeProfileZ = zeros(numel(x),size(brightZstack,3));
    for i = 1:numel(x)
        currProfile = brightZstack(round(y(i)),round(x(i)),:);
        edgeProfileZ(i,:) = currProfile(:);
    end
    params.edgeProfileZ = mean(edgeProfileZ);
    display(['''edgeProfileZ'', ' mat2str(params.edgeProfileZ)]);
end

qpm = genQPM(brightZstack,params);

foregroundMask = genMaskWOtsu(qpm);
foregroundMask = bwareaopen(foregroundMask,200);


edgeMask       = genEdgeMapFromZ(brightZstack,params.edgeProfileZ);

cells          = -edgeMask;
cells          = genMaskWOtsu(cells);
if params.clearBorder
   cells       = clearXYBorder(cells); 
end

cells          = imreconstruct(foregroundMask,cells,4);
cells          = imfill(cells,'holes');

CC      = bwconncomp(cells,4);
stats   = regionprops(CC);
L       = labelmatrix(CC);

end


