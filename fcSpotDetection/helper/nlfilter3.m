function b = nlfilter3(varargin)
%NLFILTER3 is a modification of nlfilter but allows 3d data to be
%processed.  
%
% tested with the following:
% >>sample = round(100*rand(1024,1024,11));
% >>myFunc = @(x) sum(x(:));
% >>tic; test = nlfilter3(sample,[7,7,7],myFunc); toc
% Elapsed time is 165.399632 seconds.
% >>tic;corpus = convn(sample,ones(7,7,7),'same');toc
% Elapsed time is 2.316976 seconds.
% >>isequal(corpus,test)
% 
% fchang@fas.harvard.edu 

[a, nhood, fun, params, padval] = parse_inputs(varargin{:});

% Expand A
[ma,na,oa] = size(a);
aa = repmat(feval(class(a), padval), size(a)+nhood-1);
aa(floor((nhood(1)-1)/2)+(1:ma),floor((nhood(2)-1)/2)+(1:na),floor((nhood(3)-1)/2)+(1:oa)) = a;

% Find out what output type to make.
rows = 0:(nhood(1)-1);
cols = 0:(nhood(2)-1);
zs   = 0:(nhood(3)-1);
b = repmat(feval(class(feval(fun,aa(1+rows,1+cols,1+zs),params{:})), 0), size(a));
% create a waitbar if we are able
if images.internal.isFigureAvailable()
    wait_bar = waitbar(0,'Applying neighborhood operation in 3D...');
else
    wait_bar = [];
end

% Apply fun to each neighborhood of a
for i=1:ma
    for j=1:na
        for k = 1:oa
            x = aa(i+rows,j+cols,k+zs);
            b(i,j,k) = feval(fun,x,params{:});
        end
    end
    % udpate waitbar
    if ~isempty(wait_bar)
        waitbar(i/ma,wait_bar);
    end
end

close(wait_bar);


%%%
%%% Function parse_inputs
%%%
function [a, nhood, fun, params, padval] = parse_inputs(varargin)

blockSizeParamNum = 2;

switch nargin
    case {0,1,2}
        error(message('images:nlfilter:tooFewInputs'))
    case 3
        if (strcmp(varargin{2},'indexed'))
            error(message('images:nlfilter:tooFewInputsIfIndexedImage'))
        else
            % NLFILTER(A, [M N], 'fun')
            a = varargin{1};
            nhood = varargin{2};
            fun = varargin{3};
            params = cell(0,0);
            padval = 0;
        end
        
    otherwise
        if (strcmp(varargin{2},'indexed'))
            % NLFILTER(A, 'indexed', [M N], 'fun', P1, ...)
            a = varargin{1};
            nhood = varargin{3};
            fun = varargin{4};
            params = varargin(5:end);
            padval = 1;
            blockSizeParamNum = 3;
            
        else
            % NLFILTER(A, [M N], 'fun', P1, ...)
            a = varargin{1};
            nhood = varargin{2};
            fun = varargin{3};
            params = varargin(4:end);
            padval = 0;
        end
end

if (isa(a,'logical') || isa(a,'uint8') || isa(a,'uint16'))
    padval = 0;
end

% Validate 2D input image
validateattributes(a,{'logical','numeric'},{'3d'},mfilename,'A',1);

% Validate neighborhood
validateattributes(nhood,{'numeric'},{'integer','row','positive','nonnegative','nonzero'},mfilename,'[M N]',blockSizeParamNum);
if (numel(nhood) ~= 3)
    error(message('images:nlfilter:invalidBlockSize'))
end

fun = fcnchk(fun,length(params));
