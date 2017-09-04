function [batchOutputs,runTimeBasket,counters] = sendChuncksByBatch(myFunc,listOflistOfArguments,varargin )
%SENDCHUNCKSBYBATCH will send work by chunks of listOflistOfArguments so as
%to limit batch overhead and master penalty.  the last chunk will simply be
% bigger


%--parameters--------------------------------------------------------------
params.workersPerChunk =1;
params.maxWorkers      = 256;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

% divide listOflistOfArguments into chunks
numChunks = floor(params.maxWorkers / (params.workersPerChunk + 1));
[M, N] = size(listOflistOfArguments);
if numel(listOflistOfArguments) < params.workersPerChunk
    chunkedlistOflistOfArguments = {listOflistOfArguments};
else
    chunkedlistOflistOfArguments = mat2cell(listOflistOfArguments, diff(round(linspace(0, M, numChunks+1))), N);
    chunkedlistOflistOfArguments = removeEmptyCells(chunkedlistOflistOfArguments);
end


numWorkers = min(params.workersPerChunk,numel(chunkedlistOflistOfArguments));
chunkHandler = @(x) parForOnListOfArgs(myFunc,x);
% send it off to batches
[batchOutputs,runTimeBasket,counters] = sendFuncsByBatch(chunkHandler,chunkedlistOflistOfArguments,numWorkers,varargin);

% concate outputs
batchOutputs = vertcat(batchOutputs{:});
batchOutputs = vertcat(batchOutputs{:});
end

