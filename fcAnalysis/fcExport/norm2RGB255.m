function [ rgb255 ] = norm2RGB255( data )
%NORM2RGB255 convert data to rgb255.

data = norm0to1(data);
data = repmat(data,1,1,3);

end

