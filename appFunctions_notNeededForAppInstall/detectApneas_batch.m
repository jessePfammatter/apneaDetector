% test the new script.

% load a file
tic
app.filespec = '/Volumes/cookieMonster/mj1lab_mirror/apneaProject/PLX Pleth Updated 190611/181002_PLX_Study_787_788_792_793/181002_PLX_Study_787_788_792_793_EDF/181002_PLX_Study_787_788_792_793_EDF.edf';
[ app.header] = edfread( app.filespec);
app.defaultSignal = 7;
app.SelectPlethChannelDropDown.Items =  app.header.label;
app.SelectPlethChannelDropDown.Value =  app.header.label(app.defaultSignal);
app.targetSignal = app.SelectPlethChannelDropDown.Value;

% import the file, this should be an EDF file
[ app.header,  app.breathSignal] = edfread( app.filespec, 'targetSignals', app.targetSignal); % can add 'targetSignals',targetSignal to only important relevant siganls
app.std_breathSignal = std( app.breathSignal);

% set the sample rate
app.fs =  app.header.frequency(1); % this sample rate gives shows 120 BPM for a rat which is about what we are looking for and matches the timing from the excel files that Jonathan provided.

% establish the time signal
app.totalSeconds = length( app.breathSignal) /  app.fs;
app.totalMinutes =  app.totalSeconds / 60;
app.timeSignal = 0:( app.totalSeconds/length( app.breathSignal)): app.totalSeconds;
app.timeSignal =  app.timeSignal(2:end);

% detect breaths and apneas
app.filteredSignal = filterAndNormalizePlethSignal(app.breathSignal, app.fs);
app.output = detectBreathsApneasAndSleepFromPleth(app.filteredSignal, app.fs);
                    
toc

%% plot apneas and breaths.

 p1 = plot( app.timeSignal, app.filteredSignal, 'k');
hold('on')
% plot the ideal signal
p2 = plot(app.timeSignal, app.output.ideal, 'c');        
% plot breath amplitudes
p3 = plot( app.output.peaks / app.fs, app.output.amplitudes, '.c', 'MarkerSize', 10);
% plot the breaths with < 60% tidal volume from the median breath, hypopneas
p5 = plot( app.output.peaks(app.output.potentialHypopneas) / app.fs, app.output.amplitudes(app.output.potentialHypopneas), 'b.', 'MarkerSize', 8);
% plot clustered Sighs
p4 = plot( app.timeSignal(app.output.peaks(app.output.postSighApneaIndex)), app.output.amplitudes(app.output.postSighApneaIndex), 'or');
xlim([0 max(app.timeSignal)]);
ylim([-10 10]);
% loop through all of the apneas and plot them on the graph
for i = 1:size(app.output.apneaDurations, 2)
    temp = app.output.peaks(app.output.apneaIndex(i)):(app.output.peaks(app.output.apneaIndex(i)) + (app.output.apneaDurations(i) * app.fs));
    plot( app.timeSignal(temp), ones(length(temp), 1) * 5, 'r', 'linewidth', 15)
end
%msp = plot(app.timeSignal(temp), ones(length(temp), 1) * 5, 'r', 'linewidth', 5); % for legend
%plotSleepPeriods

for jj = 1:length(app.output.wakeStarts)
    temp = app.output.wakeStarts(jj):app.output.wakeStarts(jj)+app.output.wakeDurations(jj);
    plot( app.timeSignal(temp), ones(length(temp), 1) * -3, 'g', 'linewidth', 10)
end

%% plot event singal

app.eventInspectorBuffer = app.fs * 5;
figure
app.whichEvent = 1;
temp = app.output.peaks(app.output.apneaIndex(app.whichEvent)):(app.output.peaks(app.output.apneaIndex(app.whichEvent)) + (app.output.apneaDurations(app.whichEvent) * app.fs));
plotStart = temp(1) - app.eventInspectorBuffer;
plotEnd = plotStart + (app.eventInspectorBuffer * 3);

