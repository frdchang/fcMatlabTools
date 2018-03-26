function theta0s = updateTheta0s(theta0s,numericTheta0s)
%UPDATETHETA0S since theta0s is a cell array with a k matrix in front, the
%numeric theta0s needs to be merged in.  this is the function that will do
%that.

% take care of kmatrix
lastIndex = numel(theta0s{1});
theta0s{1}(:) = numericTheta0s(1:lastIndex);
% go through each channels
lastIndex = lastIndex +1;

for ii = 2:numel(theta0s)
   for jj = 1:numel(theta0s{ii})
       if isobject(theta0s{ii}{jj}{1})
          % this is a shape model
          sizeParams = numel(theta0s{ii}{jj}{2});
          theta0s{ii}{jj}{2} = numericTheta0s(lastIndex:lastIndex+sizeParams-1)';
          lastIndex = lastIndex + sizeParams;
       else
           % this is a scalar background 
           theta0s{ii}{end}{1} = numericTheta0s(lastIndex);
           lastIndex = lastIndex+1;
       end
   end
end


end

