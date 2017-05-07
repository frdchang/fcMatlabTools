function [] = processBenchMarkStageI(benchConditionsType1,myFunc,varargin)
%PROCESSBENCHMARK will process benchmark with myFunc that is a filter, ie.
% stageI

%--parameters--------------------------------------------------------------
params.default1     = 1;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

sizeBench = size(benchConditionsType1);

for ai = 1:sizeBench(1)
    for bi = 1:sizeBench(2)
        fileList = benchConditionsType1{ai,bi}.fileList;
        
    end
end


