function [dataInElectrons,cameraVarianceInADU] = returnElectronsFromCalibrationFile(data,pathToCalibration)
%RETURNELECTRONSFROMCALIBRATIONFILE will take a calibration mat file that
% contains information of the camera used

% persistent prevPathToCalibration;
% persistent calibration;
% 
% if ~isequal(prevPathToCalibration,pathToCalibration)
    calibration = load(pathToCalibration);
    readNoiseInElectrons = calibration.cameraVarianceInADU*(calibration.gainElectronPerCount)^2;
    readNoiseInElectrons(calibration.brokenPixel>0) = inf;
    calibration.cameraVarianceInADU = readNoiseInElectrons;
%     prevPathToCalibration = pathToCalibration;
% end

cameraVarianceInADU = repmat(calibration.cameraVarianceInADU,[1 1 size(data,3)]);
dataInElectrons = returnElectrons(data,calibration);


