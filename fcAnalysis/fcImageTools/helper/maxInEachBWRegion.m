function [daMaxes] = maxInEachBWRegion(bwMask,data)
%MAXINEACHBWREGION returns the brightest pixel in each bwmask
s = regionprops(bwMask,data,'MaxIntensity');
daMaxes = [s.MaxIntensity];
end

