function fileName = returnFileName(filePath)
%RETURNFILENAME takes filePath and returns fileName
if iscell(filePath)
    fileName = cell(numel(filePath),1);
    for i = 1:numel(filePath)
         [~,fileNameCurrent,~] = fileparts(filePath{i});
        fileName{i} = fileNameCurrent;
    end
else
    [~,fileName,~] = fileparts(filePath);
end



end

