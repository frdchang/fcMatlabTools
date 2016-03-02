function lambda = lambda_3DGaussian(params,datas,useParams,derivativeIndex)
%LAMBDA_3DGAUSSIAN is a lambda model for a given patch of data.
% 
% the derivativeIndex returns the derivative w.r.t. the numbered parameter
% params = {Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq} 
% datas  = {x,y,z}
% datas need to be in column major vectors
% derivativeIndex = 0 returns lambda
% derivativeIndex = {1,1} returns derivative w.r.t Amp
% derivativeIndex = {1,2} returns second derivative w.r.t Amp
%
% *notes: this function has redundant calculations that is saved as
% persistent variables.  to initialize these variables call with derivative
% Index = 0.  (which the gradient ascent routines do anyways).

persistent heartFunc;
persistent lambdaFuncs;

[Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq] = deal(params{:});
[x,y,z] = deal(datas{:});

if ~iscell(derivativeIndex)
    % need to initialize heartFunc if derivativeIndex = 0;
    heartFunc = exp(1).^((1/2).*((-1).*sigXsq.^(-1).*(x+(-1).*x0).^2+(...
        -1).*sigYsq.^(-1).*(y+(-1).*y0).^2+(-1).*sigZsq.^(-1).*(z+(-1).* ...
        z0).^2));
    lambda = Bak+Amp.*heartFunc;
    % initialize lambdaFuncs
    lambdaFuncs = {...
    @(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) heartFunc,@(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) 0;...
    @(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) 1,@(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) 0;...
    @(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) Amp.*heartFunc.*sigXsq.^(-1).*(x+(-1).*x0),@(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) Amp.*heartFunc.*sigXsq.^(-2).*((-1).*sigXsq+(x+(-1).*x0).^2);...
    @(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) Amp.*heartFunc.*sigYsq.^(-1).*(y+(-1).*y0),@(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) Amp.*heartFunc.*sigYsq.^(-2).*((-1).*sigYsq+(y+(-1).*y0).^2);...
    @(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) Amp.*heartFunc.*sigZsq.^(-1).*(z+(-1).*z0),@(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) Amp.*heartFunc.*sigZsq.^(-2).*((-1).*sigZsq+(z+(-1).*z0).^2);...
    @(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) (1/2).*Amp.*heartFunc.*sigXsq.^(-2).*(x+(-1).*x0).^2,@(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) (1/4).*Amp.*heartFunc.*sigXsq.^(-4).*((-4).*sigXsq+(x+(-1).*x0).^2).*(x+(-1).*x0).^2;...
    @(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) (1/2).*Amp.*heartFunc.*sigYsq.^(-2).*(y+(-1).*y0).^2,@(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) (1/4).*Amp.*heartFunc.*sigYsq.^(-4).*((-4).*sigYsq+(y+(-1).*y0).^2).*(y+(-1).*y0).^2;...
    @(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) (1/2).*Amp.*heartFunc.*sigZsq.^(-2).*(z+(-1).*z0).^2,@(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc) (1/4).*Amp.*heartFunc.*sigZsq.^(-4).*((-4).*sigZsq+(z+(-1).*z0).^2).*(z+(-1).*z0).^2;...
    };
    return;
else
    lambda = lambdaFuncs{derivativeIndex{:}}(Amp,Bak,x0,y0,z0,sigXsq,sigYsq,sigZsq,x,y,z,heartFunc);
end