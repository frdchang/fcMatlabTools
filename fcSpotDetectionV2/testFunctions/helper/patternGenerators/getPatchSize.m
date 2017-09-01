function [ patchSize ] = getPatchSize( psf )
%GETPATCHSIZE the patchsize needs to sometimes handle a separable kernel.
%so this function checks if cell and gets size of that.

if iscell(psf)
   patchSize = cellfun(@numel,psf); 
else
    patchSize = size(psf);
end


end

