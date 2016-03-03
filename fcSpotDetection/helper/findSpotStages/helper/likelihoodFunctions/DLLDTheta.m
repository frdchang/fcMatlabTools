function derivatives = DLLDTheta(DLLDLambda,lambda,data,readNoise,theta,domains,maxThetas,dOrder)
%DLLDTHETA calculates the derivative of the log likelihood w.r.t. thetas in
% the lambda model using the chain rule DLL/DLambda * DLambda/DThetas.
% This amounts to a dot product between the error vector Dll/DLambda, which
% weighs the error appropriately with its likelihood assumptions and the
% derivative vector DLambda/Dthetas.
%
% DLLDLambda:   function handle to DLL/DLambda(data,lambda(theta,domains))
% lambda:       function handle to lambda(theta,domains) and this function
%               calculate the derivatives w.r.t. thetas
% readNoise:    variance of the readNoise in units of the data
% data:         the data
% theta:        parameter values {x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak}
% domains:      domain values for each dimension {x,y,z} - traditionally
%               the output of meshgrid.
% maxThetas:    logical index of which thetas to output for derivatives.
%               non-zero maxTheta entries have zero derivatives
% dOrder:       1 = jacobian vector, 2 = hessian matrix, else = lambda.
%               the output is a cell matrix of numeric matrices
%               *hessian matrix is symmetric and populated on both sides of
%               the diagonal.

switch dOrder
    case 1
        % return gradient vector
        getDLLDLambda = DLLDLambda(data,lambda(theta,domains,maxThetas,0),readNoise);
        getDLambdaDThetas = lambda(theta,domains,maxThetas,dOrder);
        derivatives = zeros(numel(theta),1);
        for i = 1:numel(theta)
            derivatives(i) = sum(getDLambdaDThetas.*getDLLDLambda{i});
        end
    case 2
        % return hessian matrix
        getDLLDLambda = DLLDLambda(data,lambda(theta,domains,maxThetas,0),readNoise);
        getDLambdaDThetas = lambda(theta,domains,maxThetas,dOrder);
        derivatives = zeros(numel(theta),numel(theta));
        % first generate diagonal and offdiagonal indices permitted by
        % maxThetas
        hessianIndices = maxThetas(:)*maxThetas(:)';
        % diagonal indices
        diagIndices = diag(diag(hessianIndices));
        % populate diagonal
        [diag_i,diag_j] = find(diagIndices);
        for i = 1:numel(diag_i)
            derivatives(diag_i(i),diag_j(i)) = sum(getDLambdaDThetas.*getDLLDLambda{diag(i),diag_j(i)});
        end
        % upper off diagonal entries
        upperOffDiagIndices = triu(hessianIndices,1);
        % populate off diagonal
        [offDiag_i,offDiag_j] = find(upperOffDiagIndices);
        for i = 1:numel(offDiag_i)
            derivatives(offDiag_i(i),offDiag_j(i)) = sum(getDLambdaDThetas.*getDLLDLambda{offDiag_i(i),offDiag_j(i)});
            derivatives(offDiag_j(i),offDiag_i(i)) = sum(getDLambdaDThetas.*getDLLDLambda{offDiag_j(i),offDiag_i(i)});
        end
    otherwise
        % calculate likelihood? nah, throw error, the likelihood function
        % depends on which likelihood, which requires additional info.  so
        % restrict this function to only calculate derivatives of order 1
        % or 2.
        error('derivative order dOrder needs to be 1 or 2');
end


