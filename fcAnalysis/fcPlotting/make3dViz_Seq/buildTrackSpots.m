function [ spotKymos ] = buildTrackSpots(tracks,fluorKymos,sizeDatas,upRezFactor )
%BUILDTRACKSPOTS Summary of this function goes heres
%   Detailed explanation goes here

% %--parameters--------------------------------------------------------------
% params.default1     = 1;
% %--------------------------------------------------------------------------
% params = updateParams(params,varargin);


if all(cellfun(@isempty,tracks))
    spotKymos = [];
    return;
end

spotKymos = ncellfun(@(x) zeros(size(x)),fluorKymos);

for ii = 1:numSeq
    if ~isempty(spotParamsPaths{ii})
        % for each spot
        numSpots = 0;
        for jj = 1:numel(spotParamsPaths{ii})
            currSpot = spotParamsPaths{ii}{jj};
            selectedSpot = spotSelectorByThresh(currSpot,varargin{:});
            
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
        % index the color by numspots
        spotKymos{kk}{1}(:,ii) = spotKymos{kk}{1}(:,ii)*numSpots;
        spotKymos{kk}{2}(:,ii) = spotKymos{kk}{2}(:,ii)*numSpots;
        spotKymos{kk}{3}(:,ii) = spotKymos{kk}{3}(:,ii)*numSpots;   
    end
end

end

