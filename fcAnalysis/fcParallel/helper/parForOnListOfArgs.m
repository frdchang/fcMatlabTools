function [ outputs ] = parForOnListOfArgs(myFunc,listOflistOfArguments )
%PARFORONLISTOFARGS Summary of this function goes here
%   Detailed explanation goes here
numArgs = numel(listOflistOfArguments);
outputs = cell(numArgs,1);
disp(numArgs);
disp(listOflistOfArguments);
parfor ii = 1:numel(listOflistOfArguments)
    disp(listOflistOfArguments{ii});
    outputs{ii} = myFunc(listOflistOfArguments{ii});
end

end



