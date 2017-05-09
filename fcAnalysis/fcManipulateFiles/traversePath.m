function [ newPath ] = traversePath( myPath,goUpNSteps)
%TRAVERSEPATH will go back N steps

newPath = regexp(myPath, filesep, 'split');
newPath = strjoin(newPath(1:end-(goUpNSteps+1)),filesep);
end

