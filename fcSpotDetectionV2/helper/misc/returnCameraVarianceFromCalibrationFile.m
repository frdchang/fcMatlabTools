function [cameraVarianceInADU] = returnCameraVarianceFromCalibrationFile(data,pathToCalibration)
%RETURNCAMERAVARIANCEFROMCALIBRATIONFILE Summary of this function goes here
%   Detailed explanation goes here

persistent prevPathToCalibration;
persistent cameraVarianceInADU;

if ~isequal(prevPathToCalibration,pathToCalibration)
    calibration = load(pathToCalibration);
    readNoiseInElectrons = calibration.cameraVarianceInADU*(calibration.gainElectronPerCount)^2;
    readNoiseInElectrons(calibration.brokenPixel>0) = inf;
    cameraVarianceInADU = repmat(readNoiseInElectrons,[1 1 size(data,3)]);
    prevPathToCalibration = pathToCalibration; 
end

