function amplitudes = returnAmplitudes(spotParams)
%RETURNAMPLITUDES returns amplitudes, which are by definition second to
%last entry

if isempty(spotParams)
    amplitudes = [];
    return;
end
thetas = grabThetasFromSpotParams(spotParams);
if isempty(thetas)
    amplitudes = [];
    return;
end
amplitudes = thetas(:,end-1);

end

