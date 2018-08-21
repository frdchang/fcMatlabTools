function [ theta0 ] = setFirstTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns)
%SETFIRSTTHETA0 Summary of this function goes here
%   Detailed explanation goes here
idxOfMax = find(max(estimated.LLRatio(carvedMask>0))==estimated.LLRatio(:),1,'first');
B0valsAtIDX = cellfun(@(x) x(idxOfMax),estimated.B0);

for ii = 1:numel(datas)
    theta0{ii+1} = {{B0valsAtIDX(ii)}};
end
    


