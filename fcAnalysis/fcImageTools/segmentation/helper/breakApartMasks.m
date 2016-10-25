function [newL,stats,seeds] = breakApartMasks(data,mask,varargin)
%BREAKAPARTMASKS will use mean shift to break apart touching features in a
% mask.

%--parameters--------------------------------------------------------------
params.Nsamples         = 2000;
params.meanShiftSize    = 3;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

stats = regionprops(mask,'PixelIdxList','PixelList','SubarrayIdx','BoundingBox');

% define seeds by mean shift
seeds = zeros(size(data));
needToBreakUp = [];
for ii = 1:numel(stats)
    getCoors = stats(ii).PixelIdxList;
    getValues = data(getCoors);
    % make sure the number of data points is > 1
    if numel(getCoors) > 1
        % subtract background and normalize to 1
        getValues = getValues - min(getValues);
        getValues = getValues/sum(getValues(:));
        sampledCoors = randsample(getCoors,params.Nsamples,true,getValues);
        sampledCoors = ind2subND(size(data),sampledCoors);
        sampledCoors = cell2mat(cellfunNonUniformOutput(@(x) x',sampledCoors));
        [clustcent,~,~] = MeanShiftCluster(sampledCoors,params.meanShiftSize);
        for jj = 1:size(clustcent,2)
            if jj==2
              needToBreakUp(end+1) = ii;
            end
            currClust = clustcent(:,jj);
            currClust = num2cell(round(currClust));
            seeds(currClust{:}) = 1;
        end
    end
end

newL = bwlabeln(mask);
nextMaxId = max(newL(:))+1;
stats = regionprops(newL,'BoundingBox','SubarrayIdx');
% break apart mask by watershed using seeds
for ii = 1:numel(needToBreakUp)
   breakI = needToBreakUp(ii);
   currSeed = getSubsetwBBoxND(seeds,stats(breakI).BoundingBox);
   currMask  = getSubsetwBBoxND(mask,stats(breakI).BoundingBox);
   currData = getSubsetwBBoxND(data,stats(breakI).BoundingBox);
   Ld = doWaterShedSplitting(currData,currSeed,currMask);
   Ld = -double(Ld);
   splitIds = unique(Ld(Ld<0));
   % give the first split to the current id
   Ld(Ld==-1) = breakI;
   for jj = 2:numel(splitIds)
       Ld(Ld==-jj) = nextMaxId;
       nextMaxId = nextMaxId + 1;
   end
   newL(stats(breakI).SubarrayIdx{:}) = Ld;
end


stats = regionprops(newL,'PixelIdxList','PixelList','SubarrayIdx','BoundingBox');