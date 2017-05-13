function [ myCells ] = deleteEmptyCells( myCells )
%DELETEEMPTYCELLS Summary of this function goes here
%   Detailed explanation goes here

idx = findEmptyCells(myCells);
myCells(idx) = [];
end

