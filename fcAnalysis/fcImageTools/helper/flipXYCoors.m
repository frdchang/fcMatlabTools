function data = flipXYCoors(data)
%FLIPXYCOORS image coors are different than row column coors, so this flips
%it.
if numel(data) >= 2
    data([1 2]) = data([2 1]);
end


end

