function [cameraNoiseData,sampleSpot] = genDataGivenAB(A,B,varargin)
%GENDATAGIVENAB Summary of this function goes here
%   Detailed explanation goes here

%--parameters--------------------------------------------------------------
params.readNoiseData = 1.6;
params.gain          = 2.1;     % ADU/electrons
params.offset        = 100;     % ADU units
params.QE            = 0.7;
params.threshPSF     = 0.0015;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% here is a single spot with parameters {xp,yp,zp,amp}, 
spotParamStruct1.xp       = 0.45657e-6;          % (units m in specimen plane)
spotParamStruct1.yp       = 0.12246e-6;          % (units m in specimen plane)
spotParamStruct1.zp       = 0.113245e-6;         % (units m in specimen plane)
spotParamStruct1.amp      = A;                   % (number of electrons at peak)
spotList                  = {spotParamStruct1};


spotBasket = cell(numel(B),1); 
spotBackgrounds = cell(numel(B),1);
spotAmps        = cell(numel(B),1);
readNoiseExpansion = cell(numel(B),1);
for ii = 1:numel(B)
spotBasket{ii}                = genSyntheticSpots(...
    'useCase',2,'bkgndVal',B(ii),'spotList',spotList,params);
spotBackgrounds{ii} = spotBasket{ii}.synBak;
spotAmps{ii} = spotBasket{ii}.synAmp;
readNoiseExpansion{ii} = params.readNoiseData;
end
kernel = spotBasket{1}.kernel;
kernel = kernel / sum(kernel(:));
kernel = threshPSF(kernel,params.threshPSF);
kernel = kernel / sum(kernel(:));

bkgnds = catenateCellofDatas(spotBackgrounds);
spots = catenateCellofDatas(spotAmps);
ogSize = size(bkgnds);
bkgnds = padarray(bkgnds,size(kernel),'replicate');

bkgnds = convn(bkgnds,kernel);
bkgnds = unpadarray(bkgnds,ogSize);

if ~isscalar(params.readNoiseData)
   params.readNoiseData = catenateCellofDatas(readNoiseExpansion); 
end
groundTruthData = spots + bkgnds;
cameraNoiseData = genMicroscopeNoise(groundTruthData,params);


sampleSpot = spotBasket;

