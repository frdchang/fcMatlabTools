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
    if iscell(data)
    readNoiseInElectrons = repmat(readNoiseInElectrons,[1 1 size(data{1},3)]);
    else
        readNoiseInElectrons = repmat(readNoiseInElectrons,[1 1 size(data,3)]);
    end
    prevReadNoiseVarInElectrons = readNoiseInElectrons;
    prevPathToCalibration = pathToCalibration;
end

if iscell(data)
    dataInElectrons = cellfunNonUniformOutput(@(x) returnElectrons(x,1/calibration.gainElectronPerCount,calibration.offsetInAdu,1),data);
else
    dataInElectrons = returnElectrons(data,1/calibration.gainElectronPerCount,calibration.offsetInAdu,1);
end

readNoiseVarInElectrons = prevReadNoiseVarInElectrons;


