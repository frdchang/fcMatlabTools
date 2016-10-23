function [rgbGrayData] = bw2rgb(data2D)
%BW2RGB Summary of this function goes here
%   Detailed explanation goes here

rgbGrayData = cat(3,data2D,data2D,data2D);
end

