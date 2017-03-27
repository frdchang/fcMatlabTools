function modelsummedSq = calcModelSquaredForLL1(Kmatrix,As,Bs,k1,k3,k5)
%CALCMODELSQUARED calculates the (A*F+B+...)^2 by expanding the quadratic
%and then summing the terms
modelsummedSq = 0;
for ii = 1:size(Kmatrix,2)
    tempAs = cell(size(As));
    tempBs = cell(size(Bs));
    for jj = 1:size(Kmatrix,1)
        tempAs{jj} = As{jj}*Kmatrix(ii,jj);
        tempBs{jj} = Bs{jj}*Kmatrix(ii,jj);
    end
    modelsummedSq = modelsummedSq + givenABs(tempAs,tempBs,k1{ii},k3{ii},k5);
end

end


function modelsummedSq = givenABs(As,Bs,k1,k3,k5)
AandB = interleave(As,Bs);
kIndicator = zeros(numel(AandB),1);
kIndicator(1:2:end) = 2;
kIndicator(2:2:end) = 1;
useK = kIndicator*kIndicator';

kholder = {k5,k1,0,k3};

modelsummedSq = 0;
for ii = 1:numel(AandB)
    for jj = 1:numel(AandB)
        modelsummedSq = modelsummedSq+ AandB{ii}.*AandB{jj}.*kholder{useK(ii,jj)};
    end
end

end

% function modelsummedSq = givenABs(As,Bs,k1,k3,k5,spotKerns,convFunc,invVarSaved)
% % assuming its k11*A1*F1, K11*B1, K21*A2*F2, K21*B2
%
% AandB = interleave(As,Bs);
%
% onesAsCellArray = cell(size(spotKerns));
% onesAsCellArray(:) = {1};
% singleSpotTerms = interleave(spotKerns,onesAsCellArray);
%
% modelsummedSq = 0;
% % calcualte squared terms
% for ii = 1:numel(AandB)
%     if isodd(ii)
%         modelsummedSq = modelsummedSq+ AandB{ii}.*AandB{ii}.*k3;
%     else
%         modelsummedSq = modelsummedSq+ AandB{ii}.*AandB{ii}.*k5;
%     end
% end
%
% % calculate single spot kern terms
% for ii = 1:numel(AandB)
%    for jj = ii+1:2:numel(AandB)
%            modelsummedSq = modelsummedSq + 2*AandB{ii}.*AandB{jj}.*k1;
%    end
% end
%
% % calculate cross terms
% for ii = 1:numel(AandB)
%     for jj = ii+2:2:numel(AandB)
%         currCrossKern= singleSpotTerms{ii}.*singleSpotTerms{jj};
%         if isequal(1,currCrossKern)
%             modelsummedSq = modelsummedSq + 2*AandB{ii}.*AandB{jj}.*k5;
%         else
%            modelsummedSq = modelsummedSq + 2*AandB{ii}.*AandB{jj}.*convFunc(invVarSaved,currCrossKern);
%         end
%     end
% end
%
%
%
%
%
% % modelsummedSq = 0;
% % for ii = 1:numel(AandB)
% %     for jj = 1:numel(AandB)
% %         modelsummedSq = modelsummedSq+ AandB{ii}.*AandB{jj}.*kholder{useK(ii,jj)};
% %     end
% % end
%
% end


%     % calculate cross terms for spotKern
%     numKerns = numel(spotKern);
%     numCrossTerms = ((numKerns-1)^2) + (numKerns-1)/2;
%     crossSpotKerns = cell(numCrossTerms,1);
%     myIndex = 1;
%     for ii = 1:numel(spotKern)
%         for jj = ii+1:numel(spotKern)
%             crossSpotKerns{myIndex} = convFunc(invVarSaved,spotKern{ii}.*spotKern{jj});
%             myIndex = myIndex+1;
%         end
%     end