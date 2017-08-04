function [ rgb ] = myOverlay(A,BW,varargin)
%MYOVERLAY this is like imoverlay but colors according to the index of the
%BW mask index by 'lines' colormap.  so 1 = green, 2 = blue etc...
%--parameters--------------------------------------------------------------
params.nDistguishedColors     = 4;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


myCmap = distinguishable_colors(params.nDistguishedColors,[0 0 0]);
myCmap(3:-1:2,:) = myCmap(2:3,:);
% myCmap = linspecer(params.nDistguishedColors);
uniqueNums = unique(BW);
uniqueNums = uniqueNums( uniqueNums>0);
if isempty(uniqueNums)
    rgb = A;
else
    uniqueNums = uniqueNums(1);
    if uniqueNums > params.nDistguishedColors
       uniqueNums =  params.nDistguishedColors;
    end
    rgb = imoverlay(A,BW,myCmap(uniqueNums,:));
end


end

