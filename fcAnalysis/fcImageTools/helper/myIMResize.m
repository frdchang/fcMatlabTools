function [ resized ] = myIMResize( data,varargin )
%MYIMRESIZE handles both 2d and 3d

switch ndims(data)
    case 2
        resized = imresize(data,varargin{:});
    case 3
        resized = imresize3(data,varargin{:});
    otherwise
        error('didnt program for this case');
end


end

