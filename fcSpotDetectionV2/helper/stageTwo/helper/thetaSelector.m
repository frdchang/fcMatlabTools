function [selectorD,selectorD2] = thetaSelector(strategy)
%THETASELECTOR given a strategy this function well generate a logical
%output that will select the appropriate gradient and or hessian
%
% selectorD = {gradient strategy, newton strategy}
% selectorD2 = hessian logical for newton

% first argument is the Kmatrix

selectorD = strategy{1}(:);
for ii = 2:numel(strategy)
    selectorD = [selectorD(:) ;cell2mat(strategy{ii})'];
end

selectorD2 =  selectorD*selectorD';
selectorD2 = selectorD2 == 4;
selectorD = {selectorD==1,selectorD==2};
end

