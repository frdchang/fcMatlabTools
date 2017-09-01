function [ outputs ] = parForOnListOfArgs(myFunc,listOflistOfArguments )
%PARFORONLISTOFARGS Summary of this function goes here
%   Detailed explanation goes here

outputs = cell(numel(listOflistOfArguments),1);
parfor ii = 1:numel(listOflistOfArguments)
    outputs{ii} = myFunc(listOflistOfArguments{ii}{:});
end

end



