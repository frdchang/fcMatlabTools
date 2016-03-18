function im_mat_shift = subpixel_shift(input_matrix,pixelshift_y,pixelshift_x)

%% Fourier domain shifting

%Normalize
% im_mat1 = input_matrix/max(max(input_matrix));
im_mat1 = input_matrix;
%Caluculate fft
im_mat_fft = fftshift(fft2(im_mat1));
% subplot(1,2,1);imagesc(abs(im_mat1).^2);
% subplot(1,2,2);imagesc(abs(im_mat_fft).^2);colorbar;

%Define fourier domain axes
kx = 1/size(im_mat1,1)*linspace(-1/2,1/2-1/size(im_mat1,1),size(im_mat1,1));
[Kx,Ky] = meshgrid(kx,kx);

%Subpixel shift
% pixelshift_y = 0.5 ; 
im_mat_shift = (ifft2(ifftshift(im_mat_fft.*exp(-1i*2*pi*(Ky*pixelshift_y + Kx*pixelshift_x))),'symmetric'));