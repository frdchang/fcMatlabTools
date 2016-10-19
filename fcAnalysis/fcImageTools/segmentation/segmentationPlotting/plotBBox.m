function h = plotBBox(data,BBox)
%PLOTBBOX takes data and plots BBox

figure;
imshow(xyMaxProjND(data));
hold on;
rectangle('Position', BBox,...
	'EdgeColor','r', 'LineWidth', 3);
end

