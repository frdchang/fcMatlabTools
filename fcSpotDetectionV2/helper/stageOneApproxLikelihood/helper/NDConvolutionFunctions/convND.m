function filteredData = convND(data,template)
%CONVND will convolve by FFT or separable depending whether template is a
%cell array or not

if iscell(template)
    % convolution is separable
    filteredData = convSeparableND(data,template);
else
    % otherwise just do fft
    convFunc = convFFTND(data,template);
end

