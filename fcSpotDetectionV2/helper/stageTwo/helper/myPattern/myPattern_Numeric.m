classdef myPattern_Numeric < myPattern_Interface
    properties (Access = protected)
        ndPatternOG
        domainsOG
        centerCoorOG
        numDims
        heartFunc
        binning
        newDomains
    end
    
    methods
        function obj = myPattern_Numeric(ndPatternOG,varargin)
            % if the domain of the pattern is specified, it will use that
            % instead of assuming that the pattern has a domain with
            % increment of 1
            %
            % when you give it a domain of the pattern, the units are when
            % after the binning happens.  
            
            %--parameters--------------------------------------------------------------
            params.binning          = [];
            params.domains          = [];
            params.normPeakHeight   = true;
            %--------------------------------------------------------------------------
            params = updateParams(params,varargin);
            % myNumericPattern
            
            if params.normPeakHeight
                obj.ndPatternOG    = ndPatternOG/max(ndPatternOG(:));
            else
                obj.ndPatternOG    = ndPatternOG;
            end
            
            if isempty(params.domains)
                obj.domainsOG      = genMeshFromData(obj.ndPatternOG);
            else
                obj.domainsOG      = params.domains; 
            end
            
            obj.centerCoorOG    = num2cell(round(size(obj.ndPatternOG)/2));
            obj.centerCoorOG    = cellfun(@(myDom) myDom(obj.centerCoorOG{:}),obj.domainsOG);
            obj.numDims         = numel(obj.centerCoorOG);
            
            if isempty(params.binning)
               obj.binning         = ones(size(obj.ndPatternOG)); 
            else
                obj.binning        = params.binning;
            end
        end
        
        function [myOGShape,binnedShape] = returnShape(obj)
            myOGShape = obj.ndPatternOG;
            binnedShape = NDbinData(obj.ndPatternOG,obj.binning);
        end
        
        function [lambdas,heartFunc] = givenTheta(obj,domains,theta,varargin)
          % domains is where the new pattern will be put on
            % theta  is where the pattern is
            % 'interpMethod', is how you interpolate the pattern
            % it knows the bin mode, so the domain you give it doesn't have
            % to take into account the binning.  so give it regular domain,
            % and this functino will expand the domain 
            %--parameters--------------------------------------------------------------
            params.interpMethod     = 'linear';
            %--------------------------------------------------------------------------
            params = updateParams(params,varargin);
            % calc how the shape will be moved
            deltaPosition = theta(:) - obj.centerCoorOG(1:numel(theta));
            % do domain expansino according to bin
            domainParams = calcMinMaxFromMeshData(domains);
        
%             for ii = 1:numel(domains)
%                 myArg = num2cell(domainParams(ii,:).*[obj.binning(ii) obj.binning(ii) obj.binning(ii)]);
%                 domains{ii} = linspace(myArg{:});
%             end
%             
%             [domains{:}] = ndgrid(domains{:});
%             
            for ii = 1:numel(domains)
                domains{ii} = domains{ii} - deltaPosition(ii);
            end
            obj.heartFunc = interpn(obj.domainsOG{:},obj.ndPatternOG,domains{:},params.interpMethod);
            obj.heartFunc(isnan(obj.heartFunc)) = 0;
            obj.newDomains = domains;
            heartFunc = obj.heartFunc;
            lambdas = heartFunc;
%             lambdas = NDbinData(obj.heartFunc,obj.binning);
        end
        
        function [gradLambdas,hessLambdas] = getDerivatives(obj,maxThetas)
            switch nargout
                case {1 0}
                    gradLambdas = NDgradientAndHessian(obj.heartFunc,obj.domainsOG);
                case 2
                    [gradLambdas,hessLambdas] = NDgradientAndHessian(obj.heartFunc,obj.newDomains);
                    hessianIndices = maxThetas(:)*maxThetas(:)';
                    hessLambdas(~hessianIndices) = {0};
%                     hessLambdas = cellfunNonUniformOutput(@(x) NDbinData(x,obj.binning),hessLambdas);
                otherwise
                    error('number of arguments out is not 1 or 2');
            end
            gradLambdas(~maxThetas) = {0};
%             gradLambdas = cellfunNonUniformOutput(@(x) NDbinData(x,obj.binning),gradLambdas);
        end
    end
end

%% need to implement max thetas and binning

