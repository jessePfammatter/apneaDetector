function compareApneaScores(app)
% script that compares two sets of apnea scores and creates a confusion
% matrix.

for i = 1:length(app.output.apneaIndex)
    a = app.output.ends(app.output.apneaIndex(i)):(app.output.ends(app.output.apneaIndex(i)) + (app.output.apneaDurations(i) * app.fs)); % here is the duration of the signal that the computer thought was an apnea
    a = app.timeSignal(a);
    a = min(round(a, 1)):0.01:max(round(a, 1));
    clear tp_temp2
    for j = 1:size(app.humanScore,1)
        startTime = app.humanScore.StartTime(j);
        endTime = startTime + app.humanScore.Duration(j);
        b = startTime:endTime;
        b = min(round(b, 1)):0.01:max(round(b, 1));
        tp_temp = intersect(a, b);
        if length(tp_temp) > 0
            tp_temp2(j) = 1;
        else
            tp_temp2(j) = 0;
        end
        if sum(tp_temp2) > 0 
            tp_apneaScores(i) = 1;
        else
            tp_apneaScores(i) = 0;
        end
    end
end
app.tp_apneaScores = sum(tp_apneaScores);
app.fp_apneaScores = length(app.output.apneaIndex) - app.tp_apneaScores;
app.fn_apneaScores = size(app.humanScore, 1) - app.tp_apneaScores;
app.tn_apneaScores = length(app.output.starts) - app.tp_apneaScores;
app.confusionMat_apneaScores = abs([app.tn_apneaScores, app.fn_apneaScores; app.fp_apneaScores, app.tp_apneaScores]); % this shouldnt have to be an absolute value so it's just a temporary fix.    
    
end