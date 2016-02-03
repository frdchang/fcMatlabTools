function syntheticSpots = genSyntheticSpots(varargin)
%GENSYNTHETICSPOTS generates a synthetic fluorescent spot dataset.  This
% function outputs simulated spot data and also the spot parameters
% spotParamsBasket = {spotParamStruct1,spotParamStruct2,...}
%   *param cascade  -> genMicroscopeNoise
%                   -> genPSF

%--data set parameters-----------------------------------------------------
params.dz           = 0.25e-6;
params.zSteps       = 25;
params.z0           = -1e-6;
% FOV in pixels
params.ru           = 10;
% camera pixel size
params.pixelSize    = 6.5e-06;
% magnficiation
params.M            = 60;
%--spot parameters---------------------------------------------------------
params.bkgndVal     = 10;
% useCase = 1 is to generate random spots
% useCase = 2 is to use user defined spots
params.useCase         = 1;
% if you want to generate random spots
params.meanInt         = 50;
params.stdInt          = 10;
params.numSpots        = 10;
% if you want to use user defined spots
spotParamStruct1.xp   = 0e-6;  %(units m in specimen plane)
spotParamStruct1.yp   = 0e-6;  %(units m in specimen plane)
spotParamStruct1.zp   = 1e-6;  %(units m in specimen plane)
spotParamStruct1.amp  = 50;    %(number of electrons at peak)
%spotParamStruct1.bak  = (will be assigned params.bkgndVal)
% spotList = {spotParamStruct1,spotParamStruct2,...};
params.spotList        = {spotParamStruct1};
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

dataSetSize = [params.ru*2-1,params.ru*2-1,params.zSteps];
specimenPixSize = params.pixelSize / params.M;

% generate spotList
switch params.useCase
    case 1
        % generate spotList of random spots uniformly in dataSetSize
        spotCoors = bsxfun(@minus,rand(3,params.numSpots),[0.5;0.5;0]);
        spotCoors = bsxfun(@times,spotCoors, dataSetSize');
        spotInts  = randn(params.numSpots)*params.stdInt + params.meanInt;
        params.spotList = cell(params.numSpots,1);
        for i = 1:params.numSpots
            spotParamStruct.xp        = spotCoors(1,i)*specimenPixSize;
            spotParamStruct.yp        = spotCoors(2,i)*specimenPixSize;
            spotParamStruct.zp        = spotCoors(3,i)*params.dz + params.z0;
            spotParamStruct.amp       = spotInts(i);
            spotParamStruct.bak       = params.bkgndVal;
            params.spotList{i}        = spotParamStruct;
        end
    case 2
        % generate spots given spotList
        % don't really need to do anything since spotList is given
    otherwise
        error('useCase needs to be 1 or 2');
end

% generate spot dataset given spotList
syntheticSpots = zeros(dataSetSize);
for i = 1:numel(params.spotList)
    genPSFParams.xp        = params.spotList{i}.xp;
    genPSFParams.yp        = params.spotList{i}.yp;
    genPSFParams.zp        = params.spotList{i}.zp;
    % check if {x,y,z} are bounded by dataset
    syntheticSpots = syntheticSpots + params.spotList{i}.amp*genPSF(updateParams(params,genPSFParams));
end
syntheticSpots = syntheticSpots + params.bkgndVal;

% simulate microscope dataset
syntheticSpots = genMicroscopeNoise(syntheticSpots,params);




end

