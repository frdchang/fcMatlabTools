function [ rgb ] = myOverlay(fluorViews,spotViews,varargin)
%MYOVERLAY 
%--parameters--------------------------------------------------------------
params.nDistguishedColors     = 4;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);


myCmap = distinguishable_colors(params.nDistguishedColors,[0 0 0]);
myCmap(3:-1:2,:) = myCmap(2:3,:);

if iscell(fluorViews)
    rgb = cell(size(fluorViews));
   for ii = 1:numel(fluorViews)
       rgb{ii} = cellfunNonUniformOutput(@(fluorViews,spotViews) imoverlay(fluorViews,spotViews,myCmap(ii,:)),fluorViews{ii},spotViews{ii});
   end
else
    rgb = imoverlay(fluorViews,spotViews,myCmap(1,:));
end
% myCmap = linspecer(params.nDistguishedColors);






% uniqueNums = unique(BW);
% uniqueNums = uniqueNums( uniqueNums>0);
% if isempty(uniqueNums)
%     rgb = A;
% else
%     uniqueNums = uniqueNums(1);
%     if uniqueNums > params.nDistguishedColors
%        uniqueNums =  params.nDistguishedColors;
%     end
%     rgb = imoverlay(A,BW,myCmap(uniqueNums,:));
% end
% 
% 
% end

