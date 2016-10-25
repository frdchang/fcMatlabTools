function [ output_args ] = maxintensityproj4RGB( input_args )
%MAXINTENSITYPROJ4RGB Summary of this function goes here
%   Detailed explanation goes here

[maxgray, maxidx] = max(grayStack, [], 3);  %along the 3rd axis (Z)
nX = size(Stack,1);
nY = size(Stack,2);
[X, Y] = ndgrid( 1 : nX, 1 : nY );
MIP_R = Stack( sub2idx( size(Stack), X(:), Y(:), 1, maxidx(:) ) );
MIP_G = Stack( sub2idx( size(Stack), X(:), Y(:), 2, maxidx(:) ) );
MIP_B = Stack( sub2idx( size(Stack), X(:), Y(:), 3, maxidx(:) ) );
MIP = cat(3, reshape(MIP_R, nX, nY), reshape(MIP_G, nX, nY), reshape(MIP_B, nX, nY) );
image(MIP);

