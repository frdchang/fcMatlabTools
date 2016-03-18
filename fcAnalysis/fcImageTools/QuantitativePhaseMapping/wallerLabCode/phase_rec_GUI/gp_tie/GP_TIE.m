%GP TIE code (By Jingshan Zhong)
%reference:  Transport of Intensity phase imaging by intensity spectrum
%fitting of exponentially spaced defocus planes (Optics Express 2014 accepted)
%contact: www.laurawaller.com
%**************************************************************************
% Input paramters:
% Inten: defocused intensity stack measured along the propgagation axis
% zvec: the positions of the images been measured.
% ps: pixel size
% lambda: wavelength

%Output:
%RePhase1: Recovered phase

%Default parameters:
% zfocus1: the focal plane is defaulted as zfocus1=0
%regparam=5*10^-6; %Poisson solver regularization for GP TIE
%**************************************************************************

%Important: 
%1) The variable z need to be a COLUMN vector.
%2) This code only works for pure phase recovery, which means the intensity
%at focus is assumed to be constant

function [ RePhase1 ] = GP_TIE(Ividmeas1,z1,lambda,ps,zfocus1,Nsl,eps1,eps2,reflect)
%% run Gaussian Process
%Nsl is defaulted as 50. In order to reduce the computational complexity, we divide the frequency to Nsl bins. 
%For the frequency within one bin, it shares same frequency threshold and same hyper-parameters in GP regression.
if(isrow(z1))
    z1 = z1';
end

RePhase1=RunGaussionProcess(Ividmeas1,zfocus1,z1,lambda,ps,Nsl,eps1,eps2,reflect);% recovered phase
RePhase1=RePhase1/mean(mean(mean(Ividmeas1))); % normalized phase by mean of intensity.

