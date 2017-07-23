function spotParam = BBoxCorrectSpotParams(spotParam,BBox)
%BBOXCORRECTSPOTPARAMS will map the thetaMLE of spot param into BBox
%coorindates

numDimBBox = numel(BBox)/2;
numSpots   = numel(spotParam);
for ii = 1:numSpots
   spotParam(ii).BBox = BBox;
   tempThetaMLE = cell2mat(spotParam(ii).thetaMLE);
   correctionFactor = zeros(size(tempThetaMLE));
   correctionFactor(1:numDimBBox) = BBox(1:numDimBBox)-1;
   tempThetaMLE = tempThetaMLE - correctionFactor;
   spotParam(ii).thetaMLE = num2cell(tempThetaMLE);
end


end

