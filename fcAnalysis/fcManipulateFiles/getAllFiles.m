function fileList = getAllFiles(dirName,varargin)
%GETALLFILES will look inside dirName and find all the files
% getAllFiles('/dirPATH');
% getAllFiles('/dirPATH','^.[0-9]$'); will filter the result by regexpkey
% getAllFiles({'/dirPATH1','/dirPATH2'});
%
% fchang@fas.harvard.edu

if iscell(dirName)
   fileList = cell(numel(dirName),1);
   for i = 1:numel(dirName)
      if nargin == 1
          fileList{i} =  getAllFilesGivenDir(dirName{i},'.');
      else
         fileList{i} =  getAllFilesGivenDir(dirName{i},varargin{1}); 
      end
      
   end
   fileList =  flattenCellArray(fileList);
else
   fileList = getAllFilesGivenDir(dirName,varargin{1});
end


end

function fileList = getAllFilesGivenDir(dirName,varargin)
%GETALLFILESGIVENDIR returns files given a single directory dirName

if isunix
    [status,cmdout] = unix(['find ' dirName ' -type f']);
    if isempty(cmdout)
        fileList = [];
        return;
    end
    cmdout = textscan(cmdout,'%s','delimiter','\n');
    cmdout = cmdout{1};
    fileList = cmdout;
    % match dir at beging of line, this filters non folder statements
    if ~isempty(varargin)
        regexpFilterkey = varargin{1};
        fileList = keepCertainStringsUnion(cmdout,regexpFilterkey);
    end
    
else
    dirData = dir(dirName);      % Get the data for the current directory
    dirIndex = [dirData.isdir];  % Find the index for directories
    fileList1 = {dirData(~dirIndex).name}';  % Get a list of the files
    if ~isempty(varargin)
        regexpFilterkey = varargin{1};
        fileList =  keepCertainStringsUnion(fileList1, regexpFilterkey);
    else
        fileList = fileList1;
    end
    if ~isempty(fileList)
        fileList = cellfun(@(x) fullfile(dirName,x),...  % Prepend path to files
            fileList,'UniformOutput',false);
    end
    subDirs = {dirData(dirIndex).name};  % Get a list of the subdirectories
    validIndex = ~ismember(subDirs,{'.','..'});  % Find index of subdirectories
    %   that are not '.' or '..'
    for iDir = find(validIndex)                  % Loop over valid subdirectories
        nextDir = fullfile(dirName,subDirs{iDir});    % Get the subdirectory path
        if isempty(varargin)
            fileList = [fileList; getAllFiles(nextDir)];  % Recursively call getAllFiles
        else
            fileList = [fileList; getAllFiles(nextDir,varargin{1})];  % Recursively call getAllFiles
        end
        
    end
end
end