function sat = summedAreaTableND(data,templatePadSize)
%SUMMEDAREATABLEND zero pads data by templatePadSize then takes the summed
%area table, a local sum of size templatePadSize of the data.  the returned
%sat is size = size(data) + templatePadSize - 1
%note: this function was tested using the fact that a convolution with a
%ones kernel with templatePadSize should be equal to this function, but
%with faster runtime speed, eg. convn(data,ones(padSize)) and even
%convFFTND(data,ones(padSize)) for large datasets
% requirements:
% size(templateSize) = size(data)
%
% notes:
% 20141231 - tested function against convn for several dimensions
% fchang@fas.harvard.edu

sat = padarray(data,templatePadSize);
numDims = ndims(data);

% takes cumulative sum for every dimension and subtract summed table sized
% at templatePadSize
for i = 1:numDims
    satSize = size(sat);
    c = cumsum(sat,i);
    clear('sat');
    % generate index to subtract from each other
    firstIDX = cell(numDims,1);
    secondIDX = cell(numDims,1);
    for j = 1:numDims
        if j == i
            % find leading and lagging edge of template of this
            % dimension to subtract from each other
            firstIDX{j} = 1+templatePadSize(j):satSize(j)-1;
            secondIDX{j} = 1:satSize(j)-templatePadSize(j)-1;
        else
            firstIDX{j} = 1:satSize(j);
            secondIDX{j} = 1:satSize(j);
        end
    end
    % subtract the summed tables
    sat = c(firstIDX{:}) - c(secondIDX{:});
end


% the above approach keeps writing to memory instead of simply summing the
% result, however, it is easy to program.  below is another approach in
% which the cumsum in all dimensions is done at once, and the
% subtraction/addition is done at the end.

% dimension dependent formula is referenced here:
% http://en.wikipedia.org/wiki/Summed_area_table
% satSize = size(sat);

% do summation in every dimension and generate basis vectors that specify
% the corners of that dimension.

% sat = padarray(data,templatePadSize);
% sizeSat = size(data);
% numDims = ndims(data);
% basisVecs = cell(numDims,1);
% for i = 1:numDims
%     sat = cumsum(data,i);
%     basisVecs{i} = [0,1];
% end
% basisVecsOutput = cell(1,numDims);
% [basisVecsOutput{:}] = ndgrid(basisVecs{:});
% satCoor = @(i) cellfun(@(x) x(i),basisVecsOutput);
% 
% for i = 1:numel(sat)
%     for dim_i = 1:2^numDims
%         sign_i = (-1)^(numDims - sum(cellfun(@(x) x(dim_i), basisVecsOutput)));
%         cornerCoor = satCoor(dim_i).*templatePadSize+1;
%         if sum(cornerCoor > sizeSat) == 0 
%         sat(i) = sign_i*sat(cornerCoor);
%         end
%     end
% end
% 
% test = @(x,y) sat(x,y) + sat(x-templatePadSize(1),y-templatePadSize(2)) - sat(x-templatePadSize(1),y) -sat(x,y-templatePadSize(2));
%
% this takes 0.4 seconds compared to 3 seconds on top, convolution takes 10
% seconds


end

