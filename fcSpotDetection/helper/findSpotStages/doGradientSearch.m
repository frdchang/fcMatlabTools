function optDataStruct = doGradientSearch(initParam,useParams,gradFunc,data,varargin)
%DOGRADIENT will do gradient ascent or descent
%   *param cascade  -> gradFunc

%--parameters--------------------------------------------------------------
params.direction     = @plus;  % @plus is ascent, @minus is descent
params.stepSize      = 10;
params.maxIters      = 1000;
params.TolX          = 1;
params.plotFunc      = @plot3DGradSearch;
params.plotInt       = 100;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);
numPoints = numel(data);

optParam = initParam';
if isFunc(params.plotFunc)
    params.plotFunc(initParam,data,0);title('iter 0');
end
for iter = 1:params.maxIters
    optParam = params.direction(optParam,(params.stepSize/numPoints)*gradFunc(optParam,useParams,data,params));
    if isFunc(params.plotFunc) && mod(iter,params.plotInt) == 0;
        params.plotFunc(optParam,data,iter);title(['iter ' num2str(iter)]);
    end
end
optDataStruct = optParam;
end

