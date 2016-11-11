function [electrons,photons] = returnElectrons(data,gainCountPerElectron,meanBkgnd,QE)
%RETURNELECTRONS given background and gain, returns estimated electrons
data = double(data);
electrons = bsxfun(@minus,data,meanBkgnd);
electrons = bsxfun(@rdivide,electrons,gainCountPerElectron);
if nargout == 2
    photons = electrons/QE;
end