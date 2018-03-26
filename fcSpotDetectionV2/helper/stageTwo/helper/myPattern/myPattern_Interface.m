classdef myPattern_Interface < handle
    %LAMBDAINTERFACE given a pattern or a function parameterized by
    %thetaPos = [x y z ...]
    % the peak intensity is normalized to 1
    
    properties (Abstract)
    end
    
    methods (Abstract)
        givenTheta(obj,domains,theta)
        % generates the pattern given the theta
        getDerivatives(obj,maxThetas)
        returnShape(obj)
    end
    
    methods
        function [lambdas,gradLambdas,hessLambdas] = givenThetaGetDerivatives(obj,domains,theta,maxThetas,varargin)
            lambdas = obj.givenTheta(domains,theta,varargin{:});
            switch nargout
                case {1 0}
                     
                case {2}
                      gradLambdas = obj.getDerivatives(maxThetas);
                case {3}
                     [gradLambdas,hessLambdas] = obj.getDerivatives(maxThetas);
                otherwise
                    error('number of arguments out is not 1 or 2');
            end
        end
    end
end

