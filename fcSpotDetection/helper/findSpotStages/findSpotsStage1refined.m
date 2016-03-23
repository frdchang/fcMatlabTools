function detectedRefined = findSpotsStage1refined(data,spotKern,cameraVariance,detectedFromStage1,gaussSigmas)
%FINDSPOTSTAGE1REFINED will do further refinement of stage 1 MLE of
% {A1,B1,B0,LLRatio} given 1 spot and 0 spot model with full likelihood
% noise model.  
%
% data:             data
% spotKern:         shape of the spot
% cameraVariance:   read noise
% detectFromStage1: output struct from findSpotStage1
% gaussSigams:      [sigmax,sigmay,sigmaz] of spot
%

kernSize = size(spotKern);
fullLLResults = nlfilter3D({data,cameraVariance,detectedFromStage1.A1,detectedFromStage1.B1,detectedFromStage1.B0},kernSize,@calcMLEOfPatch_PoissPoiss,{spotKern,gaussSigmas},-inf);
detectedRefined.A1         = fullLLResults{1};
detectedRefined.B1         = fullLLResults{2};
detectedRefined.B0         = fullLLResults{3};
detectedRefined.LLRatio    = fullLLResults{4};

end

