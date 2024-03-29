function output = saveToProcessed_stageI(listOfFileInputPaths,funcOutput,myFunc,funcParamHash,varargin)
%SAVETOPROCESSED_STAGEI Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.saveFieldsAsImages     = {'A1','LLRatio','gradHessDOTLLRatio','negLoggammaSig','LLRatio3'};
params.rmFieldsForStruct    = {'A0'};
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

saveProcessedFileAt = genProcessedFileName(listOfFileInputPaths,myFunc,'paramHash',funcParamHash);

% delete fields we don't want
estimated = funcOutput{1};
listOfFields = fieldnames(estimated);

% save specified fields
output = {};
saveFields = intersect(listOfFields,params.saveFieldsAsImages);
for ii = 1:numel(saveFields)
    data = getfield(estimated,saveFields{ii});
    savePath = [returnFilePath(saveProcessedFileAt) filesep saveFields{ii} filesep saveFields{ii} '_' returnFileName(saveProcessedFileAt)];
    if iscell(data)
        channelData = regexp(listOfFileInputPaths,'\(([^)]+)\)','match');

        localOut = cell(numel(data),1);
        for jj = 1:numel(data)
            localOut{jj} = exportStack([savePath '_ch' channelData{jj}{1} ],data{jj});
        end
        output{end+1} = localOut;
    else
        output{end+1} = exportStack(savePath,data);
    end
end

saveFields{end+1} = 'mat';
% save the struct
savePath = [returnFilePath(saveProcessedFileAt) filesep 'mat' filesep 'mat_' returnFileName(saveProcessedFileAt)];
makeDIRforFilename(savePath);
estimated = rmfield(estimated,intersect(listOfFields,params.rmFieldsForStruct));
% save(savePath,'estimated','-v6');
savefast(savePath,'estimated');
output{end+1} = [savePath '.mat'];
listOutput = convertListToListofArguments(output);
output = table(listOutput{:},'VariableNames',saveFields);

end

