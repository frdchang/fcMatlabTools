function [ theta0 ] = setFirstTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns)
%SETFIRSTTHETA0 Summary of this function goes here
%   Detailed explanation goes here
bigLambdas = bigLambda(domains,theta0);
errors = cellfunNonUniformOutput(@(x,y) x-y,datas,bigLambdas);
newEstimated = findSpotsStage1V2(errors,estimated.spotKern,camVar,'kMatrix',Kmatrix);

idxOfMax = find(max(newEstimated.LLRatio(carvedMask>0))==newEstimated.LLRatio(:));
B0valsAtIDX = cellfun(@(x) x(idxOfMax),newEstimated.A1);

for ii = 1:numel(datas)
    theta0{ii+1} = {{B0valsAtIDX(ii)}};
end
    


