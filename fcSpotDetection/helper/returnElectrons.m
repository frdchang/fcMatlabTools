function [electrons,photons] = returnElectrons(data,gain,meanBkgnd,QE)
%RETURNELECTRONS given background and gain, returns estimated electrons
data = double(data);
electrons = bsxfun(@minus,data,meanBkgnd);
electrons = bsxfun(@rdivide,electrons,gain);
photons = electrons/QE;
