function theta0 = findNextTheta0(domains,theta0,datas,estimated,camVar,Kmatrix,objKerns)
%FINDNEXTTHETA0 will update theta0 to find the next candidate theta0 by
%appending from the max LLR and from that xyz point find the greatest A1
%value.


bigLambdas = bigLambda(domains,theta0);
errors = cellfunNonUniformOutput(@(x,y) x-y,datas,bigLambdas);
newEstimated = findSpotsStage1V2(errors,estimated.spotKern,camVar,'kMatrix',Kmatrix);

idxOfMax = find(max(newEstimated.LLRatio(:))==newEstimated.LLRatio);
A1valsAtIDX = cellfun(@(x) x(idxOfMax),newEstimated.A1);
B1valsAtIDX = cellfun(@(x) x(idxOfMax),newEstimated.B1);
idxOfMaxChannel = find(A1valsAtIDX==max(A1valsAtIDX));
coordinateOfMax = ind2subND(size(datas{1}),idxOfMax);
A1valAtMax = A1valsAtIDX(idxOfMaxChannel);
B1valAtMax = B1valsAtIDX(idxOfMaxChannel);

% update theta with new spot information
littleTheta = {objKerns{idxOfMaxChannel},[A1valAtMax coordinateOfMax{:}]};

if isempty(theta0{idxOfMaxChannel+1})
    theta0{idxOfMaxChannel+1} = {B1valAtMax};
end

theta0{idxOfMaxChannel+1} = {littleTheta, theta0{idxOfMaxChannel+1}};

end

