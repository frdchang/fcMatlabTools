function [h,analysis] = analyzeStageII( benchStruct )
%ANALYZESTAGEII will analyze stage ii benchStruct

if ~isfield(benchStruct,'MLEbyIterationV2')
    error('need to run STage ii bench');
end

stageIIconds = benchStruct.MLEbyIterationV2;
numConds     = numel(stageIIconds);
Kmatrix      = benchStruct.Kmatrix;
analysis     = cell(size(stageIIconds));
for ii = 1:numConds
    if isempty(stageIIconds{ii})
        % analysis was not done,e.g. when A=0
    else
        currA        = stageIIconds{ii}.A;
        currB        = stageIIconds{ii}.B;
        currD        = stageIIconds{ii}.D;
        display(['A:' num2str(currA) ' B:' num2str(currB) ' D:' num2str(currD) ' i:' num2str(ii) ' of ' num2str(numConds)]);
        
        states       = stageIIconds{ii}.state;
        trueTheta    = flattenTheta0s(stageIIconds{ii}.bigTheta);
        numSamples   = numel(states);
        
        trueTheta(1:numel(Kmatrix)) = [];
        thetaHolder  = zeros(numel(trueTheta),numSamples);
        LLPPHolder   = zeros(numSamples,1);
        
        for jj = 1:numSamples
            currStates           = states{jj};
            LLPPHolder(jj)       = currStates.logLikePP;
            currMLE              = flattenTheta0s(currStates.thetaMLEs);
            currMLE(1:numel(Kmatrix)) = [];
            thetaHolder(:,jj)    = currMLE;
        end
        analysis{ii}.thetaHolder = thetaHolder;
        analysis{ii}.LLPPHolder  = LLPPHolder;
        analysis{ii}.trueTheta   = trueTheta;
    end
end

% asdf

display('fred');s



