function [ combined ] = combineViews( varargin)
%COMBINEVIEWS given a list of inputs will combine them

numChans = numel(varargin);

% combine first view
firstView = cell(numChans,1);

for ii = 1:numChans
   firstView{ii} = varargin{ii}{1};
end
% combine second view
secondView = cell(numChans,1);

for ii = 1:numChans
   secondView{ii} = varargin{ii}{2};
end
% combine third view
thirdView = cell(numChans,1);

for ii = 1:numChans
   thirdView{ii} = varargin{ii}{3};
end

firstAndSecond = cellfunNonUniformOutput(@(x,y) cat(2,x,y),firstView,secondView);

combined = cellfunNonUniformOutput(@(x,y) genMontage({x,y},'border',0),firstAndSecond,thirdView);
combined = cat(2,combined{:});
end

