function [ rgbd ] = convertAll2RGBUINT8( cellData )
%CONVERTALL2RGBUINT8 Summary of this function goes here
%   Detailed explanation goes here
rgbd = ncellfun(@helper,cellData);

end

function input = helper(input)
if size(input,3) == 1
   input = repmat(input,1,1,3); 
end

end

