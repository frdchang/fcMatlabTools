function [A1_MLE,B1_MLE,B0_MLE,LLRatio] = calcMLEOfPatch_PoissPoiss(data,sigmasq,A1,B1,B0,gaussKern,gaussSigmas)
%CALCMLEOFPATCH_POISSPOISS calculates the MLE of parameters given a patch
% with the shape/psf/gaussian centered at the center.  this function
% assumes any data values assigned to be -inf to be not used for the
% calculation.  

numIter = 2;

centerCoor = round(size(data)/2);
centerCoor = num2cell(centerCoor);
[x,y,z] = meshgrid(1:size(data,1),1:size(data,2),1:size(data,3));

% only get valid dataparts
dataI = data > -Inf;
subData = data(dataI);
subX = x(dataI);
subY = y(dataI);
subZ = z(dataI);
subSigmaSq = sigmasq(dataI);

% solve 1 spot model by MLE
state1 = MLEbyIteration(subData,num2cell([centerCoor{:} gaussSigmas(:)' A1(centerCoor{:}) B1(centerCoor{:})]),subSigmaSq,{subX,subY,subZ},2,'maxThetas',[0 0 0 0 0 0 1 1],'numStepsNR',numIter,'doPloteveryN',inf);
A1_MLE = state1.thetaMLE{7};
B1_MLE = state1.thetaMLE{8};

% solve 0 spot model by MLE
state0 = MLEbyIteration(subData,num2cell([centerCoor{:} gaussSigmas(:)' 0 B0(centerCoor{:})]),subSigmaSq,{subX,subY,subZ},2,'maxThetas',[0 0 0 0 0 0 0 1],'numStepsNR',numIter,'doPloteveryN',inf);
B0_MLE = state0.thetaMLE{8};

% calculate LLRatio
% get shape data that MLEbyIteration used
% shapeData = state1.lambdaModel(num2cell([centerCoor{:} gaussSigmas(:)' 1 0]),{subX,subY,subZ},[0 0 0 0 0 0 0 1],0);
LLRatio = calcLogLikeOfPatch_PoissPoiss(subData,subSigmaSq,A1_MLE,B1_MLE,B0_MLE,gaussKern);
end

