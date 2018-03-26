
%% do nucleosome-like anlaysis to LLRatio and  
smoothFactor =3;
windowSize = 30;
% remove weird linear data from sets
autoRaw = ValuesFiltAautoRaw(:,2:2:end);
vippRaw = ValuesLLratioVippRaw(:,2:2:end);
% convert to cell arrays and remove nans so lengths can be different
sizeData = size(autoRaw);
autoCell = {};
vipp1Cell = {};
for ii = 1:sizeData(2)
    currAuto = autoRaw(:,ii);
    currVipp1 = vippRaw(:,ii);
    currAuto(isnan(currAuto)) = [];
    currVipp1(isnan(currVipp1)) = [];
    autoCell{end+1} = smooth(currAuto,smoothFactor );
    vipp1Cell{end+1} = smooth(currVipp1,smoothFactor );
end
output = makeKymoLikeAnalysis(vipp1Cell,autoCell,windowSize);

autoAligned = montageAlignment(output.autoAlignedCropped);
vipp1Aligned = montageAlignment(output.vipp1AlignedCropped);

% save as fits!  
exportSingleFitsStack('~/Desktop/autoAligned',autoAligned);
exportSingleFitsStack('~/Desktop/vipp1Aligned',vipp1Aligned);
