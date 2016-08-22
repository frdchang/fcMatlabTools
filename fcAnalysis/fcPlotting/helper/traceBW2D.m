function [B] = traceBW2D(xyMask,varargin)
%TRACEBW plots each trace of nucVol in the maximum projected dimension n


B = bwboundaries(xyMask);



for i = 1:numel(B)
    cur_coors = B{i};
    hold on;

        if isempty(varargin)
            plot(cur_coors(:,2),cur_coors(:,1),'-r');
        else
            plot(cur_coors(:,2),cur_coors(:,1),varargin{1});
        end



end


end

