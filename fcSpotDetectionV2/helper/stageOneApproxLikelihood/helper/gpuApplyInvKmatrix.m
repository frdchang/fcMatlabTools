function cellDataIn = gpuApplyInvKmatrix(kMatrix,cellDataIn)
%GPUAPPLYINVKMATRIX will take kmatrix and solve the system given varargin
%datasets.  should be gpu friendly.

numDatasets     = numel(cellDataIn);
numElInADataset = numel(cellDataIn{1});
sizeADataset    = size(cellDataIn{1});

cellDataIn = reshape([cellDataIn{:}],numElInADataset,numDatasets)';
cellDataIn = kMatrix \ cellDataIn;
cellDataIn = num2cell(cellDataIn,2);
cellDataIn = cellfunNonUniformOutput(@(x) reshape(x,sizeADataset),cellDataIn);

 
