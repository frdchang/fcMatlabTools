function [] = exportFigEPS(savepathFile)
%EXPORTFIGEPS Summary of this function goes here
%   Detailed explanation goes here
makeDIRforFilename(savepathFile);
print('-painters','-depsc', savepathFile);

end

