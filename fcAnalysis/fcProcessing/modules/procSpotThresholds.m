function [ spotThresholds ] = procSpotThresholds(stageIIOutputs,varargin)
%PROCSPOTTHRESHOLDS Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.threshField     = 'logLikePP';
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

MLEs = loadTheSpots(stageIIOutputs.outputFiles.pathToStageIIMLEs);

MLEs = flattenCellArray(MLEs);

LLs         = cellfun(@(x) [x.(params.threshField)],MLEs,'uni',false);
states      = cellfun(@(x) {x.stateOfStep},MLEs,'uni',false);
states      = cellfun(@(x) contains(x,'ok'),states,'uni',false);
LLRatios    = cellfun(@(x) x - x(1),LLs,'uni',false);

LLRatios    = cellfun(@(x) x',LLRatios,'uni',false);
states      = cellfun(@(x) x',states,'uni',false);

sizes = cellfun(@numel,LLRatios);
idx = sizes == max(sizes);
LLRatios(~idx) = [];
states(~idx) = [];

LLRatios = cell2mat(LLRatios);
states   = cell2mat(states);

numFits = size(LLRatios,1);

figure;
numSpots = cell(numFits-1,1);
for ii = 2:numFits
    currFit = LLRatios(ii,:);
    currOk  = states(ii,:);
    okFits  = currFit(currOk);
    hold on;
    h = histogram(okFits);
    h.Normalization = 'pdf';
    numSpots{ii-1} = num2str(ii-1);
end
xlabel(params.threshField);
legend(numSpots);

thresholds = cell(numFits-1,1);
for ii = 1:numFits-1
    thresholds{ii} = input(['type in ' num2str(ii) 'nth threshold: ']);
end

thresholds = cell2mat(thresholds);
spotThresholds.thresholds = thresholds;
spotThresholds = procSaver(stageIIOutputs,spotThresholds);


end

function spots = loadTheSpots(files)
spots = cell(numel(files),1);
for ii = 1:numel(files)
    temp = load(files{ii});
    spots{ii} = temp.stageIIMLEs;
end
end