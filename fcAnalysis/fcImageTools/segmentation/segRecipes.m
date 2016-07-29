%% for cyano segmentation
brightZstack = importStack('/Users/fchang/Dropbox/Public/examplesFromAndrian/AGH42-od003_Alignment_Subset.czi - T=0 C=2.tif');
% when you run cyano seg it will ask you to 
% 1) select a zoomed area to closer inspection
% 2) select a handful of points that define the edge (the bright halo
% around the cell)
[L,stats,qpm] = cyanoSeg(brightZstack);
[~,rgbSegmented]= plotLabels(qpm,stats,L);
figure;imshow(rgbSegmented);