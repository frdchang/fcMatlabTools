classdef myNumericPattern
    properties
        ndPattern
        domains
        centerCoor
        numDims
    end
    
    methods
        function obj = myNumericPattern(varargin)
        % myNumericPattern
            if nargin ==1
                obj.ndPattern    = varargin{1};
            end
            obj.domains         = genMeshFromData(obj.ndPattern);
            obj.centerCoor      = round(size(obj.ndPattern)/2);
            obj.numDims         = numel(obj.centerCoor);
        end
        
        function shiftedPattern = movePattern(obj,newDomain,newPosition,varargin)
        % movePattern
            
            %--parameters--------------------------------------------------------------
            params.interpMethod     = 'linear';
            %--------------------------------------------------------------------------
            params = updateParams(params,varargin);
            
            
            deltaPosition = newPosition - obj.centerCoor(1:numel(newPosition));
            for ii = 1:numel(newDomain)
                newDomain{ii} = newDomain{ii} - deltaPosition(ii);
            end
            shiftedPattern = interpn(obj.domains{:},obj.ndPattern,newDomain{:},params.interpMethod);
        end
    end
end
