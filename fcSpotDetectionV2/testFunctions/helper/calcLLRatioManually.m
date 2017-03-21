function [modelSq1,modelSq2,LL1,LL1SansDataSq,LLRatio] = calcLLRatioManually(data,A,B,B0,spotKern)
%CALCLLRATIOMANUALLY Summary of this function goes here
%   Detailed explanation goes here

myModel = A*spotKern + B;
myModel2 = B0*ones(size(spotKern));
modelSq1 = sum(myModel(:).^2);
modelSq2 = sum(myModel2(:).^2);
LL1 = -sum((myModel(:)-data(:)).^2);
LL1SansDataSq = LL1 + sum(data(:).^2);
LL2 = -sum((myModel2(:)-data(:)).^2);
LL2SansDataSq = LL2 + sum(data(:).^2);
LLRatio = LL1 - LL2;
end

