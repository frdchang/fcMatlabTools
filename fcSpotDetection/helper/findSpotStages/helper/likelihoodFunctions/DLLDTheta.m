function derivatives = DLLDTheta(LL,DLLDLambda,lambda,data,readNoise,theta,domains,maxThetas,dOrder)
%DLLDTHETA calculates the derivative of the log likelihood w.r.t. thetas in
% the lambda model using the chain rule DLL/DLambda * DLambda/DThetas.
% This amounts to a dot product between the error vector Dll/DLambda, which
% weighs the error appropriately with its likelihood assumptions and the
% derivative vector DLambda/Dthetas.
%
% LL:           log likelihood function handle
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
% dOrder:       1 = jacobian vector, 2 = hessian matrix, else = LogLike
%               the output is a cell matrix of numeric matrices
%               *hessian matrix is symmetric and populated on both sides of
%               the diagonal.
%
% [note] - this function calculates the derivatives of the log likelihood by the chain rule:
%   first deriv:    DLL/DLambda * DLambda/DTheta
%   second deriv:   D2LL/D2Lambda * DLambda/DTheta_i * DLambda/DTheta_j + DLL/DLambda * D2Lambda/(DTheta_i DTheta_j)
%
% what is interesting is the DLL/DLambda can be defined for any noise
% function.  The complicated poisson*gaussian noise function may have some
% benefits and can probably be pre-calculated, cached and interpolated

% todo: cache first order calculations for second order calculations
% persistent thisLambda;
% persistent getDLLDLambda;
% persistent getDLambdaDThetas;
% persistent prevTheta;
% persistent prevData;

switch dOrder
    case 1
        % return gradient vector
        thisLambda = lambda(theta,domains,maxThetas,0);
        getDLLDLambda = DLLDLambda(data,thisLambda,readNoise,1);
        getDLambdaDThetas = lambda(theta,domains,maxThetas,dOrder);
        derivatives = zeros(numel(theta),1);
        for i = 1:numel(theta)
            temp = getDLLDLambda.*getDLambdaDThetas{i};
            derivatives(i) = sum(temp(:));
        end
    case 2
        % return hessian matrix
        thisLambda = lambda(theta,domains,maxThetas,0);
        % calc first order derivative componenets
        getDLLDLambda = DLLDLambda(data,thisLambda,readNoise,1);
        getDLambdaDThetas = lambda(theta,domains,maxThetas,1);
        % calc second order derivative components
        getD2LLD2Lambda = DLLDLambda(data,thisLambda,readNoise,2);
        getD2LambdaD2Thetas = lambda(theta,domains,maxThetas,2);
        
        derivatives = zeros(numel(theta),numel(theta));
        % first generate diagonal and offdiagonal indices permitted by
        % maxThetas
        hessianIndices = maxThetas(:)*maxThetas(:)';
        % diagonal indices
        diagIndices = diag(diag(hessianIndices));
        % populate diagonal
        [diag_i,diag_j] = find(diagIndices);
        for i = 1:numel(diag_i)
            temp = getD2LLD2Lambda.*getDLambdaDThetas{diag_i(i)}.*getDLambdaDThetas{diag_j(i)} + getDLLDLambda.*getD2LambdaD2Thetas{diag_i(i),diag_j(i)};
            derivatives(diag_i(i),diag_j(i)) = sum(temp(:));
        end
        % upper off diagonal entries
        upperOffDiagIndices = triu(hessianIndices,1);
        % populate off diagonal
        [offDiag_i,offDiag_j] = find(upperOffDiagIndices);
        for i = 1:numel(offDiag_i)
            temp = getD2LLD2Lambda.*getDLambdaDThetas{offDiag_i(i)}.*getDLambdaDThetas{offDiag_j(i)} + getDLLDLambda.*getD2LambdaD2Thetas{offDiag_i(i),offDiag_j(i)};
            sumtemp = sum(temp(:));
            derivatives(offDiag_i(i),offDiag_j(i)) = sumtemp;
            derivatives(offDiag_j(i),offDiag_i(i)) = sumtemp;
        end
    otherwise
        % calculate likelihood
        % return hessian matrix
        thisLambda = lambda(theta,domains,maxThetas,0);
        derivatives =LL(data,thisLambda,readNoise);
end


