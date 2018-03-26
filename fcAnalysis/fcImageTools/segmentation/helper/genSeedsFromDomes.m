function [seeds,otsuSubsetBW] = genSeedsFromDomes(img,varargin)
% GENSEEDSFROMDOMES
% arg1:     arg1 is this
% arg2:     arg2 is that
%
% [notes] - a heads up for the user
%
% [param cascade] -> subFunc1
%                 -> subFunc2

%--parameters--------------------------------------------------------------
params.domeH            = 10;
params.rdisk            = 5;
params.gaussianSigma    = 2;
params.meanShiftSize    = 5;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% generate gaussian for smoothing
gauss = fspecial('gaussian',round(params.gaussianSigma*5),params.gaussianSigma);
gauss = gauss / sum(gauss(:));
gauss = threshPSF(gauss,0.0015);
gauss = gauss / sum(gauss(:));
imgGauss   = imfilter(img,gauss);

% generate otsu subset
threshold = multithresh(imgGauss);
otsuSubsetBW = imgGauss > threshold;

% find hdome transformation on the otsusubset
hdomed = hdome(imgGauss,params.domeH);
hdomed = hdomed.*otsuSubsetBW;

% segment the hdomed
stats = regionprops(hdomed>0);

% break apart touching domes by mean shift
seeds = zeros(size(img));
for ii = 1:numel(stats)
    subDome = getSubsetwBBoxND(hdomed,stats(ii).BoundingBox);
    subDome = subDome / sum(subDome(:));
    if numel(subDome)>1
        sampledDome = representativeSampling(subDome);
        [clustcent,~,~] = MeanShiftCluster(sampledDome,params.meanShiftSize);
        for jj = 1:size(clustcent,2)
            currClust = clustcent(:,jj);
            clustOrig = BBox2OrigCoor(stats(ii).BoundingBox,currClust);
            clustOrig = num2cell(round(clustOrig'));
            seeds(clustOrig{:}) = 1;
        end
    end
end


