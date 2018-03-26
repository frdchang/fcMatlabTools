function [mask,daThresh] = genMaskWOtsu(ndData)
%GENMASKWOTSU Summary of this function goes here
%   Detailed explanation goes here

[daThresh] = multithresh(double(ndData(:)));
mask = ndData > daThresh;
end

