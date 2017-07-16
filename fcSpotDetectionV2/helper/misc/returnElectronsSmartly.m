function [electrons,photons,readNoiseInElectrons] = returnElectronsSmartly(data,varargin)
%RETURNELECTRONSSMARTLY Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.calibrationFiles     = {'~/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI1024x1024-SlowScan-20160916-noDefectCorrection.mat','/home/fchang/Dropbox/code/Matlab/fcBinaries/calibration-ID001486-CoolerAIR-ROI2048x2048-SlowScan-sensorCorrectionOFF-20161021.mat'};
params.sizeOfCalibrationFiles = {[1024,1024],[2048,2048]};
params.namesOfCalibration = {'ID001486-CoolerAIR-ROI1024x1024-SlowScan','ID001486-CoolerAIR-ROI2048x2048-SlowScan'};
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

sizeData = size(data);

idx = cellfun(@(x) isequal(x,sizeData([1,2])),params.sizeOfCalibrationFiles);

if any(idx)
    calibration = load(params.calibrationFiles{idx});
    [electrons,photons] = returnElectrons(data,calibration);
    readNoiseInElectrons = calibration.cameraVarianceInADU*(calibration.gainElectronPerCount)^2;
    readNoiseInElectrons(calibration.brokenPixel>0) = inf;
    readNoiseInElectrons = repmat(readNoiseInElectrons,[1 1 size(data,3)]);
    display(['returnElectronsSmartly():    using calibration ' params.namesOfCalibration{idx}]);
else
    error('size of data does not equal to any of the calibration files');
end

