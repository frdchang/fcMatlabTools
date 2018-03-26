function output = saveToProcessed_passThru(filePathOfInput,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_PASSTHRU Summary of this function goes here
%   Detailed explanation goes here

output = funcOutput{:};
output = table({output},'VariableNames',{'passThru'});
end

