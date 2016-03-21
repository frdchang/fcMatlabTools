function A1_MLE = calcMLEOfPatch_PoissPoiss(data,sigmasq,A1,B1,B0,gaussSigmas)
%CALCMLEOFPATCH_POISSPOISS Summary of this function goes here
%   Detailed explanation goes here

centerCoor = round(size(data)/2);
centerCoor = num2cell(centerCoor);
[x,y,z] = meshgrid(1:size(data,1),1:size(data,2),1:size(data,3));

dataI = data > -Inf;

state = MLEbyIteration(data(dataI),num2cell([centerCoor{:} gaussSigmas(:)' A1(centerCoor{:}) B1(centerCoor{:})]),sigmasq(dataI),{x(dataI),y(dataI),z(dataI)},2,'maxThetas',[0 0 0 0 0 0 1 1],'numStepsNR',2,'doPloteveryN',inf);
A1_MLE = state.thetaMLE{7};
end

