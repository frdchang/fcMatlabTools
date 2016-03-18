%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%              H I G H E R   O R D E R              %%%%%%%%%%%%
%%%%%%%%%%%%    T R A N S P O R T   O F   I N T E N S I T Y    %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function solves the Transport of Intensity Equation (TIE), using 
% higher order polynomial interpolation to compute dI/dz.
%
% Inputs:
%   - im_stack: Stack of intensity images at different z planes
%   - num_imgs: Number of images to consider on either side of the center
%   - idx_step: index step size in intensity stack
%   - ps:       pixel size
%   - lambda:   wavelength
%   - zvec:     vector indicating the z value for each image in im_stack
%   - deg:      degree of interpolation polynomial 
%   - sigma:    regularization parameter for polynomial interpolation
%   - eps:      regularization parameter for poisson_solve.m
%   - epsI:     regularization parameter for division by intensity
%   - reflect:  [on/off] reflect image for periodic boundary conditions
%
% Outputs:
%   - phi_rec:   recovered phase matrix
%
% Notes:
%   - INPUT IMAGES [I0, dIdz] MUST BE SQUARE, AND OF EQUAL SIZE. 
%   - The units for ps, lambda, and dz should be METERS.
%   - The 'reflect' feature will quadruple the size of the image, and thus
%     significantly increase computation time.
%
% Jingshan Zhong, Laura Waller, Gautam Gunjala, July 2014
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ phi_rec ] = ho_tie(im_stack, num_imgs, idx_step, ...
    ps, lambda, zvec, deg, sigma, eps, epsI, reflect)

nfocus = find(zvec == 0);
ImgIndex = [-(num_imgs:-1:1) 0 1:1:num_imgs] * idx_step + nfocus; 
im_stack_trunc = im_stack(:,:,ImgIndex);
zvec_trunc = zvec(ImgIndex);
nCoeffs = deg + 1;

dIdz = HigherOrder( im_stack_trunc, lambda, ps, zvec_trunc, nCoeffs, sigma);
phi_rec = ... 
    dIdz_tie( im_stack(:,:,nfocus), dIdz, ps, lambda, eps, epsI, reflect);

% normalized phase by mean of intensity.
phi_rec = phi_rec/mean(mean(mean(im_stack_trunc))); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%              H I G H E R   O R D E R              %%%%%%%%%%%%
%%%%%%%%%%%%             I N T E R P O L A T I O N             %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%              D O C U M E N T A T I O N   P E N D I N G . . . 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ dIdz ] = HigherOrder( Ividmeas, lambda, ps, z, m, sigma )

[Nx,Ny,Nz] = size(Ividmeas);
X = zeros(m,Nz);

for k = 1:m
    X(k,:) = z.^(k-1);
end

w = (X*X'+sigma*eye(m))\X;

Coeff = w(2,:);
dIdz = zeros(Nx,Ny);

for k = 1:Nz  
    dIdz = dIdz+Ividmeas(:,:,k)*Coeff(k);
end

dIdz = (2*pi)/lambda*ps*ps*dIdz;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%    T R A N S P O R T   O F   I N T E N S I T Y    %%%%%%%%%%%%
%%%%%%%%%%%%          W I T H   d I / d z   G I V E N          %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function solves the Transport of Intensity Equation (TIE), taking 
% dI/dz as an input argument.
%
% Inputs:
%   - I0:       center image
%   - dIdz:     LHS of initial transport of intensity equation
%   - ps:       pixel size
%   - lambda:   wavelength
%   - eps:      regularization parameter for poisson_solve.m
%   - epsI:     regularization parameter for division by intensity
%   - reflect:  [on/off] reflect image for periodic boundary conditions
%
% Outputs:
%   - Phi_xy:   recovered phase matrix
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Phi_xy ] = dIdz_tie( I0, dIdz, ps, lambda, eps, epsI, reflect)

%%%%%%%%%%%%%%%%%%%%     FIX IN FUTURE UPDATE      %%%%%%%%%%%%%%%%%%%%%%%%
% Convert input ps, lambda, dz to nanometers
ps = ps * 10^9;
lambda = lambda * 10^9;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% From Transport of Intensity Equation
% Let Del(I*Del(Phi)) = Del^2(Psi)
Del2_Psi_xy = (-2*pi/lambda) .* dIdz;

N = size(I0,1);
Psi_xy = poisson_solve( Del2_Psi_xy, ps, eps, 0, reflect);

% From Del(I*Del(Phi)) = Del^2(Psi), we get
% Del(Phi) = Del(Psi)/I
[Grad_Psi_x, Grad_Psi_y] = gradient(Psi_xy/ps);
Grad_Psi_x = Grad_Psi_x./(I0+epsI);
Grad_Psi_y = Grad_Psi_y./(I0+epsI);

% Del^2(Phi) = Del(Del(Psi)/I)
[grad2x,~] = gradient(Grad_Psi_x/ps);
[~,grad2y] = gradient(Grad_Psi_y/ps);
Del2_Phi_xy = grad2x + grad2y;

Phi_xy = poisson_solve( Del2_Phi_xy, ps, eps, 1, reflect);

dcval = (sum(Phi_xy(:,1)) + sum(Phi_xy(1,:)) + ...
    sum(Phi_xy(N,:)) + sum(Phi_xy(:,N)))/(4*N);

Phi_xy = -1*(Phi_xy - dcval);
end
