classdef myPattern_3DGaussian < myPattern_Interface
    %GAUSSIANPATTERN theta = {x0,y0,z0,sigXsq,sigYsq,sigZsq}
    
    properties
        heartFunc
        numDims
        prevTheta
        prevDomains
        firstDerivatives = {...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigXsq.^(-1).*(x+(-1).*x0),...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigYsq.^(-1).*(y+(-1).*y0),...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigZsq.^(-1).*(z+(-1).*z0),...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigXsq.^(-2).*(x+(-1).*x0).^2,...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigYsq.^(-2).*(y+(-1).*y0).^2,...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigZsq.^(-2).*(z+(-1).*z0).^2};
        
        secondDerivatives = {...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigXsq.^(-2).*((-1).*sigXsq+(x+(-1).*x0).^2),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigXsq.^(-1).*sigYsq.^(-1).*(x+(-1).*x0).*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigXsq.^(-1).*sigZsq.^(-1).*(x+(-1).*x0).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigXsq.^(-3).*((-2).*sigXsq+(x+(-1).*x0).^2).*(x+(-1).*x0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigXsq.^(-1).*sigYsq.^(-2).*(x+(-1).*x0).*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigXsq.^(-1).*sigZsq.^(-2).*(x+(-1).*x0).*(z+(-1).*z0).^2;...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigXsq.^(-1).*sigYsq.^(-1).*(x+(-1).*x0).*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigYsq.^(-2).*((-1).*sigYsq+(y+(-1).*y0).^2),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigYsq.^(-1).*sigZsq.^(-1).*(y+(-1).*y0).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigXsq.^(-2).*sigYsq.^(-1).*(x+(-1).*x0).^2.*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigYsq.^(-3).*((-2).*sigYsq+(y+(-1).*y0).^2).*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigYsq.^(-1).*sigZsq.^(-2).*(y+(-1).*y0).*(z+(-1).*z0).^2;...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigXsq.^(-1).*sigZsq.^(-1).*(x+(-1).*x0).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigYsq.^(-1).*sigZsq.^(-1).*(y+(-1).*y0).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigZsq.^(-2).*((-1).*sigZsq+(z+(-1).*z0).^2),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigXsq.^(-2).*sigZsq.^(-1).*(x+(-1).*x0).^2.*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigYsq.^(-2).*sigZsq.^(-1).*(y+(-1).*y0).^2.*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigZsq.^(-3).*((-2).*sigZsq+(z+(-1).*z0).^2).*(z+(-1).*z0);...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigXsq.^(-3).*((-2).*sigXsq+(x+(-1).*x0).^2).*(x+(-1).*x0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigXsq.^(-2).*sigYsq.^(-1).*(x+(-1).*x0).^2.*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigXsq.^(-2).*sigZsq.^(-1).*(x+(-1).*x0).^2.*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/4).*Amp.*heartFunc.*sigXsq.^(-4).*((-4).*sigXsq+(x+(-1).*x0).^2).*(x+(-1).*x0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/4).*Amp.*heartFunc.*sigXsq.^(-2).*sigYsq.^(-2).*(x+(-1).*x0).^2.*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/4).*Amp.*heartFunc.*sigXsq.^(-2).*sigZsq.^(-2).*(x+(-1).*x0).^2.*(z+(-1).*z0).^2;...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigXsq.^(-1).*sigYsq.^(-2).*(x+(-1).*x0).*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigYsq.^(-3).*((-2).*sigYsq+(y+(-1).*y0).^2).*(y+(-1).*y0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigYsq.^(-2).*sigZsq.^(-1).*(y+(-1).*y0).^2.*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/4).*Amp.*heartFunc.*sigXsq.^(-2).*sigYsq.^(-2).*(x+(-1).*x0).^2.*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/4).*Amp.*heartFunc.*sigYsq.^(-4).*((-4).*sigYsq+(y+(-1).*y0).^2).*(y+(-1).*y0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/4).*Amp.*heartFunc.*sigYsq.^(-2).*sigZsq.^(-2).*(y+(-1).*y0).^2.*(z+(-1).*z0).^2;...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigXsq.^(-1).*sigZsq.^(-2).*(x+(-1).*x0).*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigYsq.^(-1).*sigZsq.^(-2).*(y+(-1).*y0).*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/2).*Amp.*heartFunc.*sigZsq.^(-3).*((-2).*sigZsq+(z+(-1).*z0).^2).*(z+(-1).*z0),@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/4).*Amp.*heartFunc.*sigXsq.^(-2).*sigZsq.^(-2).*(x+(-1).*x0).^2.*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/4).*Amp.*heartFunc.*sigYsq.^(-2).*sigZsq.^(-2).*(y+(-1).*y0).^2.*(z+(-1).*z0).^2,@(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  (1/4).*Amp.*heartFunc.*sigZsq.^(-4).*((-4).*sigZsq+(z+(-1).*z0).^2).*(z+(-1).*z0).^2};
    end
    
    methods
        function obj = myPattern_3Dgaussian(varargin)
        end
        
        function lambdas = givenTheta(obj,theta,domains)
            [posCoor,mySigmas,myDomains] = extractThetasAndDomains(obj,theta,domains);
            obj.heartFunc = exp(1).^((1/2).*((-1).*mySigmas(1).^(-1).*(myDomains{1}+(-1).*posCoor(1)).^2+(...
                -1).*mySigmas(2).^(-1).*(myDomains{2}+(-1).*posCoor(2)).^2+(-1).*mySigmas(3).^(-1).*(myDomains{3}+(-1).* ...
                posCoor(3)).^2));
            
            lambdas = obj.heartFunc;
        end
        
        function [gradLambdas,hessLambdas] = getDerivatives(obj,maxThetas)
            [posCoor,mySigmas,myDomains] = extractThetasAndDomains(obj,theta,domains);
            
            switch nargout
                case {1 0}
                    % calculate gradient vector permitted by maxThetas
                    gradLambdas = cell(numel(maxThetas),1);
                    gradLambdas(:) = {0};
                    for i = 1:numel(gradLambdas)
                        if maxThetas(i) > 0
                            gradLambdas{i} = obj.firstDerivatives{i}(posCoor(1),posCoor(2),posCoor(3),mySigmas(1),mySigmas(2),mySigmas(3),1,0,obj.heartFunc,myDomains{1},myDomains{2},myDomains{3});
                        end
                    end
                case 2
                    % calculate the hessian matrix
                    hessLambdas = cell(numel(maxThetas),numel(maxThetas));
                    hessLambdas(:) = {0};
                    % first generate diagonal and offdiagonal indices permitted by
                    % maxThetas
                    hessianIndices = maxThetas(:)*maxThetas(:)';
                    % diagonal indices
                    diagIndices = diag(diag(hessianIndices));
                    % populate diagonal
                    [diag_i,diag_j] = find(diagIndices);
                    for i = 1:numel(diag_i)
                        hessLambdas{diag_i(i),diag_j(i)} = obj.secondDerivatives{diag_i(i),diag_j(i)} (posCoor(1),posCoor(2),posCoor(3),mySigmas(1),mySigmas(2),mySigmas(3),1,0,obj.heartFunc,myDomains{1},myDomains{2},myDomains{3});
                    end
                    % upper off diagonal entries
                    upperOffDiagIndices = triu(hessianIndices,1);
                    [offDiag_i,offDiag_j] = find(upperOffDiagIndices);
                    for i = 1:numel(offDiag_i)
                        secondDeriv = obj.secondDerivatives{offDiag_i(i),offDiag_j(i)} (posCoor(1),posCoor(2),posCoor(3),mySigmas(1),mySigmas(2),mySigmas(3),1,0,obj.heartFunc,myDomains{1},myDomains{2},myDomains{3});
                        hessLambdas{offDiag_i(i),offDiag_j(i)} = secondDeriv;
                        hessLambdas{offDiag_j(i),offDiag_i(i)} = secondDeriv;
                    end
                otherwise
                    error('number of arguments out is not 1 or 2');
            end
            
        end
        
    end
    
end

