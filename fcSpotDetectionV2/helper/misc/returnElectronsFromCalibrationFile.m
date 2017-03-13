function [dataInElectrons] = returnElectronsFromCalibrationFile(data,pathToCalibration)
%RETURNELECTRONSFROMCALIBRATIONFILE will take a calibration mat file that
% contains information of the camera used

persistent prevPathToCalibration;
persistent calibration;

if ~isequal(prevPathToCalibration,pathToCalibration)
    calibration = load(pathToCalibration);
    readNoiseInElectrons = calibration.cameraVarianceInADU*(calibration.gainElectronPerCount)^2;
    readNoiseInElectrons(calibration.brokenPixel>0) = inf;
    calibration.cameraVarianceInADU = repmat(readNoiseInElectrons,[1 1 size(data,3)]);
    calibration = rmfield(calibration.brokenPixel);
    prevPathToCalibration = pathToCalibration;
end

if iscell(data)
    dataInElectrons = cellfunNonUniformOutput(@(x) returnElectrons(x,calibration),data);
else
    dataInElectrons = returnElectrons(data,calibration);
end

