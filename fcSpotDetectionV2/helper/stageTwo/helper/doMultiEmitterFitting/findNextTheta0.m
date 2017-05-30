function theta0 = findNextTheta0(carvedMask,domains,theta0,datas,estimated,camVar,Kmatrix,objKerns)
%FINDNEXTTHETA0 will update theta0 to find the next candidate theta0 by
%appending from the max LLR and from that xyz point find the greatest A1
%value.


bigLambdas = bigLambda(domains,theta0,'objKerns',objKerns);
errors = cellfunNonUniformOutput(@(x,y) x-y,datas,bigLambdas);
newEstimated = findSpotsStage1V2(errors,estimated.spotKern,camVar,'kMatrix',Kmatrix,'nonNegativity',false);
selectNegVals = cellfunNonUniformOutput(@(x) x<0,newEstimated.A1);
selectNegVals = sumCellContents(selectNegVals);
newEstimated.LLRatio(selectNegVals>0) = 0;

idxOfMax = find(max(newEstimated.LLRatio(carvedMask>0))==newEstimated.LLRatio(:));
A1valsAtIDX = cellfun(@(x) x(idxOfMax),newEstimated.A1);
B1valsAtIDX = cellfun(@(x) x(idxOfMax),newEstimated.B1);
idxOfMaxA1Channel = find(A1valsAtIDX==max(A1valsAtIDX));
coordinateOfMax = cellfun(@(x) x(idxOfMax),domains);


if isempty(theta0{idxOfMaxA1Channel+1}) || isscalar(theta0{idxOfMaxA1Channel+1})
    A1valsAtIDX = cellfun(@(x) x(idxOfMax),estimated.A1);
    B1valsAtIDX = cellfun(@(x) x(idxOfMax),estimated.B1);
    A1valAtMax = A1valsAtIDX(idxOfMaxA1Channel);
    B1valAtMax = B1valsAtIDX(idxOfMaxA1Channel);
    littleTheta = {objKerns{idxOfMaxA1Channel},[A1valAtMax coordinateOfMax]};
    theta0{idxOfMaxA1Channel+1} = {littleTheta, {B1valAtMax}};
else
    A1valAtMax = A1valsAtIDX(idxOfMaxA1Channel);
%     B1valAtMax = B1valsAtIDX(idxOfMaxA1Channel);
    littleTheta = {objKerns{idxOfMaxA1Channel},[A1valAtMax coordinateOfMax]};
    theta0{idxOfMaxA1Channel+1} = {littleTheta, theta0{idxOfMaxA1Channel+1}{:}};
end



% idxOfMax = find(max(newEstimated.LLRatio(carvedMask>0))==newEstimated.LLRatio(:));
% A1valsAtIDX = cellfun(@(x) x(idxOfMax),newEstimated.A1);
% B1valsAtIDX = cellfun(@(x) x(idxOfMax),newEstimated.B1);
% idxOfMaxChannel = find(A1valsAtIDX==max(A1valsAtIDX));
% coordinateOfMax = cellfun(@(x) x(idxOfMax),domains);
% A1valAtMax = A1valsAtIDX(idxOfMaxChannel);
% B1valAtMax = B1valsAtIDX(idxOfMaxChannel);
%
% % update theta with new spot information
% littleTheta = {objKerns{idxOfMaxChannel},[A1valAtMax coordinateOfMax]};
% % do i update the bkgnd
% if isempty(theta0{idxOfMaxChannel+1}) || isscalar(theta0{idxOfMaxChannel+1})
%     theta0{idxOfMaxChannel+1} = {{B1valAtMax}};
% end
%
% theta0{idxOfMaxChannel+1} = {littleTheta, theta0{idxOfMaxChannel+1}{:}};
%
% end
