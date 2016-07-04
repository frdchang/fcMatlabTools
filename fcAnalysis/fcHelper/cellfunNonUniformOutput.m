function output = cellfunNonUniformOutput(func,cellarray)
%CELLFUNNONUNIFORMOUTPUT Summary of this function goes here
%   Detailed explanation goes here

output = cellfun(func,cellarray,'UniformOutput',false);
end

