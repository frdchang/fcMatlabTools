function synSpotStruct = genSyntheticSpots(varargin)
%GENSYNTHETICSPOTS generates a synthetic fluorescent spot dataset.  This
% function outputs simulated spot data and also the spot parameters
% spotParamsBasket = {spotParamStruct1,spotParamStruct2,...}
%   *param cascade  -> genMicroscopeNoise
%                   -> genPSF

%--data set parameters-----------------------------------------------------
params.dataSetSize  = [19 19 11];
params.dz           = 0.25e-6;

params.z0           = -1e-6;
% FOV in pixels
params.ru           = 10;
% camera pixel size
params.pixelSize    = 6.5e-06;
% magnficiation
params.M            = 60;
% use gibson lanni (realistic) or gaussian psf
params.useRealistic = false;
% if use gaussian psf these are the parameters
params.sigmaxysq      = 0.9;
params.sigmazsq       = 0.9;
%--spot parameters---------------------------------------------------------
params.bkgndVal     = 5;
% useCase = 1 is to generate random spots
% useCase = 2 is to use user defined spots
params.useCase         = 1;
% if you want to generate random spots
params.meanInt         = 10;
params.stdInt          = 0;
params.numSpots        = 10;
% if you want to use user defined spots
spotParamStruct1.xp   = 0e-6;  %(units m in specimen plane)
spotParamStruct1.yp   = 0e-6;  %(units m in specimen plane)
spotParamStruct1.zp   = 0e-6;  %(units m in specimen plane)
spotParamStruct1.amp  = 7;    %(number of electrons at peak)
%spotParamStruct1.bak  = (will be assigned params.bkgndVal)
% spotList = {spotParamStruct1,spotParamStruct2,...};
params.spotList        = {spotParamStruct1};
params.simMicroscope   = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);
params.zSteps       = params.dataSetSize(3);
% make sure dataset fov is odd and symetric
if params.dataSetSize(1) ~= params.dataSetSize(2) || mod(params.dataSetSize(1),2)==0
   error('make sure the fov is symmetric and odd'); 
end
params.ru           = (params.dataSetSize(1)+1)/2;
dataSetSize = params.dataSetSize;
specimenPixSize = params.pixelSize / params.M;

% generate spotList
switch params.useCase
    case 1
        % generate spotList of random spots uniformly in dataSetSize
        sampleUniformDist = rand(3,params.numSpots);
        % shift it so x and y samples centered at zero
        spotCoors = bsxfun(@minus,sampleUniformDist,[0.5;0.5;0]);
        % transform so x and y samples from -1 to 1
        spotCoors = bsxfun(@times,spotCoors,[2;2;1]);
        % scale so x and y and z samples the size of the dataset in pixels
        spotCoors = bsxfun(@times,spotCoors, [params.ru-1,params.ru-1,params.zSteps-1]');
        spotInts  = randn(params.numSpots)*params.stdInt + params.meanInt;
        params.spotList = cell(params.numSpots,1);
        for i = 1:params.numSpots
            % in units of the specimen plane (m)
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

% generate pixel unit coordinates
for i = 1:numel(params.spotList)
    params.spotList{i}.xPixel = ((dataSetSize(1) )/(dataSetSize(1)*specimenPixSize))*(params.spotList{i}.xp - (-params.ru+1)*specimenPixSize) + 1;
    params.spotList{i}.yPixel = ((dataSetSize(2) )/(dataSetSize(2)*specimenPixSize))*(params.spotList{i}.yp - (-params.ru+1)*specimenPixSize) + 1;
    params.spotList{i}.zPixel = (params.spotList{i}.zp - params.z0) / params.dz + 1;
    params.spotList{i}.bak    = params.bkgndVal;
end

% generate spot dataset given spotList
syntheticSpots = zeros(dataSetSize);
for i = 1:numel(params.spotList)
    genPSFParams.xp        = params.spotList{i}.xp;
    genPSFParams.yp        = params.spotList{i}.yp;
    genPSFParams.zp        = params.spotList{i}.zp;
    % check if {x,y,z} are bounded by dataset
    if params.useRealistic
        syntheticSpots = syntheticSpots + params.spotList{i}.amp*genPSF(updateParams(params,genPSFParams));
    else
        gaussPSF = ndGauss(sqrt([params.sigmaxysq,params.sigmaxysq,params.sigmazsq]), dataSetSize,[params.spotList{i}.xPixel,params.spotList{i}.yPixel,params.spotList{i}.zPixel]-ceil(dataSetSize/2));
        gaussPSF = gaussPSF / max(gaussPSF(:));
        syntheticSpots = syntheticSpots + params.spotList{i}.amp*gaussPSF;
        params.spotList{i}.sigmaxy = sqrt(params.sigmaxysq);
        params.spotList{i}.sigmaz  = sqrt(params.sigmazsq);
    end
end



% add background signal
synSpotStruct.synAmp = syntheticSpots;
syntheticSpots = syntheticSpots + params.bkgndVal;
synSpotStruct.synBak = params.bkgndVal*ones(size(syntheticSpots)); 
% simulate microscope dataset
if params.simMicroscope
    [syntheticSpots,poissonNoiseOnly] = genMicroscopeNoise(syntheticSpots,params);
end

synSpotStruct.poissonNoiseOnly = poissonNoiseOnly;
synSpotStruct.data = syntheticSpots;
synSpotStruct.synSpotList = params.spotList;



end

