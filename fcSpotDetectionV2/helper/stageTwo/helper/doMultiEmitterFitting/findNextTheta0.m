function theta0 = findNextTheta0(domains,theta0,datas,estimated,camVars,kMatrix)
%FINDNEXTTHETA0 will update theta0 to find the next candidate theta0 by
%appending from the max LLR and from that xyz point find the greatest A1
%value.


bigLambdas = bigLambda(domains,theta0);
errors = cellfunNonUniformOutput(@(x,y) x-y,datas,bigLambdas);
newEstimated = findSpotsStage1V2(errors,estimated.spotKern,camVars,'kMatrix',kMatrix);

idxOfMax = find(max(newEstimated.LLRatio(:))==newEstimated.LLRatio);
A1valsAtIDX = cellfun(@(x) x(idxOfMax),newEstimated.A1);
idxOfMaxChannel = find(A1valsAtIDX==max(A1valsAtIDX));
end
