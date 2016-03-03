function lambdas = lambda_single3DGauss(theta,domains,maxThetas,dOrder)
%LAMBDA_SINGLE3DGAUSS returns the lambda model based on a single 3d
% gaussian.
%
% theta:        parameter values {x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak}
% domains:      domain values for each dimension {x,y,z} - traditionally
%               the output of meshgrid.
% maxThetas:    logical index of which thetas to output for derivatives.
%               non-zero maxTheta entries have zero derivatives
% dOrder:       1 = jacobian vector, 2 = hessian matrix, else = lambda.
%               the output is a cell matrix of numeric matrices
%               *hessian matrix is symmetric and populated on both sides of 
%               the diagonal.  
%
% notes - this function caches redundant calculations for the derivatives.

persistent heartFunc;
persistent prevTheta;
persistent firstDerivatives;
persistent secondDerivatives;

[x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak] = deal(theta{:});
[x,y,z] = deal(domains{:});

% if parameter set changes from previous calculation, update heartFunc, the
% redudant calculation that is used for calculating the derivatives.
if ~isequal(prevTheta,theta)
    heartFunc = exp(1).^((1/2).*((-1).*sigXsq.^(-1).*(x+(-1).*x0).^2+(...
        -1).*sigYsq.^(-1).*(y+(-1).*y0).^2+(-1).*sigZsq.^(-1).*(z+(-1).* ...
        z0).^2));
    prevTheta = theta;
end

% cache definitions of derivatives
if isempty(firstDerivatives)
    firstDerivatives = {...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigXsq.^(-1).*(x+(-1).*x0),...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigYsq.^(-1).*(y+(-1).*y0),...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigZsq.^(-1).*(z+(-1).*z0),...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigXsq.^(-2).*(x+(-1).*x0).^2,...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigYsq.^(-2).*(y+(-1).*y0).^2,...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigZsq.^(-2).*(z+(-1).*z0).^2,...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  heartFunc,...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  1};
    secondDerivatives = {...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigXsq.^(-2).*((-1).*sigXsq+(x+(-1).*x0).^2),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigXsq.^(-1).*sigYsq.^(-1).*(x+(-1).*x0).*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigXsq.^(-1).*sigZsq.^(-1).*(x+(-1).*x0).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigXsq.^(-3).*((-2).*sigXsq+(x+(-1).*x0).^2).*(x+(-1).*x0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigXsq.^(-1).*sigYsq.^(-2).*(x+(-1).*x0).*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigXsq.^(-1).*sigZsq.^(-2).*(x+(-1).*x0).*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  heartFunc.*sigXsq.^(-1).*(x+(-1).*x0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0;...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigXsq.^(-1).*sigYsq.^(-1).*(x+(-1).*x0).*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigYsq.^(-2).*((-1).*sigYsq+(y+(-1).*y0).^2),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigYsq.^(-1).*sigZsq.^(-1).*(y+(-1).*y0).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigXsq.^(-2).*sigYsq.^(-1).*(x+(-1).*x0).^2.*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigYsq.^(-3).*((-2).*sigYsq+(y+(-1).*y0).^2).*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigYsq.^(-1).*sigZsq.^(-2).*(y+(-1).*y0).*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)   heartFunc.*sigYsq.^(-1).*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0;...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigXsq.^(-1).*sigZsq.^(-1).*(x+(-1).*x0).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigYsq.^(-1).*sigZsq.^(-1).*(y+(-1).*y0).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  Amp.*heartFunc.*sigZsq.^(-2).*((-1).*sigZsq+(z+(-1).*z0).^2),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigXsq.^(-2).*sigZsq.^(-1).*(x+(-1).*x0).^2.*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigYsq.^(-2).*sigZsq.^(-1).*(y+(-1).*y0).^2.*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigZsq.^(-3).*((-2).*sigZsq+(z+(-1).*z0).^2).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  heartFunc.*sigZsq.^(-1).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0;...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigXsq.^(-3).*((-2).*sigXsq+(x+(-1).*x0).^2).*(x+(-1).*x0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigXsq.^(-2).*sigYsq.^(-1).*(x+(-1).*x0).^2.*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigXsq.^(-2).*sigZsq.^(-1).*(x+(-1).*x0).^2.*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/4).*Amp.*heartFunc.*sigXsq.^(-4).*((-4).*sigXsq+(x+(-1).*x0).^2).*(x+(-1).*x0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/4).*Amp.*heartFunc.*sigXsq.^(-2).*sigYsq.^(-2).*(x+(-1).*x0).^2.*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/4).*Amp.*heartFunc.*sigXsq.^(-2).*sigZsq.^(-2).*(x+(-1).*x0).^2.*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*heartFunc.*sigXsq.^(-2).*(x+(-1).*x0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0;...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigXsq.^(-1).*sigYsq.^(-2).*(x+(-1).*x0).*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigYsq.^(-3).*((-2).*sigYsq+(y+(-1).*y0).^2).*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigYsq.^(-2).*sigZsq.^(-1).*(y+(-1).*y0).^2.*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/4).*Amp.*heartFunc.*sigXsq.^(-2).*sigYsq.^(-2).*(x+(-1).*x0).^2.*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/4).*Amp.*heartFunc.*sigYsq.^(-4).*((-4).*sigYsq+(y+(-1).*y0).^2).*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/4).*Amp.*heartFunc.*sigYsq.^(-2).*sigZsq.^(-2).*(y+(-1).*y0).^2.*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*heartFunc.*sigYsq.^(-2).*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0;...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigXsq.^(-1).*sigZsq.^(-2).*(x+(-1).*x0).*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigYsq.^(-1).*sigZsq.^(-2).*(y+(-1).*y0).*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*Amp.*heartFunc.*sigZsq.^(-3).*((-2).*sigZsq+(z+(-1).*z0).^2).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/4).*Amp.*heartFunc.*sigXsq.^(-2).*sigZsq.^(-2).*(x+(-1).*x0).^2.*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/4).*Amp.*heartFunc.*sigYsq.^(-2).*sigZsq.^(-2).*(y+(-1).*y0).^2.*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/4).*Amp.*heartFunc.*sigZsq.^(-4).*((-4).*sigZsq+(z+(-1).*z0).^2).*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*heartFunc.*sigZsq.^(-2).*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0;...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  heartFunc.*sigXsq.^(-1).*(x+(-1).*x0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  heartFunc.*sigYsq.^(-1).*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  heartFunc.*sigZsq.^(-1).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*heartFunc.*sigXsq.^(-2).*(x+(-1).*x0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*heartFunc.*sigYsq.^(-2).*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  (1/2).*heartFunc.*sigZsq.^(-2).*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0;...
        @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc)  0};
