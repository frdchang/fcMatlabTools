function focusMeasures = findBestEnergyForBestFocus(stack)

energyTypes = {'ACMO','BREN','CURV','GDER','GLVA','GLVN','GRAE','GRAT','GRAS','HELM','HISE','HISR',...
    'LAPE','LAPM','LAPV','LAPD','SFIL','SFRQ','TENG','TENV','VOLA','WAVS','WAVV','WAVR'};


[~,~,zL] = size(stack);

focusMeasures = cell(numel(energyTypes),1);
parfor i = 1:numel(energyTypes)
    display(energyTypes{i});
    focusmeasure = zeros(zL,1);
    for j = 1:zL
        focusmeasure(j) = fmeasure(stack(:,:,j),energyTypes{i});
    end
    
    focusMeasures{i} = focusmeasure;
end

cmap = distinguishable_colors(numel(energyTypes));
for i = 1:numel(energyTypes)
    figure;
    plot(norm0to1(focusMeasures{i}),'Color',cmap(i,:));
    title(energyTypes{i});
end


% for brightfield the follownig correlate well
% min GLVA
% min HISE
% min SFIL
% min GLVN (great!)

% LAPV max
% LAPD max
% LAPM max
% LAPE max


