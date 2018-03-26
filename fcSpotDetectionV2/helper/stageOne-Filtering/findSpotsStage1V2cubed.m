function [ estimated ] = findSpotsStage1V2cubed(data,spotKern,cameraVariance,varargin )
%FINDSPOTSSTAGE1V2CUBED Summary of this function goes here
%   Detailed explanation goes here

[estimated] = findSpotsStage1V2(data,spotKern,cameraVariance,varargin{:});
estimated.LLRatio3 = estimated.LLRatio.^3;

end

