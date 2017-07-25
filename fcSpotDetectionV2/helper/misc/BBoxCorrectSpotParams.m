function spotParam = BBoxCorrectSpotParams(spotParam,BBox)
%BBOXCORRECTSPOTPARAMS will map the thetaMLE of spot param into BBox
%coorindates
if isempty(spotParam)
   return; 
end


numSpots   = numel(spotParam);
for ii = 1:numSpots
    for jj = 1:numel(spotParam{ii})
       spotParam{ii}(jj).thetaMLEs  = correctThetaForBBox(spotParam{ii}(jj).thetaMLEs,BBox);
    end
end


end

