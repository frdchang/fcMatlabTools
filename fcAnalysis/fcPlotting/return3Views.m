function [views,theViews] = return3Views(stack,varargin)
%RETURN3VIEWS takes a 3D stack and returns an image with a montaged maximum
%projection of 3 Views.  also this will uprez the stack by 'bicubic'
%interpolation so as to see features better.

%--parameters--------------------------------------------------------------
params.spotParams       = [];
params.zMulti           = 3;
params.upRezFactor      = 1;
params.border           = 1;
params.bkgndGrey        = 0.2;
params.phaseAppend      = [];
params.spotColor1       = [1 0 0];
params.spotColor2ormore = [0 1 0];
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

stack = double(stack);
[xL,yL,zL] = size(stack);

view1 = maxintensityproj(stack,3);
view2 = maxintensityproj(stack,2);
view3 = maxintensityproj(stack,1);

% uprez z perspectives
view2 = imresize(view2,[xL,zL*params.zMulti],'Method','nearest');
view3 = imresize(view3,[yL,zL*params.zMulti],'Method','nearest')';

[xL1,yL1] = size(view1);
[xL2,yL2] = size(view2);
[xL3,yL3] = size(view3);

view1 = bw2rgb(view1);
view2 = bw2rgb(view2);
view3 = bw2rgb(view3);

% append spots if it is provided, so make it RGB grayscale and add red dots
if ~isempty(params.spotParams)
    
    thetaMLEs = grabThetasFromSpotParams(params.spotParams);
    % plotting spots on image axis have x and y values flipped
    numSpots = size(thetaMLEs,1);
    yCoors = round(thetaMLEs(:,1));
    xCoors = round(thetaMLEs(:,2));
    zCoors = round(thetaMLEs(:,3));
    xCoors = imposeBounds(xCoors,1,xL);
    yCoors = imposeBounds(yCoors,1,yL);
    zCoors = imposeBounds(zCoors,1,zL);
    if numSpots == 1
        spotColor = params.spotColor1;
    else
        spotColor = params.spotColor2ormore;
    end
    for ii = 1:numSpots
        if xCoors(ii) <= xL1 && yCoors(ii) <= yL1 && xCoors(ii) >= 1 && yCoors(ii) >= 1
        view1(xCoors(ii),yCoors(ii),:) = reshape(spotColor,1,1,3);
        end
    end
    for ii = 1:numSpots
        if xCoors(ii) <= xL2 && zCoors(ii)*params.zMulti <=yL2 && xCoors(ii) >= 1 && zCoors(ii)*params.zMulti >= 1
        view2(xCoors(ii),zCoors(ii)*params.zMulti,:) = reshape(spotColor,1,1,3);
        end
    end
    for ii = 1:numSpots
        if zCoors(ii)*params.zMulti <= xL3 && yCoors(ii) <=yL3 && zCoors(ii)*params.zMulti >= 1 && yCoors(ii) >= 1
        view3(zCoors(ii)*params.zMulti,yCoors(ii),:) = reshape(spotColor,1,1,3);
        end
    end
end


views = params.bkgndGrey*ones(xL + zL*params.zMulti+params.border,yL + zL*params.zMulti+params.border,3);
views(1:xL1,1:yL1,:) = view1;
views(xL1+params.border+1:end,1:yL1,:) = view3;
views(1:xL1,yL1+params.border+1:end,:) = view2;


% generate the appending phase channel if it exists
if ~isempty(params.phaseAppend)
    phaseAppend = xyMaxProjND(params.phaseAppend);
    phaseAppending = params.bkgndGrey*ones(size(phaseAppend,1),size(views,2));
    phaseAppending(1:size(phaseAppend,1),1:size(phaseAppend,2)) = phaseAppend;
    phaseAppending = bw2rgb(phaseAppending);
    offset = params.bkgndGrey*ones(params.border,size(views,2));
    offset = bw2rgb(offset);
    views = cat(1,phaseAppending,offset,views);
    theViews.phase = bw2rgb(phaseAppend);
else
    theViews.phase = []; 
end


if params.upRezFactor ~= 1
    views = imresize(views,size(views)*params.upRezFactor,'Method','bilinear');
end

theViews.view1 = view1;
theViews.view2 = view2;
theViews.view3 = view3;


