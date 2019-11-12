function output = detectBreathsApneasAndSleepFromPleth(filteredPlethSignal, unfilteredPlethSignal, fs, humanSleepScore)

    % set to 1 if you want to see the final versions of the plotting fits... need to work on this xxx
    doPlot = 1;

    % establish the time signal
    totalSeconds = length( filteredPlethSignal) /  fs;
    totalMinutes =  totalSeconds / 60;
    
    % set some adjustable variables for breath detection.
    highThreshMultiplier = 0.40; % quantiles of the signal
    lowThreshMultiplier = 0.10;
    hypopneaThresh = 0.6; % percent of tidal volume
    normalBreath = 0.65; % seconds as a starting point. % xxx does this need to change for mice?
    apneaThresholdMultiplier = 2; % default multiplier which determins which breath gaps should be classified as apneas.
    breathGluerParam = floor(fs / (120 / 60) / 15); % value based on the expected heart rate of 120 bpm, and then a 15th of that, had as a 10th before.
    lowAmplitudesBreathStdMultiplier = 2.5; % stds
    breathCutoff = 200; % seconds? data points?
    breathRateSecsLowEnd = 0.5; % seconds
    breathRateSecsHighEnd = 0.95; % seconds
    
    % under this list are things people might want control of for sighs
    postSighPlusDurationMultiplier = 10; % breath lenghts, the number of breath lengths that you think should be inclusive of post sigh breaths
    sighsStdMultiplier = 4;
    sighTidalVolumeMultFactor = 4;
    sighArtifactDivisionFactor = 3;
    %sighMinMultiplier = 1; % xxx maybe remove this because it doesn't seem to work on many
    
    % sleepScoring adjustable variables.. perhaps make these adjustable for sleep.
    wakeDurationsCutoff = 60; % seconds, works well at 30 as well
    nStdsFromIIEContinuous = 3; % std deviations
    smoothDuration = 20; % works well at 30, go forwards and backwards for this smoothing
    nSecs = 4; % seconds
    signalVariabilityThreshMultiplier = 4; % std deviations
    removeFromSleepRecord = 0; % seconds
    
    % create the first and second derivative signals
    output.filteredSignalFirstDerivative = gradient(filteredPlethSignal);
    
    
    % ----- % THIS IS ALL ABOUT BREATH DETECTION % ----- %
    
    % set defaults for highThreshList and lowThreshList and bufferList -- these are the three tunable parameters in this method
    std_filteredSignal = std(filteredPlethSignal); % we could tweak this value to ensure that its a stable measure regardless of the file type.. for example a median or mode value might be more consistent than std in records with lots of noise.
    highBreathThresh = std_filteredSignal * highThreshMultiplier; 
    lowBreathThresh = -std_filteredSignal * lowThreshMultiplier;

    [output.starts, output.ends, output.ideal] = twoThreshPeakDetect(filteredPlethSignal, highBreathThresh, lowBreathThresh);
    output.ideal(output.ideal > 0) = 1;

    % glue together events that are super close. This is technically a tunable parameter
    for i = 1:length(output.starts) - 1
        if output.starts(i + 1) - output.ends(i) < breathGluerParam
            output.ideal(output.ends(i):output.starts(i+1)) = 1;
        end
    end

    output.starts = [];
    output.ends = [];
    output.starts = find(diff(output.ideal) == 1);
    output.ends = find(diff(output.ideal) == -1);

    % use use the min value of the filtered signal between each breath to find the real breath start and stop
    clear starts2
    for i = 1:length(output.starts)

        % find min of the signal before the start and within 1 average breath

        % find the zero crossings using the first derivative
        temp = fliplr(output.filteredSignalFirstDerivative(output.starts(i) - breathCutoff:output.starts(i)));
        index = zci(temp);

        if isempty(index)
            index = breathCutoff;
        end

        % then map that index back to the signal.
        temp = output.starts(i) - index(1);

        if i > 1
            if temp < output.ends(i - 1)
                starts2(i) = output.ends(i);
            else
                starts2(i) = output.starts(i) - index(1);
            end
        else
            starts2(i) = output.starts(i) - index(1);
        end
    end

    % now use the min between the end of the breath and the start of the next breath to dictate the new end of the breath
    ends2 = output.ends;

    for i = 1:length(output.ends) - 1 % this stops one short, and the last breaths end does not change

        temp = output.filteredSignalFirstDerivative(output.ends(i): starts2(i + 1));
        % find the zero crossings using the first derivative
        index = zci(temp);
        if isempty(index)
            index = length(temp);
        end

        % then map that index back to the signal.
        ends2(i) = output.ends(i) + index(1);  

    end

    % make a new ideal signal based on the new start and end points
    ideal2 = zeros(1, length(output.ideal));

    % find peaks within each breath and amplitudes of these peaks -- this is using the filtered signal instead of the original signal but it's just for plotting purposes
    for i = 1:length(starts2)
        tempSignal = filteredPlethSignal(starts2(i):ends2(i));
        [pks, locs] = findpeaks(tempSignal);
        [value, index] = max(pks);
        output.peakProminence(i) = range(tempSignal);
        if isempty(value)
            output.amplitudes(i) = 0;
            output.peaks(i) = starts2(i);
        else
            output.amplitudes(i) = value;
            output.peaks(i) = starts2(i) + locs(index) - 1;
        end
    end

    % make the ideal signal the amplitude of the breath
    for i = 1:length(starts2)
        ideal2(starts2(i):ends2(i)) = output.amplitudes(i);
    end

    % calculate the iei, from peak to peak.          
    output.iei = diff(output.peaks);

    % calculate the duration of each event, from start to end
    clear durations
    for i = 1:length(starts2)
        output.durations(i) = ends2(i) - starts2(i);
    end

    % find the breaths per minute
    totalBreaths = length(starts2);
    output.BPM = totalBreaths / totalMinutes;

    output.starts = starts2;
    output.ends = ends2;
    output.ideal = ideal2;
    output.iei = output.iei / fs; % in seconds
    output.durations = output.durations / fs; % in seconds

    % fit a distribution to the histogram of event durations, find the peak around where a normal breath rythm usually occurs
    temp = output.iei;
    temp(temp > 10) = mean(output.iei);
    hfit = histfit(temp, 100, 'kernel');
    xlabel('IEI (s)');
    ylabel('Counts');
    y = hfit(1).YData;
    x = hfit(1).XData;
    guess = [0.2, 0.2, 2500, 0.7, 0.2,  7000];
    options = optimset('MaxFunEvals', 1000);
    [guess, ~] = fminsearch( 'fit_gauss2', guess, options, x, y, 0);
    hold on;

    [mu1, sig1, amp1, mu2, sig2, amp2 ] = deal(  guess(1), guess(2), guess(3), guess(4), guess(5), guess(6));
    est = amp1.*exp(-(x-mu1).^2./sig1.^2) + amp2.*exp(-(x-mu2).^2./sig2.^2);

    if doPlot == 1
        bar(x, y);
        plot(x, est, 'g');
        title('Hist/Fit', 'interpreter', 'none');
        xlabel('IEI (s)');
    end
    
    hold off;

    temp = abs([mu1, mu2] - normalBreath);
    [~, b] = min(temp);

    if b == 1
        mu = mu1;
        amp = amp1;
        sig = sig1;
    else
        mu = mu2;
        amp = amp2;
        sig = sig2;
    end

    % now find the tidal volume of all the events with a duration matching the 
    ieiLow = mu - (sig);
    ieiHigh = mu + (sig);
    keepInd = output.durations > ieiLow & output.durations < ieiHigh;

    iei_mu = mu;
    iei_sig = sig;

    % now find all of the breaths with normal rythm that have a normal amplitude
    
    % this restricts the range so that the histogram function works preoperly.
    temp = output.amplitudes(keepInd);
    temp(temp > 15) = mean(output.amplitudes);
    hfit = histfit(temp, 100, 'kernel');
    xlabel('Amplitudes');    
    ylabel('Counts');
    y = hfit(1).YData;
    x = hfit(1).XData;

    guess = [1, 1, 1200];
    [guess, ~] = fminsearch( 'fit_gauss', guess, options, x, y, 0);
    hold on;

    [mu1, sig1, amp1 ] = deal(  guess(1), guess(2), guess(3));
    est = amp1.*exp(-(x-mu1).^2./sig1.^2);

    if doPlot == 1
        bar(x, y);
        plot(x, est, 'g');
        title('Hist/Fit', 'interpreter', 'none');
        xlabel('Duration between Breaths (s)');
    end
    hold off;

    % now delete all breaths with really low amplitude
    amplitudesLow = mu1 - (sig1 * lowAmplitudesBreathStdMultiplier);
    keepInd = output.amplitudes > amplitudesLow;
    %keepInd = output.peakProminence > amplitudesLow;
    amplitude_mu = mu1;
    amplitude_sig = sig1;

    % save the high amplitude cutoff to figure out which breaths are sighs
    output.sighsThreshold = amplitude_mu + (amplitude_sig * sighsStdMultiplier);
    
    %{
    
    
    xxx
    
    % find the just outside the normal range of the raw signal in order to set a cutoff of for the low side of the sighs
    temp = filteredPlethSignal(filteredPlethSignal > -15 & filteredPlethSignal < 15);
    hfit = histfit(temp, 100, 'kernel');
    y = hfit(1).YData;
    x = hfit(1).XData;
    guess = [0.2, 0.2, 3000, 0.7, 0.2,  200];
    [guess, ~] = fminsearch( 'fit_gauss', guess, options, x, y, 0);
    hold on;
    [mu1, sig1, amp1] = deal(  guess(1), guess(2), guess(3));
    est = amp1.*exp(-(x-mu1).^2./sig1.^2);
    %}
    
    % recreate the ideal signal
    output.oldIdeal = output.ideal; % keep the old signal to make comparisons
    deleteInd = ~keepInd;
    deleteIndInd = find(deleteInd);
    for i = 1:sum(deleteInd)
        dummy = deleteIndInd(i);
        dummy2 = output.starts(dummy):output.ends(dummy);
        output.ideal(dummy2) = 0;
    end

    % and reset all of these other variables
    output.amplitudes = output.amplitudes(keepInd);
    output.peakProminence = output.peakProminence(keepInd);
    output.starts = output.starts(keepInd);
    output.ends = output.ends(keepInd);
    output.peaks = output.peaks(keepInd);
    output.iei = diff(output.peaks) / fs;
    
    for i = 1:length(output.starts)
        durations2(i) =  output.ends(i) - output.starts(i);
    end
    output.durations = durations2 / fs;
    output.BPM = length(output.starts) / totalMinutes;


    % ----- % CALCULATE TIDAL VOLUME OF BREATHS % ----- %
    
    for i = 1:length(output.starts)
        xv = filteredPlethSignal(output.starts(i):output.ends(i)); % signal line, top of figure
        if length(xv) > 1
            unfilteredBreathMax(i) = max(unfilteredPlethSignal(output.starts(i):output.ends(i)));
            vq = interp1([output.starts(i), output.ends(i)],[unfilteredPlethSignal(output.starts(i)), unfilteredPlethSignal(output.ends(i))],output.starts(i):output.ends(i)); % interpolates the bottom line from 

            % this works but probably needs to be broken down into section where there are line crossing to get a more exact value (using the subtrction part.. If you just subtract the vq part then signals that have agregious line crossings are calculated v poorly.
            output.tidalVolume(i) = trapz(xv + abs(min(xv))) - trapz(vq + abs(min(xv)));              
            output.tidalVolume(i) = output.tidalVolume(i) * (size(xv, 2) /  fs ); % should provide tidal volume in L per breath in original units were L/s
            
            % count the number of line crossings for each plot such that we can optimize the correct detection positions
            output.linesCrossedPerBreath(i) = length(find((xv-vq) == 0)) - 2;
            
        else
            output.tidalVolume(i) = 0;
            output.linesCrossedPerBreath(i) = 99;
        end

    end

    % now figure out the average tidal volume of the average breath
    amplitudeInd = output.amplitudes > amplitude_mu - amplitude_sig & output.amplitudes < amplitude_mu + amplitude_sig;
    ieiInd = output.iei > iei_mu - iei_sig & output.iei < iei_mu + iei_sig;
    ieiInd = [ieiInd, 0];

    hfit = histfit(output.tidalVolume(amplitudeInd & ieiInd), 100, 'kernel');
    y = hfit(1).YData;
    x = hfit(1).XData; 
    guess = [200, 50, 800];
    [guess, ~] = fminsearch( 'fit_gauss', guess, options, x, y, 0);
    hold on;
    [mu1, sig1, amp1] = deal(  guess(1), guess(2), guess(3));

    output.sighTidalVolumeThresh = mu1 + (sig1 * sighTidalVolumeMultFactor);
    output.meanTidalVolume = mean(output.tidalVolume(amplitudeInd & ieiInd));
    output.mean_unfilteredBreathMax = mean(unfilteredBreathMax(amplitudeInd & ieiInd))
    
    % ----- % THIS IS WHERE SLEEP DETECTION HAPPENS % ----- %
        
    % break this into chuncks and calculate the line length
    signalSize = length(filteredPlethSignal);
    epochSize_samplePoints = nSecs * fs; % seconds * samplerate, 2 seconds a big or small enough window?
    nEpochs = floor(signalSize / epochSize_samplePoints);
    clear signalVariability
    for i = 1:nEpochs
        epochEnd = i * epochSize_samplePoints;
        epochStart = epochEnd - epochSize_samplePoints + 1;
        tempSignal = filteredPlethSignal(epochStart:epochEnd);
        signalVariability(i) = lineLength(tempSignal) ;
    end
    signalVariability = signalVariability - min(signalVariability);
        
    % now fit a gaussian to the histogram of signalVariabity to find the 'normal' sleep periods.
    temp = signalVariability(signalVariability < prctile(signalVariability, 98));
    hfit = histfit(temp, 100, 'kernel');
    xlabel('Durations (s)');
    ylabel('Counts');
    y = hfit(1).YData;
    x = hfit(1).XData;
    close gcf
    guess = [0.2, 0.2, 3000, 0.7, 0.2,  200];
    [guess, ~] = fminsearch( 'fit_gauss', guess, options, x, y, 0);
    hold on;
    [mu1, sig1, amp1] = deal(  guess(1), guess(2), guess(3));
    est = amp1.*exp(-(x-mu1).^2./sig1.^2);
    
    if doPlot == 1
        bar(x, y);
        plot(x, est, 'g');
        title('Hist/Fit', 'interpreter', 'none');
        xlabel('signalVariability (line length)');
    end
    
    hold off;

    % find n standard deviations away from the mean
    signalVariabilityThresh = mu1 + (sig1 * signalVariabilityThreshMultiplier);

    % now expand the signal variability signal to the length of the full record
    signalVariability = repelem(signalVariability, epochSize_samplePoints);
    signalVariability = smooth(signalVariability, fs * smoothDuration); % smoothed in a n second window

    potentialSleeps = signalVariability < signalVariabilityThresh;

    % I think it's reasonable to cutout segments that are not at least 30 seconds long in order to match the humans scoring method
    temp = diff(potentialSleeps);
    automatedWakeStarts = find(temp == -1);
    automatedWakeStarts = [1; automatedWakeStarts]; % assume we start out with wake
    for jj = 1:length(automatedWakeStarts)
        temp2 = find(temp(automatedWakeStarts(jj):end) == 1);
        if ~isempty(temp2)
            automatedWakeEnds(jj) = automatedWakeStarts(jj) + temp2(1);
        else
            automatedWakeEnds(jj) = length(temp);
        end
    end
    automatedWakeDurations = automatedWakeEnds' - automatedWakeStarts;

    % drop wake durations less than wakeDuration cutoff
    temp = automatedWakeDurations > fs * wakeDurationsCutoff;
    automatedWakeStarts = automatedWakeStarts(temp);
    automatedWakeEnds = automatedWakeEnds(temp);
    automatedWakeDurations = automatedWakeDurations(temp);
    
    % maybe here drop the last n seconds from each sleep section since these seem to be normal events? 
    if removeFromSleepRecord > 0
        automatedWakeEnds = automatedWakeEnds - (removeFromSleepRecord * fs);
        automatedWakeDurations = automatedWakeEnds' - automatedWakeStarts;
    end
    
    if exist('humanSleepScore','var')
        
        humanIdealInd = 1:length(filteredPlethSignal);
        humanSleepSearchIndex = [];
        for i = 1:length(humanSleepScore.SleepStartDP)
          %  tempRange = humanSleepScore.SleepStartDP(i) * 24 :humanSleepScore.SleepEndDP(i) * 24;
            tempRange = humanSleepScore.SleepStartDP(i) * 25 :humanSleepScore.SleepEndDP(i) * 25; % ### JO MODIFIED
            humanSleepSearchIndex = [humanSleepSearchIndex, tempRange]; % seems like the DPs are off by 24 hours?
        end
        humanWakeIndicator = ismember(humanIdealInd, humanSleepSearchIndex);
        humanWakeStarts = find(diff(humanWakeIndicator) == -1); 
        humanWakeEnds = find(diff(humanWakeIndicator) == 1);
        humanWakeStarts = [1, humanWakeStarts]; % make sure that we start out with wake.
        humanWakeEnds = [humanWakeEnds, length(filteredPlethSignal)]; % last wake period ends with the record
        humanWakeDurations = humanWakeEnds - humanWakeStarts; 
    end
    
    % now calculate a continous iei signal that is the same length as the whole signal, well need this for comparisons later
    temp = output.starts;
    temp = [ 1, temp];
    temp2 = output.iei;
    temp2 = [temp2, temp2(end)];
    clear ieiContinuous
    ieiContinuous = zeros(length(filteredPlethSignal),1);
    for jj = 1:length(temp)-1
        if jj == 1
            ieiContinuous(temp(1):temp(2)-1) = output.iei(1);
        else
            ieiContinuous(temp(jj):temp(jj+1)-1) = temp2(jj);
        end
    end

    % now take the inverse of the iei signal and then smooth it at the same scale as the signalVariability
    ieiContinuous = smooth(ieiContinuous.^(-1), fs * smoothDuration);

    % now find the range of 'normal' ieiContinuous
    temp = ieiContinuous(ieiContinuous < prctile(ieiContinuous, 98));
    hfit = histfit(temp, 100, 'kernel');
    xlabel('Durations (s)');
    ylabel('Counts');
    y = hfit(1).YData;
    x = hfit(1).XData;
    close gcf
    guess = [1.5, 0.5, 7e5];
    [guess, ~] = fminsearch( 'fit_gauss', guess, options, x, y, 0);
    hold on;
    [mu1, sig1, amp1] = deal(  guess(1), guess(2), guess(3));
    est = amp1.*exp(-(x-mu1).^2./sig1.^2);
    if doPlot == 1
        bar(x, y);
        plot(x, est, 'g');
        title('Hist/Fit', 'interpreter', 'none');
        xlabel('runningIei inverse');
    end
    hold off;

    % find n standard deviations away from the mean
    ieiContinuousThresh = mu1 + (sig1 * nStdsFromIIEContinuous);
    ieiContinuous = ieiContinuous > ieiContinuousThresh;
    
    % now export a bunch of the objects
    output.signalVariability = signalVariability;
    output.automatedWakeStarts = automatedWakeStarts;
    output.automatedWakeEnds = automatedWakeEnds;
    output.automatedWakeDurations = automatedWakeDurations;
    output.automatedTotalHoursSleeping = ((length( filteredPlethSignal) - sum(output.automatedWakeDurations)) / fs) / 3600; % totalHours
    if exist('humanSleepScore','var')
        output.humanWakeStarts = humanWakeStarts;
        output.humanWakeEnds = humanWakeEnds;
        output.humanWakeDurations = humanWakeDurations;
        output.humanTotalHoursSleeping = ((length( filteredPlethSignal) - sum(output.humanWakeDurations)) / fs) / 3600; % totalHours
    end
    
    output.ieiContinuous = ieiContinuous;
    
    % ----- % NOW IDENTIFY APNEAS % ----- %
    
    temp = output.iei;
    temp = temp(temp < prctile(temp, 99));
    hfit = histfit(temp, 100, 'kernel');
    xlabel('Durations (s)');
    ylabel('Counts');
    y = hfit(1).YData;
    x = hfit(1).XData;
    close gcf

    % find peaks within .5 and .95 seconds as the potential average breathrate.
    [pks, locs] = findpeaks(y);
    index = x(locs) > breathRateSecsLowEnd & x(locs) < breathRateSecsHighEnd;
    if sum(index) > 1
        [~, idx] = max(pks(index));
        index = find(index);
        index = index(idx);
    else
        index = find(index);
    end
    output.averageBreathDuration = x(locs(index));

    % now set a bunch of the variables
    output.apneaThreshold = output.averageBreathDuration * apneaThresholdMultiplier;
    output.theseAreMissedBreaths = output.iei > output.apneaThreshold;
    
    % need to exclude things that occur during 'wake' periods. 
     if exist('humanSleepScore', 'Var')
        fullWakeList = zeros(1, sum(output.humanWakeDurations));
        for j = 1:length(output.humanWakeStarts)
            indexStart = sum(output.humanWakeDurations(1:j-1)) + 1;
            indexEnd = indexStart + output.humanWakeDurations(j);
            fullWakeList(:, indexStart:indexEnd) = output.humanWakeStarts(j):output.humanWakeStarts(j)+output.humanWakeDurations(j);
        end
        humanWakeIndicator = ismember(output.starts, fullWakeList);
    else
        fullWakeList = zeros(1, sum(output.automatedWakeDurations));
        for j = 1:length(output.automatedWakeStarts)
            indexStart = sum(output.automatedWakeDurations(1:j-1)) + 1;
            indexEnd = indexStart + output.automatedWakeDurations(j);
            fullWakeList(:, indexStart:indexEnd) = output.automatedWakeStarts(j):output.automatedWakeStarts(j)+output.automatedWakeDurations(j);
        end
        automatedWakeIndicator = ismember(output.starts, fullWakeList);

    end
    
    if exist('humanSleepScore', 'Var')
        output.theseAreMissedBreaths = output.theseAreMissedBreaths & ~humanWakeIndicator(1:end-1);
        output.theseAreNormalBreaths = ~output.theseAreMissedBreaths & ~humanWakeIndicator(1:end-1);
    else
        output.theseAreMissedBreaths = output.theseAreMissedBreaths & ~automatedWakeIndicator(1:end-1);
        output.theseAreNormalBreaths = ~output.theseAreMissedBreaths & ~automatedWakeIndicator(1:end-1);
    end
    
    output.apneaDurations = output.iei(output.theseAreMissedBreaths); % these apnea duraions are not right when I plot them for several of the events.. I'm not sure why this is yet.
    output.apneaIndex = find(output.theseAreMissedBreaths);
    output.howManyApneas = sum(output.theseAreMissedBreaths);
    output.postSighPlusDurationCrit = output.averageBreathDuration * postSighPlusDurationMultiplier * fs;
    output.apneaStarts = output.peaks(output.apneaIndex); % this was output.starts but changed it to peaks because the starts are not the start of the apnea
   
    % ----- identify sighs ----- %
    
    % and which breaths are sighs?
    output.sighInd = output.amplitudes > output.sighsThreshold & output.tidalVolume > output.sighTidalVolumeThresh;
    output.sighStarts = output.peaks(output.sighInd); % was output.starts but that put the cirle at the start of the breath instead the of at the peak. 
    output.sighAmplitudes = output.amplitudes(output.sighInd);
    
    %{
    for i = 1:length(output.sighStarts)
        startLooking = output.sighStarts(i);
        endLooking = startLooking + floor((output.averageBreathDuration * fs));
        signalMins(i) = min(filteredPlethSignal(startLooking:endLooking));  % this isn't done correctly and needs to be adjusted -- perhaps calc the dist between the peak and the min? The prominence... It's only a problem in records where there are false sighs detected..
    end
    
    hfit = histfit(signalMins, 100, 'kernel');
    y = hfit(1).YData;
    x = hfit(1).XData;
    guess = [-2, -1, 1400];
    options = optimset('MaxFunEvals', 1000);
    [guess, ~] = fminsearch( 'fit_gauss', guess, options, x, y, 0);
    hold on;
    [mu1, sig1, amp1 ] = deal(  guess(1), guess(2), guess(3));
    output.sighMinThreshold = mu1 - abs(sig1 * sighMinMultiplier)
    
    % now reset these things
    output.sighInd = output.amplitudes > output.sighsThreshold;
    temp = find(output.sighInd);
    output.sighInd = temp(signalMins < output.sighMinThreshold);
    
    output.sighStarts = output.peaks(output.sighInd); % was output.starts but that put the cirle at the start of the breath instead the of at the peak. 
    output.sighAmplitudes = output.amplitudes(output.sighInd);
    
    %}
    
    % ----- set apnea types ----- %
    
    % set the apnea Types
    for i = 1:output.howManyApneas
        thisApneaStart = output.apneaStarts(i);
        distFromSighs = thisApneaStart - output.sighStarts;
        distFromSighs = distFromSighs(distFromSighs >= 0);
        distFromSighs = min(distFromSighs);
        
        % is there a sigh within 1 breath of the start or is the start sigh? The post-sigh
        if distFromSighs == 0
            output.typeOfApnea(i) = 2;        
        elseif distFromSighs <= output.apneaThreshold * fs / sighArtifactDivisionFactor
            output.apneaStarts(i) = thisApneaStart - distFromSighs;
            output.apneaDurations(i) = output.apneaDurations(i) + (distFromSighs / fs);
            output.apneaIndex(i) = output.apneaIndex(i) - 1;
            output.typeOfApnea(i) = 2;        
        % is there a sigh within the postSighPlusDuration Crit? if so then post sigh plus    
        elseif distFromSighs < output.postSighPlusDurationCrit
            output.typeOfApnea(i) = 3;
            
        % otherwise the envent is a spontaneous apnea    
        else
            
            output.typeOfApnea(i) = 1;
        end
    end
    
    output.nSpontaneousApneas = sum(output.typeOfApnea == 1);
    output.nPostSighApneas = sum(output.typeOfApnea == 2);
    output.nPostSighPlus = sum(output.typeOfApnea == 3);
    
    output.durationsSpontaneousApneas = output.apneaDurations(output.typeOfApnea == 1);
    output.durationsPostSighApneas = output.apneaDurations(output.typeOfApnea == 2);
    output.durationsPostSighPlus = output.apneaDurations(output.typeOfApnea == 3);
    
    output.startsSpontaneousApneas = output.apneaStarts(output.typeOfApnea == 1);
    output.startsPostSighApneas = output.apneaStarts(output.typeOfApnea == 2);
    output.startsPostSighPlus = output.apneaStarts(output.typeOfApnea == 3);
    
    output.spontaneousApneaIndex = output.apneaIndex(output.typeOfApnea == 1);
    output.postSighApneaIndex = output.apneaIndex(output.typeOfApnea == 2);
    output.postSighPlusApneaIndex = output.apneaIndex(output.typeOfApnea == 3);
  
    % ----- % CALCULATE HYPOPNEAS % ----- %
    
    
    output.potentialHypopneas = output.tidalVolume <= output.meanTidalVolume * hypopneaThresh;
    if exist('humanSleepScore', 'Var')
        output.potentialHypopneas = output.potentialHypopneas & ~humanWakeIndicator;
    else
        output.potentialHypopneas = output.potentialHypopneas & ~automatedWakeIndicator;
    end
    output.nHypopneas = sum(output.potentialHypopneas);
    
    
    % ----- % create files to be exported to an xlsx file % ----- % xxx
    
    %output.structsForSpreadsheetExport.automatedSleepRecord;
    %output.structsForSpreadsheetExport.allBreathsSummary;
    %output.structsForSpreadsheetExport.apneaSummary;
    %output.structsForSpreadsheetExport.hypopneaSummary;
    
    
    % close all plots
    close all