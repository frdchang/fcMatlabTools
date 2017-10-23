function [ output_args ] = plotTracks( fluorData,phaseData,tracks,index,varargin)
%PLOTTRACKS Summary of this function goes here
%   Detailed explanation goes here
%--parameters--------------------------------------------------------------
params.plotOnlyLongestTrack = true;
%--------------------------------------------------------------------------
params = updateParams(params,varargin);

surfParams = {'EdgeColor','none'};
axisParams = {'-','Color',[1,1,1],'LineWidth',2};
fluorData = norm0to1(fluorData);
[xL,yL,zL] = size(fluorData);
surfXY = maxintensityproj(fluorData,3);
surfXY = surfXY';
surfXZ = maxintensityproj(fluorData,1);

createMaxFigure();



hold on;
surfYZ = maxintensityproj(fluorData,2);
[sX,sY,sZ] = meshgrid(0:xL-1,0:yL-1,0);
surface(sX,sY,sZ,repmat(surfXY,1,1,3),surfParams{:});
hold on;
[sX,sY,sZ] = meshgrid(xL-1,0:yL-1,0:zL-1);
surface(reshape(sX,yL,zL),reshape(sY,yL,zL),reshape(sZ,yL,zL),repmat(surfXZ,1,1,3),surfParams{:});
[sX,sY,sZ] = meshgrid(yL-1,0:xL-1,0:zL-1);
surface(reshape(sY,xL,zL),reshape(sX,xL,zL),reshape(sZ,xL,zL),repmat(surfYZ,1,1,3),surfParams{:});

plot3([0,xL-1],[yL-1,yL-1],[zL-1,zL-1],axisParams{:});
plot3([xL-1,xL-1],[yL-1,yL-1],[0,zL-1],axisParams{:});
plot3([xL-1,xL-1],[0,yL-1],[zL-1,zL-1],axisParams{:});


plot3([xL-1,xL-1],[yL-1,yL-1],[zL-1,0],axisParams{:});
plot3([0,0],[yL-1,yL-1],[zL-1,0],axisParams{:});
plot3([xL-1,xL-1],[0,0],[zL-1,0],axisParams{:});

plot3([0,xL-1],[yL-1,yL-1],[0,0],axisParams{:});
plot3([xL-1,xL-1],[0,yL-1],[0,0],axisParams{:});

z           = phaseData';
[x,y]       = meshgrid(1:size(z,2),1:size(z,1));
planeimg    = z/max(z(z~=inf));
planeimg    = planeimg * (zL);
scaledimg   = round(norm0to1(z)*255);
colorimg    = ind2rgb(scaledimg,gray(256));
h = surf(x,y,double(planeimg),colorimg,'edgecolor','none' ,'facecolor','texture');
alpha(h,0.5);

numTracks = numel(tracks{1});

if params.plotOnlyLongestTrack
    trackL= cellfun(@(x) size(x,1),tracks);
    ii = find(trackL == max(trackL));
    firstChannel = tracks{1}{ii};
        idxs = firstChannel(:,1) <= index;
        if sum(firstChannel(:,1)==index) ~= 0

        timePoints = firstChannel(idxs,1);
        xs         = firstChannel(idxs,2)-0.5;
        ys         = firstChannel(idxs,3)-0.5;
        zs         = firstChannel(idxs,4)-0.5;
        if numel(timePoints) > 1
            hold on;
            clinep(xs,ys,zs,timePoints');
        end
        if ~isempty(timePoints)
            hold on;
            plot3(xs(end),ys(end),zs(end),'.r','markers',30);
            xx = xs(end);
            yy = ys(end);
            zz = zs(end);
            plot3([xx,xL],[yy,yy],[zz,zz],'-r','LineWidth',1);
            plot3([xx,xx],[yy,yL],[zz,zz],'-r','LineWidth',1);
            plot3([xx,xx],[yy,yy],[zz,0],'-r','LineWidth',1);
        end
        end
else
    for ii = 1:numTracks
        firstChannel = tracks{1}{ii};
        idxs = firstChannel(:,1) <= index;
        if sum(firstChannel(:,1)==index) == 0
            continue
        end
        timePoints = firstChannel(idxs,1);
        xs         = firstChannel(idxs,2)-0.5;
        ys         = firstChannel(idxs,3)-0.5;
        zs         = firstChannel(idxs,4)-0.5;
        if numel(timePoints) > 1
            hold on;
            clinep(xs,ys,zs,timePoints');
        end
        if ~isempty(timePoints)
            hold on;
            plot3(xs(end),ys(end),zs(end),'.r','markers',30);
            xx = xs(end);
            yy = ys(end);
            zz = zs(end);
            plot3([xx,xL],[yy,yy],[zz,zz],'-r','LineWidth',1);
            plot3([xx,xx],[yy,yL],[zz,zz],'-r','LineWidth',1);
            plot3([xx,xx],[yy,yy],[zz,0],'-r','LineWidth',1);
        end
    end
end


% if ~isempty(xs)
% xx = xs(end);
% yy = ys(end);
% zz = zs(end);
% plot3([xx,xL],[yy,yy],[zz,zz],'--w','LineWidth',1);
% plot3([xx,xx],[yy,yL],[zz,zz],'--w','LineWidth',1);
% plot3([xx,xx],[yy,yy],[zz,0],'--w','LineWidth',1);
% end


end

