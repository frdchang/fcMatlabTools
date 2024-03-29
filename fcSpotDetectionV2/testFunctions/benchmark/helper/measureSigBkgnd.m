function [sig,bkgnd ] = measureSigBkgnd(data,sigCoor,kernSize,dotheunpad)
%MEASURESIGBKGND will measure signal and bkgnd of data given a signal coor
%and kernSize will carve out what is bkgnd.
sigCoor = round(sigCoor);
sigCoorCell = num2cell(sigCoor);
sig = data(sigCoorCell{:});
hkern = floor(kernSize/2);
bottom = sigCoor(:) - hkern(:);
top    = sigCoor(:) + hkern(:);
sizeData = size(data);
selectorSig = cell(numel(bottom),1);

for ii = 1:numel(bottom)
    selectorSig{ii} = max(1,bottom(ii)):min(sizeData(ii),top(ii));
end

data(selectorSig{:}) = nan;
if dotheunpad
 data = unpadarrayByKernSize(data,round(kernSize/2));
end
bkgnd = data(~isnan(data));
