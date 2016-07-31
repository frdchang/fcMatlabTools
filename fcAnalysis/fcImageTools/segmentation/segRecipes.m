%% for cyano segmentation
brightZstack = importStack('/Users/fchang/Dropbox/Public/examplesFromAndrian/AGH42example.ome.tiff - T=0 C=2.tif');
spotStack    = importStack('/Users/fchang/Dropbox/Public/examplesFromAndrian/AGH42example.ome.tiff - T=0 C=0.tif');
% when you run cyano seg it will ask you to 
% 1) select a zoomed area to closer inspection
% 2) select a handful of points that define the edge (the bright halo
% around the cell)
[L,stats,qpm] = cyanoSeg(brightZstack);
[~,rgbSegmented]= plotLabels(qpm,stats,L);
figure;imshow(rgbSegmented);

spotParams = fcSpotDetection(spotStack);
plot3Dstack(spotStack,'spotParams',spotParams);

% this function will return spotparams for each cell in L
spotParamsInL = returnSpotParamsInL(spotParams,L);
