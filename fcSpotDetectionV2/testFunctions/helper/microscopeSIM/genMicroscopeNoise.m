function [sampledData,poissonNoiseOnly,cameraParams] = genMicroscopeNoise(trueData,varargin)
%GENMICROSCOPENOISE will take trueData as the poisson level, and sample it
%   in a poisson distribution, then add gaussian read noise to simulate a
%   typical microscope with a scmos or ccd camera.
%
%   note for fred: in the future if the user provides a string file link
%   for a parameter, load that dataset in for that parameter, this will
%   allow for real calibrated microscope parameters.
%
%   note for fred: parameters are just placeholders, go make sure they are
%   correct in the future.

%--parameters--------------------------------------------------------------
params.readNoiseData = 1.0;        % electrons^2 (sigma) slow scan for flash v2+
params.gain          = 1/0.49;     % ADU/electrons  0.49 = electron / count
params.offset        = 100;        % ADU units
params.QE            = 0.82;       % flash v2+
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if iscell(trueData)
    outputs = cellfunNonUniformOutput(@(x) doDaSample(x,params),trueData);
    sampledData = cell(numel(outputs),1);
    poissonNoiseOnly = cell(numel(outputs),1);
    for ii = 1:numel(outputs)
        sampledData{ii} = outputs{ii}.sampledData;
        poissonNoiseOnly{ii} = outputs{ii}.poissonNoiseOnly;
    end
else
    myOutput = doDaSample(trueData,params);
    sampledData = myOutput.sampledData;
    poissonNoiseOnly = myOutput.poissonNoiseOnly;
end
cameraParams.cameraVarianceInADU = params.readNoiseData.*(params.gain.^2);
cameraParams.gainElectronPerCount = 1/params.gain;
cameraParams.offsetInAdu = params.offset;
cameraParams.QE = params.QE;
end

function [myOutput] = doDaSample(myData,params)
% lambda photons to lambda electrons captured
doTheSample = double(myData)*params.QE;
% quantum noise
doTheSample = poissrnd(doTheSample);
poissonOnlySample = doTheSample;
% read noise
% if read noise value is infinity just put large number
readNoiseData = params.readNoiseData;
readNoiseData(params.readNoiseData==inf) = 10000;
if isscalar(params.readNoiseData)
    doTheSample = doTheSample + normrnd(0,sqrt(readNoiseData),size(myData));
else
    doTheSample = doTheSample + normrnd(0,sqrt(readNoiseData));
end
% fill in neighbor pixels using inf information
doTheSample(params.readNoiseData==inf) = nan;
for ii = 1:size(doTheSample,3)
   doTheSample(:,:,ii) =  inPaintNansWMedian(doTheSample(:,:,ii));
end
% convert from electrons to ADU
doTheSample = doTheSample.*params.gain + params.offset;
myCameraParams.readNoiseData = params.readNoiseData;
myCameraParams.gain          = params.gain;
myCameraParams.offset        = params.offset;
myCameraParams.QE            = params.QE;


myOutput.sampledData = doTheSample;
myOutput.poissonNoiseOnly = poissonOnlySample;
myOutput.cameraParams = myCameraParams;
end


