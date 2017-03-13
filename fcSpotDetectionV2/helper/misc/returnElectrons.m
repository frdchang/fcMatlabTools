function [electrons,photons] = returnElectrons(data,cameraParamStruct)
%RETURNELECTRONS given background and gain, returns estimated electrons

if iscell(data)
    electrons = cellfunNonUniformOutput(@(x) returnElectronsHelper(x,cameraParamStruct),data);
    if nargout == 2
        if isfield(cameraParamStruct,'QE')
            photons = cellfunNonUniformOutput(@(x) x/ cameraParamStruct.QE,electrons);
        end
    end
else
    electrons = returnElectronsHelper(data,cameraParamStruct);
    if nargout == 2
        if isfield(cameraParamStruct,'QE')
            photons = electrons / cameraParamStruct.QE;
        end
    end
end
end

function [electrons] = returnElectronsHelper(data,cameraParamStruct)
data = double(data);
electrons = bsxfun(@minus,data, cameraParamStruct.offsetInAdu);
electrons = bsxfun(@times,electrons,cameraParamStruct.gainElectronPerCount);
end