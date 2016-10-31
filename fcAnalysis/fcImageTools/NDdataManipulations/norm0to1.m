function ndstack = norm0to1(ndstack,varargin)
%NORM0TO1 maps stack to [0,1]  if userMin and userMax is provided it will
%normalize by those values.  if ndStack is a cell array it will normalize
%the array
%
% fchang@fas.harvard.edu
%--parameters--------------------------------------------------------------
params.userMin     = [];
params.userMax     = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if iscell(ndstack)
    for ii = 1:numel(ndstack)
       ndstack{ii} = doDaNorm(ndstack{ii}); 
    end
else
   ndstack = doDaNorm(ndstack,params); 
end

end

function ndstack = doDaNorm(ndstack,varargin)
%--parameters--------------------------------------------------------------
params.userMin     = [];
params.userMax     = [];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);
permissive = ndstack > -inf & ndstack < inf;
if isequal(ndstack,zeros(size(ndstack)))
   return;
end
ndstack = double(ndstack);
if ~isempty(params.userMax)
    maxValue = params.userMax;
else
    maxValue = max(ndstack(permissive));
end

if ~isempty(params.userMin)
    minValue = params.userMin;
else
    minValue = min(ndstack(permissive));
end

slope = (maxValue - minValue);
ndstack = (ndstack - minValue) / slope;
ndstack(ndstack==-inf) = 0;
ndstack(ndstack==inf) = 1;
end
