function output = detectBreathsApneasAndSleepFromPleth(filteredPlethSignal, fs)

    doPlot = 0; % set to 1 if you want to see the final versions of the plotting fits... need to work on this xxx

    % establish the time signal
    totalSeconds = length( filteredPlethSignal) /  fs;
    totalMinutes =  totalSeconds / 60;

    highThreshMultiplier = 0.40;
    lowThreshMultiplier = 0.10;
    hypopneaThresh = 0.6;
    normalBreath = 0.65;
    apneaThresholdMultiplier = 2; % default multiplier which determins which breath gaps should be classified as apneas.

    % sleepScoring adjustable variables
    wakeDurationsCutoff = 60; % works well at 30
    nStdsFromIIEContinuous = 3;
    smoothDuration = 20; % works well at 30, go forwards and backwards for this smoothing
  
    % create the first and second derivative signals
    output.f1 = gradient(filteredPlethSignal);
    
    
    % ----- % THIS IS ALL ABOUT BREATH DETECTION % ----- %
    
    % set defaults for highThreshList and lowThreshList and bufferList -- these are the three tunable parameters in this method
    std_filteredSignal = std(filteredPlethSignal); % we could tweak this value to ensure that its a stable measure regardless of the file type.. for example a median or mode value might be more consistent than std in records with lots of noise.
    highBreathThresh = std_filteredSignal * highThreshMultiplier; 
    lowBreathThresh = -std_filteredSignal * lowThreshMultiplier;

    [output.starts, output.ends, output.ideal] = twoThreshPeakDetect(filteredPlethSignal, highBreathThresh, lowBreathThresh);
    output.ideal(output.ideal > 0) = 1;

    % glue together events that are super close. This is technically a tunable parameter
    MPD = floor(fs / (120 / 60) / 15); % value based on the expected heart rate of 120 bpm, and then a tenth of that
    for i = 1:length(output.starts) - 1
        if output.starts(i + 1) - output.ends(i) < MPD
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
        breathCutoff = 200;
        %[value, index] = min(filteredPlethSignal(starts(i) - breathCutoff:starts(i))); %

        % find the zero crossings using the first derivative
        temp = fliplr(output.f1(output.starts(i) - breathCutoff:output.starts(i)));
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

        temp = output.f1(output.ends(i): starts2(i + 1));
        % find the zero crossings using the first derivative
        index = zci(temp);
        if isempty(index)
            index = length(temp);
        end

        % then map that index back to the signal.
        ends2(i) = output.ends(i) + index(1);  

    end

    % make a new idea signal based on the new start and end points
    clear ideal2
    ideal2 = zeros(1, length(output.ideal));

    % find peaks within each breath and amplitudes of these peaks -- this is using the filtered signal instead of the original signal but it's just for plotting purposes
    clear amplitudes
    clear peaks
    for i = 1:length(starts2)
        [pks, locs] = findpeaks(filteredPlethSignal(starts2(i):ends2(i)));
        [value, index] = max(pks);
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

    % fit a distribution to the histogram of event durations, find the peak
    % around where a normal breath rythm usually occurs
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
    hfit = histfit(output.amplitudes(keepInd), 200, 'kernel');
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
    amplitudesLow = mu1 - (sig1 * 3);

    keepInd = output.amplitudes > amplitudesLow;

    amplitude_mu = mu1;
    amplitude_sig = sig1;

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
    output.starts = output.starts(keepInd);
    output.ends = output.ends(keepInd);
    output.peaks = output.peaks(keepInd);
    output.iei = diff(output.peaks) / fs;

    for i = 1:length(output.starts)
        durations2(i) =  output.ends(i) - output.starts(i);
    end
    output.durations = durations2 /fs;
    output.BPM = length(output.starts) / totalMinutes;


    % ----- % CALCULATE TIDAL VOLUME OF BREATHS % ----- %
    
    % now calculate tidal volume
    clear tidalVolume mistakes
    for i = 1:length(output.starts)
        xv = filteredPlethSignal(output.starts(i):output.ends(i)); % signal line, top of figure
        if length(xv) > 1
            vq = interp1([output.starts(i), output.ends(i)],[filteredPlethSignal(output.starts(i)), filteredPlethSignal(output.ends(i))],output.starts(i):output.ends(i)); % interpolates the bottom line from 

            %tidalVolume(i) = polyarea(xv,vq); % this function does not work if there are line crossings..

            % this works but probably needs to be broken down into section where there are line crossing to get a more exact value (using the subtrction part.. If you just subtract the vq part then signals that have agregious line crossings are calculated v poorly.
            output.tidalVolume(i) = trapz(xv + abs(min(xv))) - trapz(vq + abs(min(xv)));              

            % count the number of line crossings for each plot such that we can optimize the correct detection positions
            output.mistakes(i) = length(find((xv-vq) == 0)) - 2;
        else
            output.tidalVolume(i) = 0;
            output.mistakes(i) = 99;
        end

    end

    % now figure out the average tidal volume of the average breath
    amplitudeInd = output.amplitudes > amplitude_mu - amplitude_sig & output.amplitudes < amplitude_mu + amplitude_sig;
    ieiInd = output.iei > iei_mu - iei_sig & output.iei < iei_mu + iei_sig;
    ieiInd = [ieiInd, 0];

    hfit = histfit(output.tidalVolume(amplitudeInd & ieiInd), 100, 'kernel');
    y = hfit(1).YData;
    x = hfit(1).XData; 
    close gcf

    output.meanTidalVolume = mean(output.tidalVolume(amplitudeInd & ieiInd));

    % set some constant variables
    nSecs = 4;
    signalVariabilityThreshMultiplier = 4;
        
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
    
    % ----- % THIS IS WHERE SLEEP DETECTION HAPPENS % ----- %
    
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
    signalVariability = smooth(signalVariability, fs * smoothDuration); % smoothed in a 30 second window
    potentialSleeps = signalVariability < signalVariabilityThresh;

    % I think it's reasonable to cutout segments that are not at least 30 seconds long in order to match the humans scoring method
    temp = diff(potentialSleeps);
    %sleepStarts = find(temp == 1);
    wakeStarts = find(temp == -1);
    wakeStarts = [1; wakeStarts]; % assume we start out with wake
    for jj = 1:length(wakeStarts)
        temp2 = find(temp(wakeStarts(jj):end) == 1);
        if ~isempty(temp2)
            wakeEnds(jj) = wakeStarts(jj) + temp2(1);
        else
            wakeEnds(jj) = length(temp);
        end
    end
    wakeDurations = wakeEnds' - wakeStarts;

    % drop wake durations less than 30 seconds
    temp = wakeDurations > fs * wakeDurationsCutoff;
    wakeStarts = wakeStarts(temp);
    wakeEnds = wakeEnds(temp);
    wakeDurations = wakeDurations(temp);

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
    output.wakeStarts = wakeStarts;
    output.wakeEnds = wakeEnds;
    output.wakeDurations = wakeDurations;
    output.totalHoursSleeping = ((length( filteredPlethSignal) - sum(output.wakeDurations)) / fs) / 3600; % totalHours
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
    index = x(locs) > .50 & x(locs) < .95;
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
    wakeIndicator = zeros(length(output.starts), 1);
    fullWakeList = zeros(1, sum(output.wakeDurations));
    for j = 1:length(output.wakeStarts)
        indexStart = sum(output.wakeDurations(1:j-1)) + 1;
        indexEnd = indexStart + output.wakeDurations(j);
        fullWakeList(:, indexStart:indexEnd) = output.wakeStarts(j):output.wakeStarts(j)+output.wakeDurations(j);
    end
   
    for j = 1:length(wakeIndicator)
        timeInQuestion = output.starts(j);
        if sum(timeInQuestion == fullWakeList)
            wakeIndicator(j) = 1;
        end
    end
    output.theseAreMissedBreaths = output.theseAreMissedBreaths & ~wakeIndicator(1:end-1)';
    
    output.apneaDurations = output.iei(output.theseAreMissedBreaths);
    output.apneaIndex = find(output.theseAreMissedBreaths);
    output.howManyApneas = sum(output.theseAreMissedBreaths);

    % now cluster the apnea related breaths to figure out which ones are spontaneous
    clear sighs notSighs

    % remove any really high amplitudues prior to clustering because they throw off the clustering
    temp = output.amplitudes(output.theseAreMissedBreaths)';
    temptemp = temp < prctile(temp, 99); % 
    clusterInd = kmeans(temp(temptemp), 2);
    counter = 1;
    for j = 1:size(temptemp, 1)
        if temptemp(j) == 1
            newClusterInd(j) = clusterInd(counter);
            counter = counter + 1;
        end
    end
    clusterInd = newClusterInd;
    clear newClusterInd temptemp temp

    meanA = mean(output.amplitudes(output.apneaIndex(clusterInd == 1)));
    meanB = mean(output.amplitudes(output.apneaIndex(clusterInd == 2)));

    if meanA > meanB
        sighs = 1;
        notSighs = 2;
    else
        notSighs = 1;
        sighs = 2;
    end

    notSighsInd = clusterInd == notSighs;
    sighsInd = clusterInd == sighs;
    
    output.postSighPlusDurationCrit = output.apneaThreshold * 5 * fs; % 10 normal breath lengths;
    output.apneaStarts = output.starts(output.apneaIndex);

    %now add a third type of category for post sigh plus.
    temp = find(notSighsInd);
    for j = 1:sum(notSighsInd)
        timeInQuestion = output.apneaStarts(temp(j));
        temptemp = timeInQuestion - output.apneaStarts(find(sighsInd));
        converttoPSP(j) = sum(temptemp <  output.postSighPlusDurationCrit & temptemp > 0);
    end    
    
    % now save everything to the output
    output.typeOfApnea = zeros(length(clusterInd),1);
    output.typeOfApnea(notSighsInd) = 1; % spontaneous
    output.typeOfApnea(sighsInd) = 2; % post sigh
    output.typeOfApnea(temp(find(converttoPSP))) = 3; % postSighPlus
    
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

    % close all plots
    close all