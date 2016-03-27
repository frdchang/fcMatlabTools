p=struct('Ti0',1.3000e-04,'Ni0', 1.5180,'Ni',1.5180, 'Tg0', 1.7000e-04,...
    'Tg', 1.7000e-04, 'Ng0', 1.5150, 'Ng', 1.5150, 'Ns' , 1.33,...
    'lambda',5.5000e-07, 'M' , 100, 'NA' , 1.400, 'alpha', 0, 'pixelSize', 10.0e-06);

p.alpha=asin(p.NA/p.Ni);
Pi=3.141592;

%Half the number of CCD pixels.
nbpixels=100;
%Number of planes to acquire.
plan=100;
%Size of the objective z steps.
z_step=100e-9;


stack=zeros(nbpixels*2-1,nbpixels*2-1,plan);
totstack=zeros(nbpixels*2-1,nbpixels*2-1,plan);

xp=0;
yp=0;
zp=1.25e-6;

%Generating the PSF on each plane
for i=1:plan
    stack(:,:,i)=vectorialPSF(xp,yp,zp,(i-35)*z_step,nbpixels,p);
end

zdir=stack;

%Rescliging the stack along x and y
ydir=zeros(nbpixels*2-1,plan);
for i=1:nbpixels*2-1
    for k=1:plan
        ydir(i,k)=stack(nbpixels,i,k);
    end
end

xdir=zeros(nbpixels*2-1,plan);
for i=1:nbpixels*2-1
    for k=1:plan
        xdir(i,k)=stack(i,nbpixels,k);
    end
end

%Plotting a slice of the PSF along all three directions
figure
imagesc(zdir(:,:,3));
figure
imagesc(xdir);
daspect([1 p.M*z_step/p.pixelSize 1])
figure
imagesc(ydir);
daspect([1 p.M*z_step/p.pixelSize 1])


%proj(:, :) = max(stack, [], 2);