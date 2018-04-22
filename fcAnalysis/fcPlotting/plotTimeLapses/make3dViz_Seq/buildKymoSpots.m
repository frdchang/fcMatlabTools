function [ spotKymos ] = buildKymoSpots(fluorKymos,spotParamsPaths,sizeDatas,upRezFactor,varargin)
%BUILDKYMOSPOTS generats Kymos with the nearest pixels loaded with its
%LLRatio.

% %--parameters--------------------------------------------------------------
% params.default1     = 1;
% %--------------------------------------------------------------------------
% params = updateParams(params,varargin);


if isempty(spotParamsPaths)
    spotKymos = [];
    return;
end

numSeq = numel(spotParamsPaths);

spotKymos = ncellfun(@(x) zeros(size(x)),fluorKymos);

for ii = 1:numSeq
    if ~isempty(spotParamsPaths{ii})
        % for each spot
        numSpots = 0;
        for jj = 1:numel(spotParamsPaths{ii})
            currSpot = spotParamsPaths{ii}{jj};
            selectedSpot = spotSelectorByThresh(currSpot,varargin{:});
            if isempty(selectedSpot)
                continue;
            end
            selectedMLESingleSpot = selectedSpot.thetaMLEs;
            
            [~,singleSpotTheta,~] =  getSpotCoorsFromTheta(selectedMLESingleSpot);
            numSpots = numSpots + sum(~cellfun(@isempty,singleSpotTheta));
            currStacks   = cellfunNonUniformOutput(@(x) genSpotIMG(x,sizeDatas,upRezFactor),singleSpotTheta);
            for kk = 1:numel(currStacks)
                currStackXY = max(currStacks{kk},[],3);
                currStackZ  = max(max(currStacks{kk},[],1),[],2);
                spotKymos{kk}{1}(:,ii) = spotKymos{kk}{1}(:,ii)+max(currStackXY,[],2);
                spotKymos{kk}{2}(:,ii) = spotKymos{kk}{2}(:,ii)+max(currStackXY,[],1)';
                spotKymos{kk}{3}(:,ii) = spotKymos{kk}{3}(:,ii)+currStackZ(:);
            end
        end
%         for kk = 1:numel(currStacks)
%             % index the color by numspots
%             spotKymos{kk}{1}(:,ii) = spotKymos{kk}{1}(:,ii)*numSpots;
%             spotKymos{kk}{2}(:,ii) = spotKymos{kk}{2}(:,ii)*numSpots;
%             spotKymos{kk}{3}(:,ii) = spotKymos{kk}{3}(:,ii)*numSpots;
%         end

    end
end


end

