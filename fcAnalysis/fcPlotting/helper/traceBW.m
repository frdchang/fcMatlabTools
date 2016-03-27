function [B] = traceBW(nucVol,n,varargin)
%TRACEBW plots each trace of nucVol in the maximum projected dimension n

nucMask = maxintensityproj(nucVol,n);
B = bwboundaries(nucMask);



for i = 1:numel(B)
    cur_coors = B{i};
    hold on;
    if n ~= 1
        if isempty(varargin)
            plot(cur_coors(:,2),cur_coors(:,1),'-r');
        else
            plot(cur_coors(:,2),cur_coors(:,1),varargin{1});
        end
    else
        if isempty(varargin)
            plot(cur_coors(:,1),cur_coors(:,2),'-r');
        else
            plot(cur_coors(:,1),cur_coors(:,2),varargin{1});
        end
    end
end


end

