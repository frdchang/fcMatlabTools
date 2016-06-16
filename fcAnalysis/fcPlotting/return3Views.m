function [views] = return3Views(stack,varargin)
%RETURN3VIEWS takes a 3D stack and returns an image with a montaged maximum
%projection of 3 Views.  also this will uprez the stack by 'bicubic'
%interpolation so as to see features better.
% varargin{1} = bkgndGrey
stack = double(stack);
% parameters
zMulti = 3;
upRezFactor =1;
border = 1;
bkgndGrey = min(stack(:));

nVargins = length(varargin);

if nVargins ==1
    bkgndGrey = varargin{1};
elseif nVargins ==2
    if ~isempty(varargin{1})
        bkgndGrey = varargin{1};
    end
    upRezFactor = varargin{2};
end

[xL,yL,zL] = size(stack);
views = zeros(xL+zMulti*zL+1,yL+zMulti*zL+1);
view1 = maxintensityproj(stack,3);
view2 = maxintensityproj(stack,2);
view3 = maxintensityproj(stack,1);

view1 = imresize(view1,[xL*upRezFactor,yL*upRezFactor],'Method','bicubic');

if upRezFactor ==1
    view2 = imresize(view2,[xL*upRezFactor,zL*zMulti],'Method','nearest');
    view3  = imresize(view3,[yL*upRezFactor,zL*zMulti],'Method','nearest')';
else
    view2 = imresize(view2,[xL*upRezFactor,zL*upRezFactor*zMulti],'Method','bicubic');
    view3  = imresize(view3,[yL*upRezFactor,zL*upRezFactor*zMulti],'Method','bicubic')';
end

[xL1,yL1] = size(view1);
[xL2,yL2] = size(view2);
[xL3,yL3] = size(view3);

views = bkgndGrey*ones(xL*upRezFactor + zL*upRezFactor*zMulti+border,yL*upRezFactor + zL*upRezFactor*zMulti+border);
views(1:xL1,1:yL1) = view1;
views(xL1+border+1:end,1:yL1) = view3;
views(1:xL1,yL1+border+1:end) = view2;
end

