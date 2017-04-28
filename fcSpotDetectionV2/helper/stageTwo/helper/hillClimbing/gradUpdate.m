function theta0s = gradUpdate(theta0s,DLLDThetas,gradientSelectorD,varargin)
%GRADUPDATE update theta0s with DLLDThetas

%--parameters--------------------------------------------------------------
% gradient ascent parameters
params.stepSize         = .001;
params.normGrad         = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

if params.normGrad 
    % normalize what is selected
    tempTheta = DLLDThetas(gradientSelectorD);
    if any(tempTheta)
    tempTheta = tempTheta/sqrt(sum(tempTheta.^2));
    DLLDThetas(gradientSelectorD) = tempTheta;
    end
end

mleTheta = flattenTheta0s(theta0s);
mleTheta = mleTheta +params.stepSize*DLLDThetas;
theta0s = updateTheta0s(theta0s,mleTheta);

end

