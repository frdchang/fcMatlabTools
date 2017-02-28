function [sumStack] = sumSIMStack( simStack )
%SUMSIMSTACK will sum the phase and rotation angles to generate a widefield
%dataset

phase = 5;
rot = 3;


numZslices = size(simStack,3)/(phase*rot);
sumStack = zeros([size(simStack,1), size(simStack,2),numZslices]);
for ii = 1:numZslices
    sumStack(:,:,ii) = sum(simStack(:,:,ii:numZslices:end),3);
end


end

