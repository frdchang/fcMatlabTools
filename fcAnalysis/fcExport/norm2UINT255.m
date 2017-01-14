function normed = norm2UINT255(data)
%NORM2UINT255 Summary of this function goes here
%   Detailed explanation goes here

normed = uint8(norm0to1(data)*255);
end

