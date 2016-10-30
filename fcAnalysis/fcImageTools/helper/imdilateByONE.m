function [dilated] = imdilateByONE(data)
%IMDILATEBYONE Summary of this function goes here
%   Detailed explanation goes here

dilated = imdilate(data,ones(3*ones(1,ndims(data))));
end

