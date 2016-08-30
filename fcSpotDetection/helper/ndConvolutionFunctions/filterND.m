function filtered = filterND(data,kernel)
%FILTERND Summary of this function goes here
%   Detailed explanation goes here

ogSize = size(data);
filtered = convFFTND(data,kernel);
filtered = unpadarray(filtered,ogSize);
end

