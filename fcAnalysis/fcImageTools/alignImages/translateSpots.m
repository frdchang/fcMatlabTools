function listOfMLEs = translateSpots(listOfMLEs,translationSequence)
%TRANSLATESPOTS translates the listOfMLEs with translationSequence.  

for ii = 1:numel(listOfMLEs)
   for jj = 1:numel(listOfMLEs{ii})
       for kk = 1:numel(listOfMLEs{ii}{jj})
           listOfMLEs{ii}{jj}(kk).thetaMLEs = shiftSpotsInTheta(listOfMLEs{ii}{jj}(kk).thetaMLEs,translationSequence(ii,:));
       end
   end
end



