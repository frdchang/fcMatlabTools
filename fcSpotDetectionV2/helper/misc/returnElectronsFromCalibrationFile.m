function [dataInElectrons,readNoiseVarInElectrons] = returnElectronsFromCalibrationFile(data,pathToCalibration)
%RETURNELECTRONSFROMCALIBRATIONFILE will take a calibration mat file that
% contains information of the camera used

persistent prevPathToCalibration;
persistent calibration;
persistent prevReadNoiseVarInElectrons;

if ~isequal(prevPathToCalibration,pathToCalibration)
    calibration = load(pathToCalibration);
    readNoiseInElectrons = calibration.cameraVarianceInADU*(calibration.gainElectronPerCount)^2;
    readNoiseInElectrons(calibration.brokenPixel>0) = inf;
    readNoiseInElectrons = repmat(readNoiseInElectrons,[1 1 size(data,3)]);
    prevReadNoiseVarInElectrons = readNoiseInElectrons;
    prevPathToCalibration = pathToCalibration;
end

dataInElectrons = returnElectrons(data,1/calibration.gainElectronPerCount,calibration.offsetInAdu,1);
readNoiseVarInElectrons = prevReadNoiseVarInElectrons;


