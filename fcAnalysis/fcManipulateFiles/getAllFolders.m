function folderList = getAllFolders(dirName,varargin)
%GETALLFOLDERS will recursively grab all the folders in dirName

if isunix
    [status,cmdout] = unix(['find ' dirName ' -type d']);
    cmdout = textscan(cmdout,'%s','delimiter','\n');
    cmdout = cmdout{1};
    % match dir at beging of line, this filters non folder statements
    folderList =  keepCertainStrings(cmdout,['^' dirName]);
    if ~isempty(varargin)
        regexpFilterkey = varargin{1};
        folderList = keepCertainStrings(folderList,regexpFilterkey);
    end
else
    dirData = dir(dirName);
    dirIndex = [dirData.isdir];  % Find the index for directories
    folderList = {dirData(dirIndex).name}';  % Get a list of the files
    validIndex = ~ismember(folderList,{'.','..'});  % Find index of subdirectories
    folderList = folderList(validIndex);
    if ~isempty(varargin)
        regexpFilterkey = varargin{1};
        folderList =  keepCertainStrings(folderList, regexpFilterkey);
    end
    if ~isempty(folderList)
        folderList = cellfun(@(x) fullfile(dirName,x),...  % Prepend path to files
            folderList,'UniformOutput',false);
    end%   that are not '.' or '..'
    for iDir = 1:numel(folderList)                % Loop over valid subdirectories
        nextDir = folderList{iDir};    % Get the subdirectory path
        if isempty(varargin)
            folderList = [folderList;  getAllFolders(nextDir)];  % Recursively call getAllFiles
        else
            folderList = [folderList; getAllFolders(nextDir,varargin{1})];  % Recursively call getAllFiles
        end
    end
end

end