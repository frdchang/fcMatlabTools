classdef myPattern_Interface < handle
    %LAMBDAINTERFACE given a pattern or a function parameterized by
    %thetaPos = [x y z ...]
    
    properties (Abstract)
    end
    
    methods (Abstract)
        givenTheta(obj,theta,domains)
        % generates the pattern given the theta
        getDerivatives(obj,maxThetas)
    end
    
    methods
        function [gradLambdas,hessLambdas] = givenThetaGetDerivatives(obj,theta,domains,maxThetas,varargin)
            obj.givenTheta(theta,domains,varargin{:});
            switch nargout
                case {1 0}
                    gradLambdas = obj.getDerivatives(maxThetas);
                case {2}
                    [gradLambdas,hessLambdas] = obj.getDerivatives(maxThetas);
                otherwise
                    error('number of arguments out is not 1 or 2');
            end
        end
    end
end

