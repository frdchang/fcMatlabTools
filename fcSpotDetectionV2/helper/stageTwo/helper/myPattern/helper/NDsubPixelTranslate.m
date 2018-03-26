function translated = NDsubPixelTranslate(data,translate)
%NDSUBPIXELTRANSLATE will translate data by translate amount
% will extend values at edges.
% units in pixels


translated = padarray(data,ceil(translate),'replicate');

for i = 1:ndims(translated)
    shiftVector = zeros(2*ceil(translate(i))+1,1);
    zeroPos = ceil(numel(shiftVector)/2);
    shiftVector(zeroPos+ceil(translate(i))) = 1-translate(i);
    shiftVector(zeroPos+floor(translate(i))) = translate(i);
    reshapeVector = ones(1,numel(shiftVector));
    if ~isscalar(reshapeVector)
        reshapeVector(i) = numel(shiftVector);
        translated = convn(translated,reshape(shiftVector,reshapeVector));
    end
end

translated = unpadarray(translated,size(data));


