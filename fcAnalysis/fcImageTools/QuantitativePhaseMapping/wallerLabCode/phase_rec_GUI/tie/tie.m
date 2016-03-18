%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%    T R A N S P O R T   O F   I N T E N S I T Y    %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function solves the Transport of Intensity Equation (TIE).
%
% Inputs:
%   - I1:       lower image
%   - I0:       center image          [dI = I2-I1] 
%   - I2:       upper image 
%   - ps:       pixel size
%   - lambda:   wavelength
%   - dz:       distance between I1 and I0 (equal to dist(I2,I0))
%   - eps:      regularization parameter for poisson_solve.m
%   - epsI:     regularization parameter for division by intensity
%   - reflect:  [on/off] reflect image for periodic boundary conditions
%
% Outputs:
%   - Phi_xy:   recovered phase matrix
%
% Notes:
%   - INPUT IMAGES [I0, I1, I2] MUST BE SQUARE, AND OF EQUAL SIZE. 
%   - The units for ps, lambda, and dz MUST BE CONSISTENT.
%   - dz is the distance between I0 and I1, should be the negative of the
%     distance from I0 and I2
%   - The 'reflect' feature will quadruple the size of the image, and thus
%     significantly increase computation time.
%
% Aamod Shanker, Gautam Gunjala, July 2014
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Phi_xy ] = tie( I1, I0, I2, ps, lambda, dz, eps, epsI, reflect)

%%%%%%%%%%%%%%%%%%%%     FIX IN FUTURE UPDATE      %%%%%%%%%%%%%%%%%%%%%%%%
% Convert input ps, lambda, dz to nanometers
ps = ps * 10^9;
lambda = lambda * 10^9;
dz = dz * 10^9;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% From Transport of Intensity Equation
% Let Del(I*Del(Phi)) = Del^2(Psi)
Del2_Psi_xy = (-2*pi/(lambda*2*dz)).*(I2-I1);

N = size(I1,1);
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