end

switch dOrder
    case 1
        % calculate gradient vector permitted by maxThetas
        lambdas = cell(numel(maxThetas),1);
        lambdas(:) = {0};
        for i = 1:numel(lambdas)
            if maxThetas(i) > 0
                lambdas{i} = firstDerivatives{i}(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc);
            end
        end
    case 2
        % calculate the hessian matrix
        lambdas = cell(numel(maxThetas),numel(maxThetas));
        lambdas(:) = {0};
        % first generate diagonal and offdiagonal indices permitted by
        % maxThetas
        hessianIndices = maxThetas(:)*maxThetas(:)';
        % diagonal indices
        diagIndices = diag(diag(hessianIndices));
        % populate diagonal
        [diag_i,diag_j] = find(diagIndices);
        for i = 1:numel(diag_i)
           lambdas{diag_i(i),diag_j(i)} = secondDerivatives{diag_i(i),diag_j(i)} (x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc);
        end
        % upper off diagonal entries
        upperOffDiagIndices = triu(hessianIndices,1);
        [offDiag_i,offDiag_j] = find(upperOffDiagIndices);
        for i = 1:numel(offDiag_i)
            secondDeriv = secondDerivatives{offDiag_i(i),offDiag_j(i)} (x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc);
            lambdas{offDiag_i(i),offDiag_j(i)} = secondDeriv;
            lambdas{offDiag_j(i),offDiag_i(i)} = secondDeriv;
        end
    otherwise
        % return lambda given theta
        lambdas = Amp.*heartFunc + Bak;
end
