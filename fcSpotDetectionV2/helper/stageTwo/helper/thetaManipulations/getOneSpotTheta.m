function [ oneSpotTheta ] = getOneSpotTheta( structThetas )
%GETONESPOTTHETA will return the theta that contains 1 spot given a struct
%array of thetas
numSpots = zeros(numel(structThetas),1);
for ii = 1:numel(structThetas)
    currStruct = structThetas(ii);
    currNumSpots =  getSpotCoorsFromTheta(currStruct.thetaMLEs);
    if isempty(currNumSpots)
        numSpots(ii) = 0;
    else
        numSpots(ii) = numel(currNumSpots);
    end
end
idx = numSpots == 1;
if any(idx)
    oneSpotTheta = structThetas(idx);
else
    oneSpotTheta = [];
end
end

