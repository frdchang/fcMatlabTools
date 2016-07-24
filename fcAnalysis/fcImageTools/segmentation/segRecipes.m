%% for cyano segmentation
brightZstack = importStack('/Users/fchang/Dropbox/Public/examplesFromAndrian/AGH42example.ome.tiff - T=0 C=2.tif');
edgeProfileZ = [16962 17033 17319 17392 18426 21676 23678 24500 24320];
[L,stats,qpm] = cyanoSeg(brightZstack,edgeProfileZ);
[~,rgbSegmented]= plotLabels(qpm,stats,L);
imshow(rgbSegmented);