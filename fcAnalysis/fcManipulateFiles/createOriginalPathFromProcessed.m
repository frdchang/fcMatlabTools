function originalPath = createOriginalPathFromProcessed(yourProcessedPath)
%CREATEORIGINALPATHFROMPROCESSED will go back from the processed path to
%the original path

checkInTheseFolders = {'fcData','fcTest','fcCheckout'};

yourProcessedPath = regexprep(yourProcessedPath,'^~',getHomeDir);

[path,filename,ext] = fileparts(yourProcessedPath);

% find the function name in brackets
functionName = regexp(filename,'\[(.*?)]','match');
functionName = functionName{1};
% find it in the path and remove it
functionNameInPathIndex = findstr(path,functionName);
if ~isempty(functionNameInPathIndex)
    path = path(1:functionNameInPathIndex-1);
end
% now check if filename is in either {fcData,fcTest,fcCheckout}

for ii = 1:numel(checkInTheseFolders)
   checkPath = regexprep(path,'fcProcessed',checkInTheseFolders{ii});
   if exist(checkPath,'dir')==7
       
   end
end

