function [ output_args ] = checkCramerRaoBound(statHolder,conditionText)
%CHECKCRAMERRAOBOUND Summary of this function goes here
goodStats = ~findEmptyCells(statHolder);
statHolderGood = statHolder(goodStats);
totalMLEs = sum(cellfun(@(x) numel(x),statHolderGood));
sizeMLE = numel([statHolderGood{1}{1}.thetaMLE{:}]);
MLEholder = zeros(totalMLEs,sizeMLE);
VARholder = cell(totalMLEs,1);
LLholder  = zeros(totalMLEs,1);
index = 1;
for ii = 1:numel(statHolderGood)
    currStat = statHolderGood{ii};
    for jj = 1:numel(currStat)
        currMLEstat = currStat{jj};
        if ~ischar(currMLEstat.thetaMLE)
            MLEholder(index,:) = [currMLEstat.thetaMLE{:}];
            VARholder{index} = currMLEstat.thetaVar;
            LLholder(index) = currMLEstat.logLike;
            index = index+1;
        end
    end
end

MLEholder(index:end,:) = [];
VARholder(index:end) = [];
LLholder(index:end) = [];

end