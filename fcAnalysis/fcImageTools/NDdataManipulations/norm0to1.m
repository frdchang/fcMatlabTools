function ndstack = norm0to1(ndstack)
%NORM0TO1 maps stack to [0,1]
%
% fchang@fas.harvard.edu

if isequal(ndstack,zeros(size(ndstack)))
   return;
end

maxValue = max(ndstack(:));
minValue = min(ndstack(:));
slope = double((maxValue - minValue));
ndstack = double(double(ndstack) - minValue) / slope;

end

