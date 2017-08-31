sigma = 1;
mu = 0;
mismatch = 0.85;

domains1 = -5:0.1:5;
domains2 = -5:0.2:5;
domains3 = -5:0.3:5;

gauss1 = normpdf(domains1,mu,sigma);
gauss2 = normpdf(domains2,mu,sigma);
gauss3 = normpdf(domains3,mu,sigma);

% no index mismatch
plot(domains1,gauss1,'-x');hold on;plot(domains2,gauss2,'-o');plot(domains3,gauss3,'-s');

% mismatch modeled as taking smaller steps in real life, but you 'think'
% you are taking the original steps

domains1sm = domains1*mismatch;
domains2sm = domains2*mismatch;
domains3sm = domains3*mismatch;

gauss1sm = normpdf(domains1sm,mu,sigma);
gauss2sm = normpdf(domains2sm,mu,sigma);
gauss3sm = normpdf(domains3sm,mu,sigma);

plot(domains1,gauss1sm,'x');hold on;plot(domains2,gauss2sm,'o');plot(domains3,gauss3sm,'s');
