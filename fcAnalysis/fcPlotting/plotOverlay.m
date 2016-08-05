function [] = plotOverlay(varargin)
%PLOTOVERLAY Summary of this function goes here
%   Detailed explanation goes here
if nargin==2
%     figure;
    myIn = varargin{1};
    myOverlay = varargin{2};
    if size(myIn,3) > 1
       myIn = maxintensityproj(myIn,3); 
    end
    if size(myOverlay,3) > 1
       myOverlay = maxintensityproj(myOverlay,3); 
    end
    imtool(imoverlay(norm0to1(myIn),logical(bwperim(myOverlay)),[1,0,0]));
elseif nargin==1
    hold(imgca,'on');
    
else
    
end
end