plot(app.timeSignal(plotStart:plotEnd), app.filteredSignal(plotStart:plotEnd), 'k')
hold on

% plot the ideal signal
p2 = plot(app.timeSignal(plotStart:plotEnd), app.output.ideal(plotStart:plotEnd), 'c');        

% plot breath amplitudes
p3 = plot(app.output.peaks / app.fs, app.output.amplitudes, '.c', 'MarkerSize', 10);

% plot the breaths with < 60% tidal volume from the median breath, hypopneas
p5 = plot(app.output.peaks(app.output.potentialHypopneas) / app.fs, app.output.amplitudes(app.output.potentialHypopneas), 'b.', 'MarkerSize', 8);

% plot clustered Sighs
p4 = plot(app.timeSignal(app.output.peaks(app.output.postSighApneaIndex)), app.output.amplitudes(app.output.postSighApneaIndex), 'or');

xlim([app.timeSignal(plotStart), app.timeSignal(plotEnd)]);
%app.filteredSignalWindow.YLim = [-std(app.filteredSignalWindow) * app.filteredSignalYlimScaleFactor, std(app.filteredSignalWindow) * app.filteredSignalYlimScaleFactor];
ylim([-10 10]);

% loop through all of the apneas and plot them on the graph
for i = 1:size(app.output.apneaDurations, 2)
    temp = app.output.peaks(app.output.apneaIndex(i)):(app.output.peaks(app.output.apneaIndex(i)) + (app.output.apneaDurations(i) * app.fs));
    plot(app.timeSignal(temp), ones(length(temp), 1) * 5, 'r', 'linewidth', 15)
end
%msp = plot(app.timeSignal(temp), ones(length(temp), 1) * 5, 'r', 'linewidth', 5); % for legend

%% import human apnea scores


[file,  path] = uigetfile('*.csv', 'Pick an Apnea Score File');            
app.humanScoreFilesep = strcat( path,  file);app.humanScore = importfile_humanApneaScores(app.humanScoreFilesep);
app.humanScore = importfile_humanApneaScores(app.humanScoreFilesep);
app.humanScore = app.humanScore(app.humanScore.Duration >= app.output.apneaThreshold, :); % only scores above the same apnea threshold as the computer set.
           

%% plot the clustering

figure
app.highCutIEI = 6;
app.tidalVolCut = 3000;
app.highCutAmplitudes = 25;
        
plot(app.output.iei(~app.output.theseAreMissedBreaths(1:end-1)), app.output.amplitudes(~app.output.theseAreMissedBreaths(1:end-1)), 'b.') % these are non-apnea related breaths
hold on
grid on

xlim([0, app.highCutIEI]);
ylim([0, app.highCutAmplitudes]);

plot(app.output.iei(app.output.spontaneousApneaIndex), app.output.amplitudes(app.output.spontaneousApneaIndex), 'k.')
plot(app.output.iei(app.output.postSighApneaIndex), app.output.amplitudes(app.output.postSighApneaIndex), 'ro')

legend({'nonApneas', 'noSighApnea', 'sighApnea'})
%datacursormode(app.breathClusteringPlot, 'off')



app.whichEvent = 70
delete(app.tempMarkerCluster)
app.tempMarkerCluster = plot(app.output.iei(app.output.apneaIndex(app.whichEvent)) , app.output.amplitudes(app.output.apneaIndex(app.whichEvent)), '.r', 'markersize', 35); 

            %%


            

            if isfield(app, 'humanScore')
                for i = 1:size(app.humanScore, 1)
                    startTime = app.humanScore.StartTime(i);
                    endTime = startTime + app.humanScore.Duration(i);
                    temp = startTime:endTime;
                    plot(app.filteredSignalWindow, temp, ones(length(temp), 1) * 6, 'm', 'linewidth', 15)
                end
            end


            
            