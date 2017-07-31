function [ spotKymos ] = buildKymoSpots(fluorKymos,spotParamsPaths)
%BUILDKYMOSPOTS generats Kymos with the nearest pixels loaded with its
%LLRatio.  


if isempty(spotParamsPaths)
   spotKymos = [];
   return;
end

numSeq = numel(spotParamsPaths);

spotKymos = ncellfun(@(x) zeros(size(x)),fluorKymos);

for ii = 1:numSeq
    if ~isempty(spotParamsPaths{ii})
        % for each spot
        for jj = 1:numel(spotParamsPaths{ii})
            currSpot = spotParamsPaths{ii}{jj};
            currMLESingleSpot = currSpot(2).thetaMLEs;
            singleSpotTheta =  getSpotCoorsFromTheta(currMLESingleSpot);
            
        end
    end
end


end

