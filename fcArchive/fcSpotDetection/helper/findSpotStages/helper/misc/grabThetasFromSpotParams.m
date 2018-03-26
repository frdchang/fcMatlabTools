function thetaMLEs = grabThetasFromSpotParams(spotParams)
%GRABTHETAS grabs all the thetaMles from spot Params and returns it as a
%matrix
if isempty(spotParams)
   thetaMLE = [];
   return;
end
numSpots = numel(spotParams);
thetaMLEs = [spotParams.thetaMLE];
thetaMLEs = reshape(thetaMLEs,numel(thetaMLEs)/numSpots,numSpots);
thetaMLEs = thetaMLEs';
thetaMLEs = cell2mat(thetaMLEs);
end

