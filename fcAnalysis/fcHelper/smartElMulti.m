function [ output ] = smartElMulti( x,y )
%SMARTMULTI will do element wise multi if both are same size arrays
% if one is scalar then it will do simple multi

if isequal(size(x),size(y))
    output = x.*y;
else
    output = x*y;
end


