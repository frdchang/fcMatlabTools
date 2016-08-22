%% for cyano segmentation
brightZstack = importStack('/Users/fchang/Desktop/Error in returnSpotParamsInL/AGH42-every20m-first4darkCropped.tif - T=58 C=2.tif');
spotStack    = importStack('/Users/fchang/Desktop/Error in returnSpotParamsInL/AGH42-every20m-first4darkCropped.tif - T=58 C=1.tif');
% when you run cyano seg it will ask you to 
% 1) select a zoomed area to closer inspection
% 2) select a handful of points that define the edge (the bright halo
% around the cell)
% then it will output 'edgeProfileZ', [7192.5 7568 7675.5 8139 10337
% 14890.5 20388.5 24068.5 23712 23106.5 2099]
% copy it and paste it into cyanoSeg(brightZstack,'edgeProfileZ', [7192.5
% 7568 7675.5 8139 10337 14890.5 20388.5 24068.5 23712 23106.5 2099)
% so it can be used for future without a prompt
[L,stats,qpm] = cyanoSeg(brightZstack);
[~,rgbSegmented]= plotLabels(qpm,stats,L);
figure;imshow(rgbSegmented);

spotParams = fcSpotDetection(spotStack,'LLRatioThresh',5000);
plot3Dstack(spotStack,'spotParams',spotParams);

% this function will return spotparams for each cell in L
spotParamsInL = returnSpotParamsInL(spotParams,L);
