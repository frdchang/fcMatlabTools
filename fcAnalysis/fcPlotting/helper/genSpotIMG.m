function [ spotImg ] = genSpotIMG( singleSpotTheta,sizeDatas,upRezFactor)
%GENSPOTIMG Summary of this function goes here
%   Detailed explanation goes here
spotImg = zeros(sizeDatas.*upRezFactor);

if isempty(singleSpotTheta)
    return;
end

if iscell(singleSpotTheta)
   singleSpotTheta = singleSpotTheta{1}; 
end
theta = singleSpotTheta.*upRezFactor;
theta = round(theta);
theta = num2cell(theta);
spotImg(theta{:}) = 1;
end

