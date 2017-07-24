function [] = mytool( data )
%MYTOOL Summary of this function goes here
%   Detailed explanation goes here

data = xyMaxProjND(data);

imtool(data,'InitialMagnification','adaptive','DisplayRange',[min(data(:)) max(data(:))]);
end

