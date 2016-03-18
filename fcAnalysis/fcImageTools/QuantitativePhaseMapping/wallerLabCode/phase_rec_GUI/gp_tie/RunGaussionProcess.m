
function RePhase=RunGaussionProcess(Ividmeas,zfocus,z,lambda,ps,Nsl,eps1,eps2,reflect)
%RunGaussionProcess
%z is a column vector

[Nx,Ny,Nz]=size(Ividmeas);
I0 = Ividmeas(zfocus);
zfocus = z(zfocus);

% divide the frequency into Nsl bins
FrequencyMesh=CalFrequency(Ividmeas(:,:,1),lambda, ps,1);
MaxF=max(max(FrequencyMesh));
MaxF=sqrt(MaxF/(lambda/2));
Frq_cutoff=[linspace(0,1,Nsl)]*MaxF;
Frq_cutoff=Frq_cutoff.^2*lambda/2;%divide the frequency to Nsl bins. For the frequency within one bin,
%it shares same frequency threshold and same hyper-parameters in GP regression.

% figure;plot([1:Nsl],Frq_cutoff);title('Cutoff frequency');

%calculate the hyperparameters of GP of different frequency threshold in GP
%regression
SigmafStack=zeros(Nsl,1);
SigmanStack=zeros(Nsl,1);
SigmalStack=zeros(Nsl,1);

FrqtoSc=[linspace(1.2,1.1,Nsl)];% trade off of noise and accuracy
p=Nz/(max(z)-min(z));%average data on unit space


for k=1:Nsl
%initialize Sigman and Sigmaf
Sigman=double(10^(-9));
Sigmaf=double(1);

%calculating Sigmal
f1=Frq_cutoff(k);
sc=f1*FrqtoSc(k);%FrqtoSc(k) lightly larger than 1
a=sc^2*2*(pi)^2; b=log((p*(2*pi)^(1/2))/Sigman);
%fu=@(x)a*x-0.5*log(x)-b;
fu2=@(x)a*exp(x)-0.5*x-b;
x=fzero(fu2,5);
Sigmal=double(exp(x));% Sigmal varies on sc

SigmafStack(k)=Sigmaf;
SigmanStack(k)=Sigman;
SigmalStack(k)=Sigmal;
end



dIdzStack=zeros(Nx,Ny,Nsl);% store the recover phase images for Nsl hyperparamter pairs 
CoeffStack=zeros(Nz,Nsl);
Coeff2Stack=zeros(Nz,Nsl);
%figure;
for k=1:Nsl

 Sigmal=SigmalStack(k);
 Sigman=SigmanStack(k);
 Sigmaf=SigmafStack(k);
[dIdz Coeff Coeff2]=GPRegression(Ividmeas, zfocus,z,Sigmaf,Sigmal,Sigman); %GP regression

dIdz=2*pi/(lambda)*ps^2*dIdz;
dIdzStack(:,:,k)=dIdz;
CoeffStack(:,k)=Coeff;%derivative
Coeff2Stack(:,k)=Coeff2; %smoothing, dummy paramter, which is not used afterwards in this version.

% RePhasek=poissonFFT(dIdz,regparam);
% 
% imagesc(RePhasek);
% axis image;axis off;colormap gray
% title(sprintf('Recovered Phase at %d step',k));colorbar
% pause(0.1)

%}
end


dIdzC=CombinePhase(dIdzStack, Frq_cutoff,FrequencyMesh,CoeffStack,Coeff2Stack);%For the frequency within one bin, it shares same threshold sc and hyper-parameters in GP regression.

%% Poisson solver for pure phase 

Del2_Psi_xy = (-2*pi/lambda) .* dIdzC;

N = size(dIdzC,1);
Psi_xy = poisson_solve( Del2_Psi_xy, ps, eps1, 0, reflect);

% From Del(I*Del(Phi)) = Del^2(Psi), we get
% Del(Phi) = Del(Psi)/I
[Grad_Psi_x, Grad_Psi_y] = gradient(Psi_xy/ps);
Grad_Psi_x = Grad_Psi_x./(I0+eps2);
Grad_Psi_y = Grad_Psi_y./(I0+eps2);

% Del^2(Phi) = Del(Del(Psi)/I)
[grad2x,~] = gradient(Grad_Psi_x/ps);
[~,grad2y] = gradient(Grad_Psi_y/ps);
Del2_Phi_xy = grad2x + grad2y;

Phi_xy = poisson_solve( Del2_Phi_xy, ps, eps1, 1, reflect);

dcval = (sum(Phi_xy(:,1)) + sum(Phi_xy(1,:)) + ...
    sum(Phi_xy(N,:)) + sum(Phi_xy(:,N)))/(4*N);

RePhase = -1*(Phi_xy - dcval);

end
