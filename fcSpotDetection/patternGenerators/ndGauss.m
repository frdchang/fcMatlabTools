function [daGauss,separateComponents] = ndGauss(sigmaVector,sizeVector,varargin)
%MAKE3DGAUSS generates a nD gaussian parameterized by:
% sigmaVector = [sigma_xx,sigma_y,sigma_z,....]
% sizeVector  = [numPixels_x,numPixels_y,numPixels_z,...]
% also a muVector can be defined as a last argument that defines the offset
% e.g. stuff = ndGauss([sigmas],[sizes],[offsets]);
% daGauss is the nD numeric array that contains the nD gaussian
% separateComponents is the separable components that can be used for
% separable convolution
%
%
% fchang@fas.harvard.edu

if nargin == 2
   muVector = zeros(size(sigmaVector)); 
else
    muVector = varargin{1};
end

dims = numel(sigmaVector);
separateComponents = cell(dims,1);
for i = 1:dims
    defineDomain = sizeVector(i)/2 - 0.5;
    currDomain = -defineDomain:defineDomain;
    currGauss = normpdf(currDomain,muVector(i),sigmaVector(i));
    % normalize each component, which normalizes total components
    currGauss = currGauss / sum(currGauss(:));
    reshapeVec = ones(dims,1);
    reshapeVec(i) = numel(currGauss);
    currGauss = reshape(currGauss,reshapeVec');
    separateComponents{i} = currGauss;
    if i == 1
       daGauss = currGauss; 
    else
        daGauss = convn(currGauss,daGauss);
    end
end


