function [ estimated ] = gammaCorrection( data,spotKern,cameraVariance,varargin )
%GAMMACORRECTION appens the gamma pdf correction.  only applies to single
%channel data
if iscell(data)
   data = data{1};
   spotKern = spotKern{1};
end
[estimated] = findSpotsStage1V2(data,spotKern,cameraVariance,varargin{:});

gammaA = 0.5;
gammaB = @(b) 2.6*b + 2.1;

gamsig = arrayfun(@(llr,b) 1-gamcdf(llr,gammaA,gammaB(b)),estimated.LLRatio,estimated.B1);
estimated.gammaSig = gamsig;
estimated.gammaSig2 = (1-gammasig).^2;
estimated.negLoggammaSig = -log(gamsig);
estimated.negLoggammaSig2 = log(estimated.gammaSig2);
estimated.negLoggammaSigP2 = estimated.negLoggammaSig.^2;

