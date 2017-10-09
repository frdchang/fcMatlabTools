function [ spotImg ] = genSpotIMG( singleSpotTheta,sizeDatas,upRezFactor)
%GENSPOTIMG Summary of this function goes here
%   Detailed explanation goes here
spotImg = zeros(sizeDatas.*upRezFactor);

if isempty(singleSpotTheta) 
    return;
end

if iscell(singleSpotTheta)
   singleSpotTheta = singleSpotTheta{1}; 
   if any(singleSpotTheta == 0)
      return; 
   end
end
theta = singleSpotTheta.*upRezFactor;
theta = round(theta);
theta = num2cell(theta);
if all(singleSpotTheta > 0) && all(singleSpotTheta <= sizeDatas) 
spotImg(theta{:}) = 1;
end
end

