function [processedFilePath,processedPathOnly] = createProcessedDir(fullPathToFile,varargin)
%CREATEPROCESSEDDIR will take a full path such as:
% 1) /.../fcData/.../filename 
% or 
% 2) /.../fcTest/.../filename
% 3) /.../fcCheckout/.../filename
% 
% and return /.../processedData/.../filename
%            /.../processedTestData/.../filename
%
% additional argument will append string to filename

fullPathToFile = regexprep(fullPathToFile,'^~',getHomeDir);

processedPath = regexprep(fullPathToFile,{'/fcData/','fcTest/','fcCheckout/'},{'/fcProcessed/'});
processedPathOnly = returnFilePath(processedPath);

if isempty(varargin)
    % just return processedPath without appending
    processedFilePath = processedPath;
else
    % return appending name to filename
    appendName = varargin{1};
    fileName = returnFileName(processedPath);
    fileName = strcat([appendName '-'],fileName);
    processedFilePath = strcat(processedPathOnly,filesep,fileName);
end


end
