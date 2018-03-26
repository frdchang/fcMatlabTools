function [output] = uniqueFP(data,precision)
%UN Summary of this function goes here
%   Detailed explanation goes here
data = round2(data,precision);
output = unique(data);
end

