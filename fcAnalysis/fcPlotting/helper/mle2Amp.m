function [ amps ] = mle2Amp( cellOfMLEs,varargin )
%MLE2CLUSTCENT Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.default = 0;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

numSpots = numel(cellOfMLEs);

amps = [];
for ii = 1:numSpots
   currSpot = cellOfMLEs{ii};
   selected = spotSelectorByThresh(currSpot,varargin{:});
   if isempty(selected)
      continue; 
   end
   singleSpotTheta=  getXYZABFromTheta(selected.thetaMLEs);
   amps(end+1) = singleSpotTheta{1}{1}(4);
end
end

