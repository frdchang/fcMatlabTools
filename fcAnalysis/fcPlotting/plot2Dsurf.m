function [] = plot2Dsurf(varargin)
%PLOT2DSURF Summary of this function goes here
%   Detailed explanation goes here

switch nargin
    case 1
        z = varargin{1};
        %         surf(double(z),'Facecolor','interp','EdgeColor','none','FaceLighting','phong');
        %         alpha(0.9);
        % the data that you want to plot as a 3D surface.
        [x,y] = meshgrid(1:size(z,2),1:size(z,1));
        
        % get the corners of the domain in which the data occurs.
        min_x = min(min(x));
        min_y = min(min(y));
        max_x = max(max(x));
        max_y = max(max(y));
        
        % the image data you want to show as a plane.
        planeimg = z;
        
        % scale image between [0, 255] in order to use a custom color map for it.
        minplaneimg = min(min(planeimg)); % find the minimum
        scaledimg = round(norm0to1(planeimg)*255);
        
        % convert the image to a true color image with the jet colormap.
        colorimg = ind2rgb(scaledimg,gray(256));
        
        % set hold on so we can show multiple plots / surfs in the figure.
        
        
        % do a normal surface plot.
        surf(x,y,double(z),colorimg,'edgecolor','none' ,'facecolor','texture');
        view(-46.5,40);
        
        % set a colormap for the surface
        
    case 2
        
        z = varargin{1};
        z2 = varargin{2};
        %         surf(double(z),'Facecolor','interp','EdgeColor','none','FaceLighting','phong');
        %         alpha(0.9);
        % the data that you want to plot as a 3D surface.
        [x,y] = meshgrid(1:size(z,2),1:size(z,1));
        
        % get the corners of the domain in which the data occurs.
        min_x = min(min(x));
        min_y = min(min(y));
        max_x = max(max(x));
        max_y = max(max(y));
        
        % the image data you want to show as a plane.
        planeimg = z;
        planeimg2 = norm0to1(z2);
        
        scaledimg = round(norm0to1(planeimg)*255);
        scaledimg2 = round(norm0to1(planeimg2)*255);        grayMap = gray(256);
        redMap = zeros(size(grayMap));
        greenMap = zeros(size(grayMap));
        redMap(:,1) = grayMap(:,1);
        greenMap(:,2) = grayMap(:,1);
        % convert the image to a true color image with the jet colormap.
        colorimg = ind2rgb(scaledimg,jet(256));
        colorimg2 = ind2rgb(scaledimg2,greenMap);
        % set hold on so we can show multiple plots / surfs in the figure.
        
        
        % do a normal surface plot.
        surf(x,y,double(planeimg),colorimg,'edgecolor','none' ,'facecolor','texture');
        hold on;
        
        imgzposition = -100000;
        
        % plot the image plane using surf.
        surf([min_x max_x],[min_y max_y],repmat(imgzposition, [2 2]),...
            colorimg2,'facecolor','texture')
        
        
        view(-46.5,40);
    otherwise
        
end

end

