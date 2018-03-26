function [NCC] = normxcorr3FFT(T,I)
%normxcorr3 calculates the normalized cross correlation between a Template
%(T) and Image (I) but accounts for edge artifacts by adjusting the
%normalization given a truncated template at the edge
%[NCC,~,~,~] = normxcorr3FFT(daGauss,stack,[],[],[])
% normxcorr3fft now has a memory and save relevant details for the next
% call
T = double(T);
I = double(I);

sizeI = size(I);
sizeT = size(T);

Totsize = sizeI + sizeT-1;

persistent numOverlap
persistent TdataIn
persistent oldTemplate
persistent IdataIn
persistent oldI

% numOverlap counts how many valid pixels there are to take the averages
% over.  On the edges, the template T is truncated, so there are less
% pixels; this is being accounted for.
if isempty(numOverlap)
    numOverlap = local_sum(ones(size(I)),size(T));
else
    if ~isequal(size(numOverlap),Totsize)
        numOverlap = local_sum(ones(size(I)),size(T));
    end
end


if isempty(IdataIn)
    % <I> at {u,v}
    avgIuv = local_sum(I,size(T))./ numOverlap;
    % <I^2> at {u,v}
    avgI2uv = local_sum(I.*I,size(T))./ numOverlap;
    % <dI^2> at {u,v} with <dI^2> = <I^2> - <I>^2
    dI2uv = (avgI2uv - avgIuv.^2);
    % save for future use
    IdataIn.avgIuv = avgIuv;
    IdataIn.dI2uv  = dI2uv;
    fftI = fftn(I,Totsize);
    IdataIn.fftI = fftI;
    oldI = I;
else
    if isequal(oldI,I) && isequal(size(T),size(oldTemplate))
        avgIuv = IdataIn.avgIuv;
        dI2uv  = IdataIn.dI2uv;
        fftI = IdataIn.fftI;
    else
        if ~isequal(size(oldI),size(I))
            % in order to use convolution in the fourier domain, I have to flip all the
            % dimensions in the template since convolution is a 'flip' and drag
            % method... here cross correlation is just drag.  to compensate for the
            % 'flip' that occurs in convolution i premptively flip all the dimensions
            % in T.
            flippedT=flipdim(flipdim(flipdim(T,1),2),3);
            
            % <T> at {u,v}
            avgTuv = local_sum(flippedT,size(I))./ numOverlap;
            % <T^2> at {u,v}
            avgT2uv = local_sum(flippedT.*flippedT,size(I))./ numOverlap;
            % <dT^2> at {u,v} with <dT^2> = <T^2> - <T>^2
            dT2uv = (avgT2uv - avgTuv.^2);
            % save for future use
            TdataIn.avgTuv = avgTuv;
            TdataIn.dT2uv  = dT2uv;
            fftT = fftn(flippedT,Totsize);
            TdataIn.fftT = fftT;
            oldTemplate = T;
        end
        % <I> at {u,v}
        avgIuv = local_sum(I,size(T))./ numOverlap;
        % <I^2> at {u,v}
        avgI2uv = local_sum(I.*I,size(T))./ numOverlap;
        % <dI^2> at {u,v} with <dI^2> = <I^2> - <I>^2
        dI2uv = (avgI2uv - avgIuv.^2);
        % save for future use
        IdataIn.avgIuv = avgIuv;
        IdataIn.dI2uv  = dI2uv;
        fftI = fftn(I,Totsize);
        IdataIn.fftI = fftI;
        oldI = I;
    end
end

% in order to use convolution in the fourier domain, I have to flip all the
% dimensions in the template since convolution is a 'flip' and drag
% method... here cross correlation is just drag.  to compensate for the
% 'flip' that occurs in convolution i premptively flip all the dimensions
% in T.
flippedT=flipdim(flipdim(flipdim(T,1),2),3);

if isempty(TdataIn)
    % <T> at {u,v}
    avgTuv = local_sum(flippedT,size(I))./ numOverlap;
    % <T^2> at {u,v}
    avgT2uv = local_sum(flippedT.*flippedT,size(I))./ numOverlap;
    % <dT^2> at {u,v} with <dT^2> = <T^2> - <T>^2
    dT2uv = (avgT2uv - avgTuv.^2);
    % save for future use
    TdataIn.avgTuv = avgTuv;
    TdataIn.dT2uv  = dT2uv;
    fftT = fftn(flippedT,Totsize);
    TdataIn.fftT = fftT;
    oldTemplate = T;
else
    if isequal(oldTemplate,T) && isequal(size(oldI),size(I))
        avgTuv = TdataIn.avgTuv;
        dT2uv  = TdataIn.dT2uv;
        fftT = TdataIn.fftT;
    else
        if ~isequal(size(oldTemplate),size(T))
            % <I> at {u,v}
            avgIuv = local_sum(I,size(T))./ numOverlap;
            % <I^2> at {u,v}
            avgI2uv = local_sum(I.*I,size(T))./ numOverlap;
            % <dI^2> at {u,v} with <dI^2> = <I^2> - <I>^2
            dI2uv = (avgI2uv - avgIuv.^2);
            % save for future use
            IdataIn.avgIuv = avgIuv;
            IdataIn.dI2uv  = dI2uv;
            fftI = fftn(I,Totsize);
            IdataIn.fftI = fftI;
            oldI = I;
        end
        
        % <T> at {u,v}
        avgTuv = local_sum(flippedT,size(I))./ numOverlap;
        % <T^2> at {u,v}
        avgT2uv = local_sum(flippedT.*flippedT,size(I))./ numOverlap;
        % <dT^2> at {u,v} with <dT^2> = <T^2> - <T>^2
        dT2uv = (avgT2uv - avgTuv.^2);
        % save for future use
        TdataIn.avgTuv = avgTuv;
        TdataIn.dT2uv  = dT2uv;
        fftT = fftn(flippedT,Totsize);
        TdataIn.fftT = fftT;
        oldTemplate = T;
    end
end





ITcc = real(ifftn(fftI.* fftT));

NCC = (ITcc./numOverlap - avgIuv.*avgTuv) ;
NCC = NCC ./ sqrt(dT2uv.*dI2uv);
NCC = unpadarray(NCC,size(I));
end

function B=unpadarray(A,Bsize)
Bstart=ceil((size(A)-Bsize)/2)+1;
Bend=Bstart+Bsize-1;
if(ndims(A)==2)
    B=A(Bstart(1):Bend(1),Bstart(2):Bend(2));
elseif(ndims(A)==3)
    B=A(Bstart(1):Bend(1),Bstart(2):Bend(2),Bstart(3):Bend(3));
end
end

function local_sum_I= local_sum(I,T_size)
% Add padding to the image
B = padarray(I,T_size);

% Calculate for each pixel the sum of the region around it,
% with the region the size of the template.
if(length(T_size)==2)
    % 2D localsum
    s = cumsum(B,1);
    c = s(1+T_size(1):end-1,:)-s(1:end-T_size(1)-1,:);
    s = cumsum(c,2);
    local_sum_I= s(:,1+T_size(2):end-1)-s(:,1:end-T_size(2)-1);
else
    % 3D Localsum
    s = cumsum(B,1);
    c = s(1+T_size(1):end-1,:,:)-s(1:end-T_size(1)-1,:,:);
    s = cumsum(c,2);
    c = s(:,1+T_size(2):end-1,:)-s(:,1:end-T_size(2)-1,:);
    s = cumsum(c,3);
    local_sum_I  = s(:,:,1+T_size(3):end-1)-s(:,:,1:end-T_size(3)-1);
end
end