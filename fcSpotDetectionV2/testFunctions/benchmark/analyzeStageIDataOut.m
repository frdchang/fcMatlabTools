function [  ] = analyzeStageIDataOut( benchStruct,conditionFunc,field,varargin )
%ANALYZESTAGEIDATAOUT output data
%--parameters--------------------------------------------------------------
params.numDataPoints    = 100;
params.zProjFunc        = @xyMaxProjND;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


conditionFunc = func2str(conditionFunc);

if ~isfield(benchStruct,conditionFunc)
    error(['need to run ' conditionFunc ' directFitting bench']);
end

[ ~,saveFolder ] = genProcessedPathForBench(benchStruct,'analyzeStageIDataOut');
saveFolder = [saveFolder filesep 'func_' conditionFunc filesep 'field_' field];
makeDIR(saveFolder);


conditions              = benchStruct.(conditionFunc);
% stage I analysis only applies to distance = 0
sizeAB                  = [size(conditions,1) size(conditions,2)];
dd = 1;

close all;

disp('analyzeStageI(): extracting data');

testCond = getFirstNonEmptyCellContent(conditions);
if isfield(testCond,conditionFunc)
    numStuff = numel(testCond.(conditionFunc));
else
    numStuff =numel(testCond.(field));
end
numDataPoints = min([params.numDataPoints,numStuff]);
setupParForProgress(numDataPoints);

for ii = 1:numDataPoints
    % generate the montage
    collectImages = cell(sizeAB);
    for aa = 1:sizeAB(1)
        for bb = 1:sizeAB(2)
            if isfield(conditions{aa,bb,dd},conditionFunc)
                 currFuncConditions = conditions{aa,bb,dd}.(conditionFunc);
            else
                 currFuncConditions = conditions{aa,bb,dd}.(field);
            end
           
            currOutput = currFuncConditions{ii};
            try
            currOutput = load(currOutput);
            currOutput = currOutput.x;
            currOutput = currOutput.(field);
            
            catch
                currOutput = currOutput{1};
                currOutput = importStack(currOutput);
            end

            if iscell(currOutput)
                currOutput = currOutput{1};
            end
            collectImages{aa,bb} = currOutput;
        end
    end
    collectImages = cellfunNonUniformOutput(params.zProjFunc,collectImages);
    notNormed = cell2mat(collectImages)';
    exportSingleFitsStack([saveFolder filesep conditionFunc '-' field '-raw' filesep 'index' sprintf('%04d',ii)],notNormed);
    collectImages = cellfunNonUniformOutput(@norm0to1,collectImages);
    isNormed  = cell2mat(collectImages)';
    isNormed = norm2UINT255(isNormed);
    exportSingleTifStack([saveFolder filesep conditionFunc '-' field '-normed' filesep 'index' sprintf('%04d',ii)],isNormed);
    incrementParForProgress();
end

