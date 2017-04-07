function [MLEs] = findSpotsStage2V2(datas,cameraVariances,estimated,candidates,kMatrix)
%FINDSPOTSSTAGE2V2 will take each candidate and do iterative fitting

%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


ids = unique(candidates.L(:));
ids(~isNaturalNum(ids)) = [];

for ii = 1:numel(ids)
    
    MLEs = doMultiEmitterFitting();
end

