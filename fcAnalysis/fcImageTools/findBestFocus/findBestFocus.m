function [nSlice] = findBestFocus(varargin)
%FINDBESTFOCUS will return the slice number with the best focus as
%determined by the criteria of normalized variance
p = inputParser;
p.addRequired('stack',@(x) true);
p.addParamValue('findMin','true',@(x) true);
p.addParamValue('energyClass','GLVN',@(x) true);
p.addParamValue('usePriorOfCenter',true,@(x) true);
p.parse(varargin{:});
input = p.Results;
stack       = input.stack;
findMin     = input.findMin;
energyClass = input.energyClass;
usePriorOfCenter = input.usePriorOfCenter;
[~,~,zL] = size(stack);
focusmeasure(zL) = 0;
for i = 1:zL
    focusmeasure(i) = fmeasure(stack(:,:,i),energyClass);
end
if findMin
    
    %     if usePriorOfCenter
    %         x = 1:numel(focusmeasure);
    %         xCenter = round(numel(focusmeasure)/2);
    %         x = x - xCenter;
    %         y = x.^2;
    %         normy = y ./ sum(y(:));
    %         focusmeasure = focusmeasure.*normy;
    %     end
    %     nSlice = find(focusmeasure == min(focusmeasure));
    %     nSlice = nSlice(1);
    [pksOut,locsOut] = findpeaks(-smooth(focusmeasure,3));
    if ~isempty(locsOut)
    if usePriorOfCenter
        middleSlice = zL/2;
        distFromMid = abs(locsOut - middleSlice);
        minDist = min(distFromMid);
        minDist = minDist(1);
        index  = find(distFromMid ==minDist);
        nSlice = locsOut(index(1));
    else
        peaks = pksOut == min(pksOut(:));
        nSlice = locsOut(peaks(1));
    end
    else
        nSlice = round(zL/2);
    end
    
else
    
    %     if usePriorOfCenter
    %         x = 1:numel(focusmeasure);
    %         xCenter = round(numel(focusmeasure)/2);
    %         x = x - xCenter;
    %         y = -x.^2;
    %         normy = y ./ sum(y(:));
    %         focusmeasure = focusmeasure.*normy;
    %     end
    %     nSlice = find(focusmeasure == max(focusmeasure));
    %     nSlice = nSlice(1);
    [pksOut,locsOut] = findpeaks(focusmeasure);
    if ~isempty(locsOut)
    if usePriorOfCenter
        middleSlice = zL/2;
        distFromMid = abs(locsOut - middleSlice);
        minDist = min(distFromMid);
        minDist = minDist(1);
        index  = find(distFromMid ==minDist);
        nSlice = locsOut(index(1));
    else
        peaks = pksOut == max(pksOut(:));
        nSlice = locsOut(peaks(1));
    end
    else
        nSlice = round(zL/2);
    end
    
end






end

