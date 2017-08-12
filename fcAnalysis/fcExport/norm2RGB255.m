function [ rgb255 ] = norm2RGB255( data )
%NORM2RGB255 convert data to rgb255.

rgb255 = norm0to1(data);
rgb255 = repmat(rgb255,1,1,3);

end

