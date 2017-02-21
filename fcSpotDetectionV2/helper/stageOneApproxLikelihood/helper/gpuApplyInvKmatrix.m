function [Aout,Bout] = gpuApplyInvKmatrix(invKmatrix,A,B)
%GPUAPPLYINVKMATRIX 
   function [output1,output2] = DoStuff(A,B)
       output1 = invKmatrix(1)*A + invKmatrix(3)*B; 
       output2 = invKmatrix(2)*A + invKmatrix(4)*B;
    end

[Aout,Bout] = arrayfun(@DoStuff,A,B);
end

 
