function translated = translateImage(image,row_shift,col_shift)
%TRANSLATEIMAGE Summary of this function goes here
%   Detailed explanation goes here
if row_shift == 0 && col_shift == 0
    translated = image;
    return;
end

if ndims(image) == 3
    stack = image;
    [nr,nc,zL]=size(stack);
    translated(nr,nc,zL) = 0;
    for i = 1:zL
        image = stack(:,:,i);
        image = fft2(image);
        diffphase = 0;
        [nr,nc]=size(image);
        Nr = ifftshift([-fix(nr/2):ceil(nr/2)-1]);
        Nc = ifftshift([-fix(nc/2):ceil(nc/2)-1]);
        [Nc,Nr] = meshgrid(Nc,Nr);
        Greg = image.*exp(1i*2*pi*(-row_shift*Nr/nr-col_shift*Nc/nc));
        Greg = Greg*exp(1i*diffphase);
        translated(:,:,i) = abs(ifft2(Greg));
    end
else
    image = fft2(image);
    diffphase = 0;
    [nr,nc]=size(image);
    Nr = ifftshift([-fix(nr/2):ceil(nr/2)-1]);
    Nc = ifftshift([-fix(nc/2):ceil(nc/2)-1]);
    [Nc,Nr] = meshgrid(Nc,Nr);
    Greg = image.*exp(1i*2*pi*(-row_shift*Nr/nr-col_shift*Nc/nc));
    Greg = Greg*exp(1i*diffphase);
    translated = ifft2(Greg);
end
translated = abs(translated);
end

