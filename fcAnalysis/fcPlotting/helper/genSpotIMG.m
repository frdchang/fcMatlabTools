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
if theta(3) < 1
   theta(3) = 1; 
end

if theta(3) > size(spotImg,3)
   theta(3) = size(spotImg,3); 
end
theta = num2cell(theta);

if all(cell2mat(theta) > 0) && all(cell2mat(theta) <= size(spotImg)) 
spotImg(theta{:}) = 1;
end


end

