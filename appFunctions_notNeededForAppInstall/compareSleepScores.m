function compareSleepScores(app)
% script that compares two sets of apnea scores and creates a confusion
% matrix.

signalLengthSeconds = floor(length(app.filteredSignal) / app.fs);
signalLength = length(app.filteredSignal);

% create a sleep ideal signal for the computer
computerIdealInd = 1:signalLength;
computerSleepSearchIndex = [];
for i = 1:length(signalLength)
    tempRange = app.output.wakeStarts(i):app.output.wakeEnds(i);
    computerSleepSearchIndex = [computerSleepSearchIndex, tempRange];
end
    
computerIdeal = ismember(computerIdealInd, computerSleepSearchIndex);
computerIdeal = ~computerIdeal;
    
computerIdealSeconds = zeros(signalLengthSeconds, 1);
for i = 1:signalLengthSeconds
    tempEnd = i * app.fs;
    tempStart = tempEnd - app.fs+1;
    if sum(computerIdeal(tempStart:tempEnd)) > 0
        computerIdealSeconds(i) = 1;
    end
end
    
% create a sleep ideal signal for the human
humanIdealInd = 1:signalLengthSeconds;
humanSleepSearchIndex = [];
for i = 1:length(app.humanSleepScore.StartTime1)
    tempRange = app.humanSleepScore.StartTime1(i):app.humanSleepScore.EndTime1(i);
    humanSleepSearchIndex = [humanSleepSearchIndex, tempRange];
end
humanIdeal = ismember(humanIdealInd, humanSleepSearchIndex);

app.confusionMat_sleepScores = confusionmat(computerIdealSeconds, double(humanIdeal'));      
app.tp_sleepScores = app.confusionMat_sleepScores(1);
app.fp_sleepScores = app.confusionMat_sleepScores(2);
app.fn_sleepScores = app.confusionMat_sleepScores(3);
app.tn_sleepScores = app.confusionMat_sleepScores(4);

end
