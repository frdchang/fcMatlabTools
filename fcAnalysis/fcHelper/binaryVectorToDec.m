function [decRep] = binaryVectorToDec(binaryVect)
%BINARYVECTORTODEC converts binaryVect = [1 0 0 1] such as that into a
%decimal

bases = 2.^(0:(numel(binaryVect)-1));
bases = fliplr(bases);
decRep = sum(bases.*binaryVect);
end

