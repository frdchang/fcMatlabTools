function varargout = applyKmatrix(Kmatrix,littleLambdas,varargin)
%APPLYKMATRIX will apply the spectral bleed thru coefficient to the little
%lambdas

numDatas = size(Kmatrix,2);

varargout = cell(numDatas,1);

if isempty(varargin)
   if iscell(littleLambdas)
       
   else
      for ii = 1:numDatas
         varargout{ii} = Kmatrix(ii) 
      end
   end
else
    
end


end

