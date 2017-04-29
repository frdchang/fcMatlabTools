function [theta0s] = ensureBkndThetasPos(theta0s)
%BKGNDTHETAS Summary of this function goes here
%   Detailed explanation goes here


for ii = 2:numel(theta0s)
    if isscalar(theta0s{ii}{end}{1})
        if theta0s{ii}{end}{1} < 0
           theta0s{ii}{end}{1} = 0; 
        end
    end
end

