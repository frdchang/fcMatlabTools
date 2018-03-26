function [Inew4] = rescale_im09(I,low_thr,high_thr)

%clear all
%1.find the number for the 5% lowest cells and set all these to zero
%2.reset the others s.t. the 5.1% will now be zero and multiply s.t.
%max =255

%I=imread('AD_june16_48nM_af_after2h_240nM_block-0004_Position(18)_t050c1.jpg');
[xsize,ysize]=size(I);
im_dist=zeros(1,xsize.*ysize);
index=1;
for i=1:xsize
    for j=1:ysize
        im_dist(1,index)=double(I(i,j));
        index=index+1;
    end
end

I_mean=mean(im_dist);
I_std =sqrt(var(im_dist));

thr =round(I_mean-I_std.*low_thr);%0.5
thr2=round(I_mean+I_std.*high_thr);%3

Inew=double(I)-thr;
Inew2=Inew>0;
Inew3=uint8(Inew).*uint8(Inew2);

Inew2=Inew>thr2;
Inew3=(Inew3.*uint8(Inew<thr2))+uint8(Inew2).*uint8(thr2);

Max_f=255./double((max(max(Inew3))));
Inew4=uint8(Max_f.*double(Inew3));




