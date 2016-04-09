function [hdomed,bkgnd] = hdome(data,h,varargin)
%HDOME applies the hdome reconstruction to data.  this function differs
% from matlab imhmax or imhmin in that this function maintains the
% correctness of the transformation at the data edges.

bkgnd = imreconstruct((data-h),data,varargin{:});
hdomed = data-bkgnd;

