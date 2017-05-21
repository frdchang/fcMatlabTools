function [ estimated ] = llrpowered(data,spotKern,cameraVariance,varargin )
%LLR Summary of this function goes here
%   Detailed explanation goes here
[estimated] = findSpotsStage1V2(data,spotKern,cameraVariance,varargin{:});

estimated.LLRatio2 = estimated.LLRatio.^2;
estimated.LLRatio3 = estimated.LLRatio.^3;
estimated.LLRatio4 = estimated.LLRatio.^4;
estimated.LLRatio5 = estimated.LLRatio.^5;
estimated.LLRatio20 = estimated.LLRatio.^20;
end

