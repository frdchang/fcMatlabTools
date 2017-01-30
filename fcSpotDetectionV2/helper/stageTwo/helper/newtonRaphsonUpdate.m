function [theta0s,state] = newtonRaphsonUpdate(theta0s,newtonRaphsonSelctorD1,DLLDThetasRaphson,D2LLD2ThetasRaphson)
%NEWTONRAPHSONUPDATE will do newton update

mleThetas = flattenTheta0s(theta0s);


conditionNumber = rcond(D2LLD2ThetasRaphson);
if  conditionNumber < 3e-16
    % this is a bad hessian matrix
    %             warning('hessian is either not posDef or rconditinon number is < eps');
    state = 'hessian was either not posDef or condition number for inversion was poor';
    return;
else
    % this is a good hessian matrix
    try
        updateMLE = D2LLD2ThetasRaphson\DLLDThetasRaphson;
    catch
        %                 warning('hessian is not inverting well');
        state = 'hessian inversion caused error';
        return;
    end
end
mleThetas(newtonRaphsonSelctorD1) = mleThetas(newtonRaphsonSelctorD1) - updateMLE;
theta0s = updateTheta0s(theta0s,mleThetas);
state = 'ok';

