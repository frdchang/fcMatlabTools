function [ estimated ] = fieldEstimator(data,spotKern,cameraVariance,varargin)
%FIELDESTIMATOR will use gradient fields and hessian fields
% assums there is only 1 psf

if iscell(data)
data = data{1};
spotKern = spotKern{1};
end

estimated = findSpotsStage1V2(data,spotKern,cameraVariance,varargin{:});
[gradientFieldFilters,hessFieldFilters,kerns] = genFieldFilters(size(spotKern),spotKern);


gradOfData = calcFullGradientFilter(data,estimated,kerns.kern,kerns.kernDs,cameraVariance);
[gradXYZDotProduct] = convFieldKernels(gradOfData(3:end),gradientFieldFilters(3:end));

hessOfData = calcFullHessianFilter(data,estimated,kerns.kern,kerns.kernDs,kerns.kernD2s,cameraVariance);
[hessXYZDotProduct] = convFieldKernels(hessOfData(3:end,3:end),hessFieldFilters(3:end,3:end));

gradXYZDotProduct(gradXYZDotProduct<0) = 0;
hessXYZDotProduct(hessXYZDotProduct<0) = 0;

% gradXYZDotProduct = norm0to1(gradXYZDotProduct);
% hessXYZDotProduct = norm0to1(hessXYZDotProduct);


gradDOTLLRatio = gradXYZDotProduct.*estimated.LLRatio;
hessDOTLLRatio = hessXYZDotProduct.*estimated.LLRatio;

gradHessDOTLLRatio = gradXYZDotProduct.*hessXYZDotProduct.*estimated.LLRatio;

estimated.gradDOTLLRatio = gradDOTLLRatio;
estimated.hessDOTLLRatio = hessDOTLLRatio;
estimated.gradHessDOTLLRatio = gradHessDOTLLRatio;

