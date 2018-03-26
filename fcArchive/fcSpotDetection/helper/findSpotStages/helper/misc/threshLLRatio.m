function threshedSpots = threshLLRatio(spotParams,LLRatioThresh)
%THRESHLLRATIO will threshold spotParams struct by LLRatioThresh

if isempty(spotParams)
   threshedSpots = [];
   return;
end
LLRatios = [spotParams.LLRatio];
permissive = LLRatios > LLRatioThresh;
threshedSpots = spotParams(permissive);

end

