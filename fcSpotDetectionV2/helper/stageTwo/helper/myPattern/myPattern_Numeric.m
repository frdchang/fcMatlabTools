classdef myPattern_Numeric < myPattern_Interface
    properties (Access = protected)
        ndPatternOG
        domainsOG
        centerCoorOG
        numDims
        heartFunc
        downSample
        newDomains
    end
    
    methods
        function obj = myPattern_Numeric(ndPatternOG,varargin)
            % if the domain of the pattern is specified, it will use that
            % instead of assuming that the pattern has a domain with
            % increment of 1
            %
            % when you give it a domain of the pattern, the units are when
            % after the downSample happens.
            
            %--parameters--------------------------------------------------------------
            params.downSample          = [];
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
            
            if isempty(params.downSample)
                obj.downSample        = ones(1,ndims(obj.ndPatternOG));
            else
                obj.downSample        = params.downSample;
            end
            
            if isempty(params.domains)
                obj.domainsOG      = genMeshFromData(obj.ndPatternOG,obj.downSample);
            else
                obj.domainsOG      = params.domains;
            end
            
            obj.centerCoorOG    = num2cell(round(size(obj.ndPatternOG)/2));
            obj.centerCoorOG    = cellfun(@(myDom) myDom(obj.centerCoorOG{:}),obj.domainsOG);
            obj.numDims         = numel(obj.centerCoorOG);
            

        end
        
        function [myOGShape] = returnShape(obj)
            selector = cell(ndims(obj.ndPatternOG),1);
            centerCoor = getCenterCoor(size(obj.ndPatternOG));

            for ii = 1:ndims(obj.ndPatternOG)
                selector{ii} = [flip(centerCoor(ii)-obj.downSample(ii):-obj.downSample(ii):1) centerCoor(ii):obj.downSample(ii):size(obj.ndPatternOG,ii)];
            end
            myOGShape = obj.ndPatternOG(selector{:});
%             binnedShape = NDbinData(obj.ndPatternOG,obj.downSample);
        end
        
        function [lambdas,heartFunc] = givenTheta(obj,domains,theta,varargin)
            % domains is where the new pattern will be put on
            % theta  is where the pattern is
            % 'interpMethod', is how you interpolate the pattern
            % it knows the bin mode, so the domain you give it doesn't have
            % to take into account the downSample.  so give it regular domain,
            % and this functino will expand the domain
            %--parameters--------------------------------------------------------------
            params.interpMethod     = 'linear';
            %--------------------------------------------------------------------------
            params = updateParams(params,varargin);
            % calc how the shape will be moved
            deltaPosition = theta(:) - obj.centerCoorOG(1:numel(theta));
            % do domain expansino according to bin
%             domainParams = calcMinMaxFromMeshData(domains);
            
            %             for ii = 1:numel(domains)
            %                 myArg = num2cell(domainParams(ii,:).*[obj.downSample(ii) obj.downSample(ii) obj.downSample(ii)]);
            %                 domains{ii} = linspace(myArg{:});
            %             end
            %
            %             [domains{:}] = ndgrid(domains{:});
            %
            for ii = 1:numel(domains)
                shiftdomains{ii} = domains{ii} - deltaPosition(ii);
            end
            obj.heartFunc = interpn(obj.domainsOG{:},obj.ndPatternOG,shiftdomains{:},params.interpMethod);
            obj.heartFunc(isnan(obj.heartFunc)) = 0;
            obj.newDomains = domains;
            heartFunc = obj.heartFunc;
            lambdas = heartFunc;
            %             lambdas = NDbinData(obj.heartFunc,obj.downSample);
        end
        
        function [gradLambdas,hessLambdas] = getDerivatives(obj,maxThetas)
            % need to be in a cube the data to calc gradients and stuff.
            
            % if linear domain and data
            isTheDataLinear = sum(cellfun(@(x) any(size(x)==1),obj.newDomains)) > 1;
            if  isTheDataLinear
                [useThisHeart,linearIndices] = convertLinearDomainToND(obj.newDomains,obj.heartFunc);
                useThisDomain = genMeshFromData(useThisHeart);
            else
                useThisHeart = obj.heartFunc;
                useThisDomain = obj.newDomains;
            end
            
            switch nargout
                case {1 0}
                    gradLambdas = NDgradientAndHessian(useThisHeart,useThisDomain);
                    gradLambdas(~maxThetas) = {0};
                    if isTheDataLinear
                        gradLambdas = cellfunNonUniformOutput(@(x) x(linearIndices),gradLambdas);
                        gradLambdas = isNaN2Zero(gradLambdas);
                    end
                case 2
                    [gradLambdas,hessLambdas] = NDgradientAndHessian(useThisHeart,useThisDomain);
                    hessianIndices = maxThetas(:)*maxThetas(:)';
                    hessLambdas(~hessianIndices) = {0};
                    gradLambdas(~maxThetas) = {0};
                    if isTheDataLinear
                        gradLambdas = cellfunNonUniformOutput(@(x) x(linearIndices),gradLambdas);
                        hessLambdas = cellfunNonUniformOutput(@(x) x(linearIndices),hessLambdas);
                    end
                    gradLambdas = isNaN2Zero(gradLambdas);
                    hessLambdas = isNaN2Zero(hessLambdas);
                    %                     hessLambdas = cellfunNonUniformOutput(@(x) NDbinData(x,obj.downSample),hessLambdas);
                otherwise
                    error('number of arguments out is not 1 or 2');
            end
            %             gradLambdas = cellfunNonUniformOutput(@(x) NDbinData(x,obj.downSample),gradLambdas);
        end
    end
end

