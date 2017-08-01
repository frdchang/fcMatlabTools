function [ spotKymos ] = buildKymoSpots(fluorKymos,spotParamsPaths,sizeDatas,upRezFactor)
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
            [singleSpotTheta,spotColor] =  getSpotCoorsFromTheta(currMLESingleSpot);
            singleSpotTheta = singleSpotTheta{1};
            currStack   = genSpotIMG(singleSpotTheta,sizeDatas,upRezFactor);
            
            currStackXY = max(currStack,[],3);
            currStackZ  = max(max(currStack,[],1),[],2);
            spotKymos{spotColor}{1}(:,ii) = spotKymos{spotColor}{1}(:,ii)+max(currStackXY,[],2);
            spotKymos{spotColor}{2}(:,ii) = spotKymos{spotColor}{2}(:,ii)+max(currStackXY,[],1);
            spotKymos{spotColor}{3}(:,ii) = spotKymos{spotColor}{3}(:,ii)+currStackZ;
            
            
        end
    end
end


end

