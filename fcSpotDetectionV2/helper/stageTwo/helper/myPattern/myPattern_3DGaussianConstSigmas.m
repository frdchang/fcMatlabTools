classdef myPattern_3DGaussianConstSigmas < myPattern_Interface
    %GAUSSIANPATTERN theta = {x0,y0,z0,sigXsq,sigYsq,sigZsq}
    
    properties (Access = protected)
        heartFunc
        numDims
        prevTheta
        prevDomains
        mySigmas
        posCoor
        myDomains
        hessianIdxUpper
        hessianIdxLower
        
        firstDerivatives = {...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigXsq.^(-1).*(x+(-1).*x0),...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigYsq.^(-1).*(y+(-1).*y0),...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigZsq.^(-1).*(z+(-1).*z0)};
        
        secondDerivatives = {...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigXsq.^(-2).*((-1).*sigXsq+(x+(-1).*x0).^2),                 @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigXsq.^(-1).*sigYsq.^(-1).*(x+(-1).*x0).*(y+(-1).*y0),       @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigXsq.^(-1).*sigZsq.^(-1).*(x+(-1).*x0).*(z+(-1).*z0),...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigYsq.^(-2).*((-1).*sigYsq+(y+(-1).*y0).^2),                 @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigYsq.^(-1).*sigZsq.^(-1).*(y+(-1).*y0).*(z+(-1).*z0),...
            @(x0,y0,z0,sigXsq,sigYsq,sigZsq,Amp,Bak,heartFunc,x,y,z)  Amp.*heartFunc.*sigZsq.^(-2).*((-1).*sigZsq+(z+(-1).*z0).^2)};
    end
    
    methods
        function obj = myPattern_3DGaussianConstSigmas(mySigmas,varargin)
            obj.mySigmas = mySigmas;
            obj.hessianIdxUpper = find(triu(ones(3,3)));
            obj.hessianIdxLower = find(tril(ones(3,3),-1));
        end
        
        function myShape = returnShape(obj)
            sizeVector =  calcMinMaxFromMeshData(obj.myDomains);
            sizeVector = sizeVector(:,3);
            [~,separateComponents] = ndGauss(obj.mySigmas,sizeVector);
            myShape = separateComponents;
        end
        
        function mySize = returnSize(obj)
                        sizeVector =  calcMinMaxFromMeshData(obj.myDomains);
            sizeVector = sizeVector(:,3);
            mySize = sizeVector;
        end
        
        function lambdas = givenTheta(obj,myDomains,theta,varargin)
            obj.myDomains = myDomains;
            obj.posCoor = theta;
            sigmas = obj.mySigmas;
            obj.heartFunc = exp(1).^((1/2).*((-1).*sigmas(1).^(-1).*(myDomains{1}+(-1).*theta(1)).^2+(...
                -1).*sigmas(2).^(-1).*(myDomains{2}+(-1).*theta(2)).^2+(-1).*sigmas(3).^(-1).*(myDomains{3}+(-1).* ...
                theta(3)).^2));
            lambdas = obj.heartFunc;
        end
        
        function [gradLambdas,hessLambdas] = getDerivatives(obj,maxThetas)
            posCoor = obj.posCoor;
            sigmas  = obj.mySigmas;
            heartFunc = obj.heartFunc;
            domains = obj.myDomains;
            switch nargout
                case {1 0}
                    % calculate gradient vector permitted by maxThetas
                    gradLambdas = cell(numel(maxThetas),1);
                    gradLambdas(:) = {0};
                    for i = 1:numel(gradLambdas)
                        if maxThetas(i) > 0
                            gradLambdas{i} = obj.firstDerivatives{i}(posCoor(1),posCoor(2),posCoor(3),sigmas(1),sigmas(2),sigmas(3),1,0,heartFunc,domains{1},domains{2},domains{3});
                        end
                    end
                case 2
                    % calculate gradient vector permitted by maxThetas
                    gradLambdas = cell(numel(maxThetas),1);
                    gradLambdas(:) = {0};
                    for i = 1:numel(gradLambdas)
                        if maxThetas(i) > 0
                            gradLambdas{i} = obj.firstDerivatives{i}(posCoor(1),posCoor(2),posCoor(3),sigmas(1),sigmas(2),sigmas(3),1,0,heartFunc,domains{1},domains{2},domains{3});
                        end
                    end
                    % calculate the hessian matrix permitted by maxThetas
                    % !! actually just return hessian
                    hessLambdas = cell(numel(maxThetas),numel(maxThetas));
                    for ii = 1:6
                        hessLambdas{obj.hessianIdxUpper(ii)} = obj.secondDerivatives{ii}(posCoor(1),posCoor(2),posCoor(3),sigmas(1),sigmas(2),sigmas(3),1,0,heartFunc,domains{1},domains{2},domains{3});
                    end
                     hessLambdas(obj.hessianIdxLower) = hessLambdas([4,7,8]);
                otherwise
                    error('number of arguments');
            end
        end
        
    end
    
end

