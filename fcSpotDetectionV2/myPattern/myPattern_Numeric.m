classdef myPattern_Numeric < myPattern_Interface
    properties (Access = protected)
        ndPatternOG
        domainsOG
        centerCoorOG
        numDims
        heartFunc
        binning
    end
    
    methods
        function obj = myPattern_Numeric(ndPatternOG,varargin)
            %--parameters--------------------------------------------------------------
            params.binning     = ones(1,ndims(ndPatternOG));
            %--------------------------------------------------------------------------
            params = updateParams(params,varargin);
            % myNumericPattern
            if nargin ==1
                obj.ndPatternOG    = ndPatternOG;
            end
            obj.domainsOG       = genMeshFromData(obj.ndPatternOG);
            obj.centerCoorOG    = round(size(obj.ndPatternOG)/2);
            obj.binning         = params.binning;
            obj.numDims         = numel(obj.centerCoorOG);
        end
        
        function lambdas = givenTheta(obj,domains,theta,varargin)
            %--parameters--------------------------------------------------------------
            params.interpMethod     = 'linear';
            %--------------------------------------------------------------------------
            params = updateParams(params,varargin);
            deltaPosition = theta - obj.centerCoorOG(1:numel(theta));
            for ii = 1:numel(domains)
                domains{ii} = domains{ii} - deltaPosition(ii);
            end
            obj.heartFunc = interpn(obj.domainsOG{:},obj.ndPatternOG,domains{:},params.interpMethod);
            obj.heartFunc(isnan(obj.heartFunc)) = 0;
            lambdas = NDbinData(obj.heartFunc,obj.binning);
        end
        
        function [gradLambdas,hessLambdas] = getDerivatives(obj,maxThetas)
            switch nargout
                case {1 0}
                    gradLambdas = NDgradientAndHessian(obj.heartFunc,obj.domainsOG);
                case 2
                    [gradLambdas,hessLambdas] = NDgradientAndHessian(obj.heartFunc,obj.domainsOG);
                    hessianIndices = maxThetas(:)*maxThetas(:)';
                    hessLambdas(~hessianIndices) = {0};
                    hessLambdas = cellfunNonUniformOutput(@(x) NDbinData(x,obj.binning),hessLambdas);
                otherwise
                    error('number of arguments out is not 1 or 2');
            end
            gradLambdas(~maxThetas) = {0};
            gradLambdas = cellfunNonUniformOutput(@(x) NDbinData(x,obj.binning),gradLambdas);
        end
    end
end

%% need to implement max thetas and binning

