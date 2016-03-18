%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%   P O I S S O N   E Q U A T I O N   S O L V E R   %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Solves poisson equation of the form Del^2(psi) = func
% 
% Inputs:
%   - func:     NxN matrix, right hand side of Poisson equation
%   - ps:       pixel size
%   - eps:      regularization parameter to prevent division by zero
%   - symm:     [on/off] symmetric FFT to produce purely real output
%   - reflect:  [on/off] reflect image for periodic boundary conditions
%
% Outputs:
%   - Psi_xy:   purely real solution to Poisson equation
%
% Notes:
%   - Input 'func' must be a SQUARE MATRIX.
%   - The 'reflect' feature will quadruple the size of the image, and thus
%     significantly increase computation time.
%
% Aamod Shanker, Gautam Gunjala, July 2014
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Psi_xy ] = poisson_solve( func, ps, eps, symm, reflect)

N = size(func,1); 

%% Create periodic boundary conditions
%  ___           ___ ___
% |   |         |   |   |
% | b |   ==>   | b | d |
% |___|         |___|___|
%               |   |   |
%               | p | q |
%               |___|___|

if(reflect ~= 0)
    N = N*2;
    func = [func, fliplr(func)];
    func = [func; flipud(func)];
end

%% POISSON SOLVE
% Create unshifted default omega axis
wx =2*pi*(0:(N-1))/N; 

% Shift zero to centre:
% for even case, pull back by pi
% for odd case, pull back by pi(1-1/N)
fx = 1/(2*pi*ps)*(wx-pi*(1-mod(N,2)/N)); 
[Fx,Fy] = meshgrid(fx,fx);
func_ft = fftshift(fft2(func));

%Epsilon added to denominator for divide by zero exception
Psi_ft = func_ft./(-4*pi^2*(Fx.^2+Fy.^2+eps));
if(symm)
    Psi_xy = ifft2(ifftshift(Psi_ft),'symmetric');
else
    Psi_xy = ifft2(ifftshift(Psi_ft));
end

%% Crop to upper left quadrant 
if(reflect ~= 0)
   N = N/2;
   Psi_xy = Psi_xy(1:N,1:N); 
end
end