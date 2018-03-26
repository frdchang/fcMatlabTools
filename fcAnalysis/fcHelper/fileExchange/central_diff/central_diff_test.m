% script to test MATLAB's gradient routine and compare to central_diff
%
%  Written by:   Robert A. Canfield
%  email:        bob.canfield@vt.edu
%
%  Created:      10/19/00
%  Modified:     10/01/15
%
%  MATLAB's gradient function is incorrect for unevenly spaced coordinates.
%  This central_diff function uses the correct formula.
%  Tested with MATLAB versions 5.2, 5.3.1, 8.3, and 8.6.
%
% Alternatively, you may patch MATLAB's gradient function by 
% replacing the lines...
%   % Take centered differences on interior points
%   if n > 2
%      h = h(3:n) - h(1:n-2);
%      g(2:n-1,:) = (f(3:n,:)-f(1:n-2,:))./h(:,ones(p,1));
%   end
%
% with...
%   % Take centered differences on interior points
%   if n > 2
%      if all(abs(diff(h,2)) < eps) % only use for uniform h (RAC)
%         h = h(3:n) - h(1:n-2);
%         g(2:n-1,:) = (f(3:n,:)-f(1:n-2,:))./h(:,ones(p,1));
%      else   % new formula for un-evenly spaced coordinates (RAC)
%         h = diff(h); h_i=h(1:end-1,ones(p,1)); h_ip1=h(2:end,ones(p,1));
%         g(2:n-1,:) =  (-(h_ip1./h_i).*f(1:n-2,:) + ...
%                         (h_i./h_ip1).*f(3:n,:)   )./ (h_i + h_ip1) + ...
%                         ( 1./h_i - 1./h_ip1 ).*f(2:n-1,:);
%      end
%   end

%--Modifications
%  10/23/00
%  10/01/01 - Copyright (c) 2001 Robert A. Canfield (BSD License)
%  10/01/15 - loop over two cases and spacing

clear; clc
x0 = 1:pi/20:pi;
perturb = pi/40;
grad_error = zeros(2,3,2);
old=1;  new=2;
even=1; uneven=2;
% Demsontration that MATLAB's gradient function is inaccurate
% for unevenly spaced coordinate data, using the sin function.
for iter=old:new
   switch iter
      case old
         disp('For MATLAB gradient function used on sin(x) ...')
         differentiate = @gradient;
      case new
         disp('For central_diff ...')
         differentiate = @central_diff;
   end
   for spacing=even:uneven
      x  = x0;
      switch spacing
         case even
            space='even';
         case uneven
            space='uneven';
            i = 2:2:length(x);
            x(i) = x0(i) + perturb;
      end
      yp = differentiate( sin(x), x );
      grad_error(spacing,:,iter) = [max(cos(x)-yp), min(cos(x)-yp), mean(abs(cos(x)-yp))];
      disp(['Maximum error with ',space,' spacing =  ',num2str(max(yp-cos(x)))])
      disp(['Minimum error with ',space,' spacing = ', num2str(min(yp-cos(x)))])
      disp(['Mean absolute error with ',space,' spacing = ',num2str(mean(abs(yp-cos(x))))])
      disp(' ')
   end
   disp('Ratio of uneven to even spacing true error for max, min, mean')
   disp(grad_error(uneven,:,iter)./grad_error(even,:,iter))
   disp(' ')
end
disp('Even-spacing ratio of gradient-to-central_diff true error for max, min, mean')
disp(grad_error(even,:,1)./grad_error(even,:,2))
disp('Uneven-spacing ratio of gradient-to-central_diff true error for max, min, mean')
disp(grad_error(2,:,1)./grad_error(1,:,2))
