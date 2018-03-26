function [ trueOrFalse ] = isSameThetaStructure(masterTheta,slaveTheta )
%ISSAMETHETASTRUCTURE will check if the structure of slaveTheta is the same
%as masterTheta.  this is to make sure they have the same number of spots
%etc.
trueOrFalse = true;
if ~isequal(masterTheta{1},slaveTheta{1})
   trueOrFalse = false;
   return;
end

if numel(masterTheta{2})~= numel(slaveTheta{2})
    trueOrFalse = false;
    return;
end

for ii = 2:numel(masterTheta)
    for jj = 1:numel(masterTheta{ii})
       if isobject(masterTheta{ii}{jj}{1})
           if ~isobject(slaveTheta{ii}{jj}{1})
              trueOrFalse = false; 
           end
       else
           if ~isscalar(masterTheta{ii}{jj}{1})
              trueOrFalse = false; 
           end
       end
    end
end

end

