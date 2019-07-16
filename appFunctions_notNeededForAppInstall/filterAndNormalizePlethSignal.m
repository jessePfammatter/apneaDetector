function filteredSignal = filterAndNormalizePlethSignal(singleChannelPlethData, fs)
% FILTERANDNORMALIZEPLETHSIGNAL does just what it says and is to be used 
% with the apneaDetector app.
%
% JP 2019

    filteredSignal = highPassChebyshev1Filt_apnea(singleChannelPlethData, fs);
    filteredSignal = fliplr(highPassChebyshev1Filt_apnea(fliplr(filteredSignal), fs)); % make the filter zero phase shift by doing it backwards.

    % now smooth the data
    filteredSignal = smoothdata(filteredSignal, 'movmean', 40);

    % normalize the signal so that they are they same relative size between different recordings.
    temp = mean(filteredSignal);
    temp1 = std(filteredSignal, 1);
    filteredSignal = (filteredSignal - temp) ./ temp1;

end
