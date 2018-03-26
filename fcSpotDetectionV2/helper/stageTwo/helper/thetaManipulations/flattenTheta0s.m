function flattenTheta0s = flattenTheta0s(theta0s)
%FLATTENTHETA0S will flatten the cell structure of theta0s

% take care of kmatrix
flattenTheta0s = theta0s{1}(:);
% go through each channels
for ii = 2:numel(theta0s)
   for jj = 1:numel(theta0s{ii})
       if isobject(theta0s{ii}{jj}{1})
          % this is a shape model
          flattenTheta0s = [flattenTheta0s ;theta0s{ii}{jj}{2}(:)];
       else
          flattenTheta0s = [flattenTheta0s ;theta0s{ii}{jj}{1}];
       end
   end
end


