%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%                 I T E R A T I V E                 %%%%%%%%%%%%
%%%%%%%%%%%%    T R A N S P O R T   O F   I N T E N S I T Y    %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function uses an iterative approach to solve the Transport of 
% Intensity Equation (TIE). Best suited for experimental data.
%
% Inputs:
%   - I1:       lower image
%   - I0:       center image          [dI = I2-I1] 
%   - I2:       upper image 
%   - ps:       pixel size
%   - lam:      wavelength
%   - dz:       distance between I1 and I2
%   - eps:      regularization parameter for poisson_solve.m
%   - epsI:     regularization parameter for division by intensity
%   - reflect:  [on/off] reflect image for periodic boundary conditions
%   - nloops:   number of loops to perform
%   - beta:     weighting factor for result of previous iteration 
%
% Outputs:
%   - phase_mat:    result of the algorithm; image(:,:,n) corresponds to
%                   the result that would be obtained after n iterations
%   - tie_results:  results of the TIE calls in each individual iteration
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

function [ phase_mat, tie_results ] = ...
    tie_recur( I1, I0, I2, ps, lam, dz, eps, epsI, reflect, nloops, beta )

% Initialize variables
N = size(I0,1);
k = 2*pi/lam;
phase_mat = zeros( N, N, nloops );
tie_results = zeros( N, N, nloops );

% Initial call to TIE 
phi_0 = zeros(N);
old_lhs = k/(2*dz).*(I2-I1);
phase_mat(:,:,1) = tie( I1, I0, I2, ps, lam, dz, eps, epsI, reflect );

% Subsequent iterations
for i = 2 : nloops
    new_lhs = inverse_tie( I0, phase_mat(:,:,i - 1), ps );
    I2 = dz*beta*(phi_0 + (new_lhs - old_lhs))/k; 
    tie_results(:,:,i) = ...
        tie( phi_0, I0, I2, ps, lam, dz, eps, epsI, reflect );
    phase_mat(:,:,i) = phase_mat(:,:,i - 1) - tie_results(:,:,i);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%    I N V E R S E   T I E   S O L V E R    %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Finds the LHS of the Transport of Intensity Equation given I and Phi  
%
% Inputs:
%   - I0:   Image at center plane
%   - phi:  Phase matrix
%   - ps:   pixel size
%
% Output:
%   - lhs:  Estimated LHS (LHS = Del(I*Del(Phi)))
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ lhs ]  = inverse_tie( I0, phi, ps)

% Find I*Del(Phi)
[gradPhix,gradPhiy] = gradient(phi);
I_gradPhix = (I0).*gradPhix/ps;
I_gradPhiy = (I0).*gradPhiy/ps;

% Find Del(I*Del(Phi)) in x and y
[grad2x,~] = gradient(I_gradPhix);
[~,grad2y] = gradient(I_gradPhiy);

% Combine
lhs = (grad2x+grad2y)/ps;
end
