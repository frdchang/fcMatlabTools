function [ buildMaxThetas ] = newtonRaphsonBuild(buildMaxThetas)
%NEWTONRAPHSONBUILD converts all the gradient flags = 1 to 2 for newton

for ii = 1:numel(buildMaxThetas)
    if iscell(buildMaxThetas{ii})
        for jj = 1:numel( buildMaxThetas{ii})
            buildMaxThetas{ii}{jj}(buildMaxThetas{ii}{jj}==1) = 2;
        end
    else
        buildMaxThetas{ii}(buildMaxThetas{ii}==1)=2;
    end
    
end


