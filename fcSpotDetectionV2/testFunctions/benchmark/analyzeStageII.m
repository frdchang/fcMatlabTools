function [h] = analyzeStageII( benchStruct )
%ANALYZESTAGEII will analyze stage ii benchStruct

if ~isfield(benchStruct,'MLEbyIterationV2')
    error('need to run STage ii bench');
end

stageIIconds = benchStruct.MLEbyIterationV2;
numConds     = numel(stageIIconds);

for ii = 1:numConds
   if isempty(stageIIconds{ii})
       
   else
       currA = stageIIconds{ii}.A;
       currB = stageIIconds{ii}.B;
       currD = stageIIconds{ii}.D;
       states     = stageIIconds{ii}.state;
       numSamples = numel(states);
   end
end



