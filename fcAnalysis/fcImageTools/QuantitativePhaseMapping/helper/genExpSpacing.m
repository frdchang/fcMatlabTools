function [expSpacing] = genExpSpacing(startExp,N)
%GENEXPSPACING for qpm i want to do exponential spacing after a startExp
%integer
% for example: 1.2.3.4.5.7.10.14....
% startExp = 5
% append the last one for anyways


startExp = max(startExp - 2,0);

leftOver = startExp+1:N - startExp;
NleftOver = 1:numel(leftOver);

leftOver = NleftOver.*(NleftOver-1)/2+1;
leftOver = startExp + leftOver;
leftOver(leftOver > N) = [];
expSpacing = [1:startExp, leftOver];
if expSpacing(end) < N
   expSpacing(end+1) = N; 
end
end

