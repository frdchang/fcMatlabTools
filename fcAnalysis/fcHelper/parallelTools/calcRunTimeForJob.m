function [ runTimeInSec ] = calcRunTimeForJob( job )
%CALCRUNTIMEFORJOB Summary of this function goes here
%   Detailed explanation goes here

tStart = datetime(job.StartTime,'InputFormat','eee MMM d HH:mm:ss ZZZZ y','TimeZone','America/Chicago');

if isempty(job.FinishTime)
tNow = datetime;
tNow.TimeZone = tStart.TimeZone;

else
   tNow = datetime(job.FinishTime,'InputFormat','eee MMM d HH:mm:ss ZZZZ y','TimeZone','America/Chicago');
end

runTimeInSec = seconds(tNow-tStart);
end

