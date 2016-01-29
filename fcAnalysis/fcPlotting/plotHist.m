function h = plotHist(data,varargin)
%PLOTHIST will histogram nd Data

h=histogram(double(data(:)),varargin{:});

end

