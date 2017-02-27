%% first find optimal gaussian size
stack = importStack('/mnt/btrfs/fcDataStorage/fcCheckout/Elyra/20170216/usethisfuckingshit/conversion/LSM516bit_usethis/Image 36-subStack.tif');
% the result is as follows
threshVal = 0.0015;
sigmaSQXY = 1:0.2:5;
sigmaSQZ  = 1:0.2:5;
XY = 3;
Z = 4;
patchSize = 30;
sigmaSQXY= sigmaSQXY(XY);
sigmaSQZ = sigmaSQZ(Z);
kern = ndGauss([sigmaSQXY,sigmaSQXY,sigmaSQZ],[patchSize,patchSize,patchSize]);
kern = threshPSF(kern,threshVal);
% sigmaSQXY = 1.4
% sigmaSQZ = 1.6
% usually i make kernel centered on odd number, but having it even number
% seems better.  will  look into it in the future

