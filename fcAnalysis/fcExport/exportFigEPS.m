function [] = exportFigEPS(savepathFile)
%EXPORTFIGEPS Summary of this function goes here
%   Detailed explanation goes here
makeDIRforFilename(savepathFile);
print('-painters','-depsc', savepathFile);
[daPath,daFile,~] = fileparts(savepathFile);
epsclean([daPath filesep daFile '.eps']);
end

