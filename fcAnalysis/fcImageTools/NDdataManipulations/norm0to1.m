function ndstack = norm0to1(ndstack)
%NORM0TO1 maps stack to [0,1]
%
% fchang@fas.harvard.edu

if iscell(ndstack)
    for ii = 1:numel(ndstack)
       ndstack{ii} = doDaNorm(ndstack{ii}); 
    end
else
   ndstack = doDaNorm(ndstack); 
end

end

function ndstack = doDaNorm(ndstack)
if isequal(ndstack,zeros(size(ndstack)))
   return;
end
ndstack = double(ndstack);
maxValue = max(ndstack(:));
minValue = min(ndstack(:));
slope = (maxValue - minValue);
ndstack = (ndstack - minValue) / slope;
end
