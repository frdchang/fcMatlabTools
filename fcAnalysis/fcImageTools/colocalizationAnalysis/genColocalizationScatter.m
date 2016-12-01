function h = genColocalizationScatter(data1,data2,mask)
%GENCOLOCALIZATIONSCATTER will generate a scatter plot of the datas

usePixels = mask > 0;

pixelX = data1(usePixels);
pixelY = data2(usePixels);

scatter(pixelX(:),pixelY(:))

end

