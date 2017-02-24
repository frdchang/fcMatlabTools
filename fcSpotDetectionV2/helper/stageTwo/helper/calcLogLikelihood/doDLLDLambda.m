function [DLLDLambdas,D2LLDLambdas2] = doDLLDLambda(datas,bigLambdas,sigmasqs,DLLDLambdaFunc)
%DODLLDLAMBDA Summary of this function goes here
%   Detailed explanation goes here

DLLDLambdas = cell(size(datas));
D2LLDLambdas2 = cell(size(datas));

for ii = 1:numel(datas)
   DLLDLambdas{ii} =  DLLDLambdaFunc(datas{ii},bigLambdas{ii},sigmasqs{ii},1);
   D2LLDLambdas2{ii} =  DLLDLambdaFunc(datas{ii},bigLambdas{ii},sigmasqs{ii},2);
end


