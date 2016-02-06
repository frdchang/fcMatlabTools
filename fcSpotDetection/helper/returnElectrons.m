function [electrons] = returnElectrons(data,gain,meanBkgnd)
%RETURNELECTRONS given background and gain, returns estimated electrons
data = double(data);
electrons = bsxfun(@minus,data,meanBkgnd);
electrons = bsxfun(@rdivide,electrons,gain);

end