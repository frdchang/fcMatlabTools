function [electrons,photons] = returnElectrons(data,cameraParamStruct)
%RETURNELECTRONS given background and gain, returns estimated electrons
meanBkgnd = cameraParamStruct.offsetInAdu;
gainCountPerElectron = cameraParamStruct.gainElectronPerCount;
data = double(data);
electrons = bsxfun(@minus,data,meanBkgnd);
electrons = bsxfun(@rdivide,electrons,gainCountPerElectron);
if nargout == 2
    if isfield(cameraParamStruct,'QE')
        QE = cameraParamStruct.QE;
        photons = electrons/QE;
    else
        warning('no QE specified to calculate photon from electrons');
    end
end