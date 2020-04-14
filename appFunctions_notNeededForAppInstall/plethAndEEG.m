% investigate pleth + EEG files

plethAndEEGnamefile
epochDuration = 4;

for i = 1:size(animal, 2)

    filespec = animal(i).EEGfilespec;

    [header] = edfread(filespec);
    fs = header.frequency(1);

    pleth_chan = find(strcmp(header.label, animal(i).plethchan));
    [~, animal(i).pleth] = edfread(filespec, 'targetSignals', pleth_chan);
    EEG_chan = find(strcmp(header.label, animal(i).EEGchan));
    [~, animal(i).EEG] = edfread(filespec, 'targetSignals', EEG_chan);
    EMG_chan = find(strcmp(header.label, animal(i).EMGchan));
    [~, animal(i).EMG] = edfread(filespec, 'targetSignals', EMG_chan);

    % import human sleep scoring from animal(i).EEG record
    [animal(i).EPOCH, STARTTIME, ENDTIME, animal(i).SCORE, SCORE1] = importSERENIA_jp(animal(i).humanEEGScore);

    % convert the sleep scoring to remove REM
    animal(i).SCORE(animal(i).SCORE == 3) = 2;

    % import human sleep scoring from animal(i).pleth record
    animal(i).humanPlethSleepScore = importfile_humanSleepScores(animal(i).humanPlethSleepScore);
    animal(i).humanIdealInd = 1:length(animal(i).pleth);
    humanSleepPlethSearchIndex = [];
    for j = 1:length(animal(i).humanPlethSleepScore.SleepStartDP)
        tempRange = animal(i).humanPlethSleepScore.SleepStartDP(j) * 25 :animal(i).humanPlethSleepScore.SleepEndDP(j) * 25;
        humanSleepPlethSearchIndex = [humanSleepPlethSearchIndex, tempRange];
    end
    animal(i).humanWakeIndicator = ismember(animal(i).humanIdealInd, humanSleepPlethSearchIndex);
    animal(i).humanWakeStarts = find(diff(animal(i).humanWakeIndicator) == -1); 
    animal(i).humanWakeEnds = find(diff(animal(i).humanWakeIndicator) == 1);
    animal(i).humanWakeStarts = [1, animal(i).humanWakeStarts]; % make sure that we start out with wake.
    animal(i).humanWakeEnds = [animal(i).humanWakeEnds, length(animal(i).pleth)]; % last wake period ends with the record
    animal(i).humanWakeDurations = animal(i).humanWakeEnds - animal(i).humanWakeStarts; 

    % now make an ideal signal for the human animal(i).pleth sleep scoring         
    animal(i).humanPlethSleepIdeal =  ones(size(animal(i).SCORE, 1), 1) * 2;
    for j = 1:length(animal(i).humanWakeStarts)
        animal(i).humanPlethSleepIdeal(ceil(animal(i).humanWakeStarts(j)/(fs*epochDuration)):ceil(animal(i).humanWakeEnds(j)/(fs*epochDuration))) = 1;
    end

    % detect apneas and sleep
    counter = 1;
    wakeDurationsCutoff = [5, 10, 15];
    smoothDuration = [5, 10, 15];
    signalVariabilityThreshMultiplier = [1.5, 2, 2.5, 3];
    nSecs = [5, 10, 15];

    for wdc = 1:length(wakeDurationsCutoff)
        for sm = 1:length(smoothDuration)
            for svtm = 1:length(signalVariabilityThreshMultiplier)
                for nS = 1:length(nSecs)

                    tunableParameters.wakeDurationsCutoff = wakeDurationsCutoff(wdc);
                    tunableParameters.smoothDuration = smoothDuration(sm);
                    tunableParameters.signalVariabilityThreshMultiplier = signalVariabilityThreshMultiplier(svtm);
                    tunableParameters.nSecs = nSecs(nS);
                    temptemp = detectBreathsApneasAndSleepFromPleth(animal(i).pleth, fs, tunableParameters);
                    if temptemp.howManyApneas > 0 % this is here in case there are no apneas found..
                        animal(i).output(counter)  = temptemp;
                        
                        % make an ideal sleep record fromt the automated sleep scroting from animal(i).pleth file
                        tempPlethSignal(counter).plethAutomatedSleepIdeal = ones(length(animal(i).EPOCH), 1) * 2;
                        for j = 1:length(animal(i).output(counter).automatedWakeStarts)
                            tempRange = ceil(animal(i).output(counter).automatedWakeStarts(j) / fs / epochDuration): floor(animal(i).output(counter).automatedWakeEnds(j) / fs / epochDuration);
                            tempPlethSignal(counter).plethAutomatedSleepIdeal(tempRange) = 1;
                        end

                        confusionMatrix_EEGtoAUTO = confusionmat(tempPlethSignal(counter).plethAutomatedSleepIdeal(animal(i).SCORE ~= 0), animal(i).SCORE(animal(i).SCORE ~= 0));
                        confusionMatrix_EEGtoHP = confusionmat(animal(i).humanPlethSleepIdeal(animal(i).SCORE ~= 0), animal(i).SCORE(animal(i).SCORE ~= 0));
                        confusionMatrix_HPtoAUTO = confusionmat(tempPlethSignal(counter).plethAutomatedSleepIdeal(animal(i).SCORE ~= 0), animal(i).humanPlethSleepIdeal(animal(i).SCORE ~= 0));


                        % use these if you want to set wake/wake as a true positive
                        animal(i).tp_sleep_EEGtoAUTO(counter) = confusionMatrix_EEGtoAUTO(1);
                        animal(i).fp_sleep_EEGtoAUTO(counter) = confusionMatrix_EEGtoAUTO(2);
                        animal(i).fn_sleep_EEGtoAUTO(counter) = confusionMatrix_EEGtoAUTO(3);
                        animal(i).tn_sleep_EEGtoAUTO(counter) = confusionMatrix_EEGtoAUTO(4);

                        % use these if you want to set sleep/sleep as the true positive
                        animal(i).tp_wake_EEGtoAUTO(counter) = confusionMatrix_EEGtoAUTO(4);
                        animal(i).fp_wake_EEGtoAUTO(counter) = confusionMatrix_EEGtoAUTO(3);
                        animal(i).fn_wake_EEGtoAUTO(counter) = confusionMatrix_EEGtoAUTO(2);
                        animal(i).tn_wake_EEGtoAUTO(counter) = confusionMatrix_EEGtoAUTO(1);

                        animal(i).accuracy_sleep_EEGtoAUTO(counter) = (animal(i).tp_sleep_EEGtoAUTO(counter) + animal(i).tn_sleep_EEGtoAUTO(counter)) ./ (animal(i).tp_sleep_EEGtoAUTO(counter) + animal(i).tn_sleep_EEGtoAUTO(counter) + animal(i).fp_sleep_EEGtoAUTO(counter) + animal(i).fn_sleep_EEGtoAUTO(counter))
                        animal(i).specificity_sleep_EEGtoAUTO(counter) = animal(i).tn_sleep_EEGtoAUTO(counter) ./ (animal(i).tn_sleep_EEGtoAUTO(counter) + animal(i).fp_sleep_EEGtoAUTO(counter)) % also the FPR
                        animal(i).sensitivity_sleep_EEGtoAUTO(counter) = animal(i).tp_sleep_EEGtoAUTO(counter) ./ (animal(i).tp_sleep_EEGtoAUTO(counter) + animal(i).fn_sleep_EEGtoAUTO(counter)) % also the TRP, recall
                        animal(i).ppv_sleep_EEGtoAUTO(counter) = animal(i).tp_sleep_EEGtoAUTO(counter) ./ (animal(i).tp_sleep_EEGtoAUTO(counter) + animal(i).fp_sleep_EEGtoAUTO(counter)) % also precision
                        animal(i).f1_sleep_EEGtoAUTO(counter) = 2 .* ((animal(i).ppv_sleep_EEGtoAUTO(counter) .* animal(i).sensitivity_sleep_EEGtoAUTO(counter)) ./ (animal(i).ppv_sleep_EEGtoAUTO(counter) + animal(i).sensitivity_sleep_EEGtoAUTO(counter)))

                        animal(i).accuracy_wake_EEGtoAUTO(counter) = (animal(i).tp_wake_EEGtoAUTO(counter) + animal(i).tn_wake_EEGtoAUTO(counter)) ./ (animal(i).tp_wake_EEGtoAUTO(counter) + animal(i).tn_wake_EEGtoAUTO(counter) + animal(i).fp_wake_EEGtoAUTO(counter) + animal(i).fn_wake_EEGtoAUTO(counter))
                        animal(i).specificity_wake_EEGtoAUTO(counter) = animal(i).tn_wake_EEGtoAUTO(counter) ./ (animal(i).tn_wake_EEGtoAUTO(counter) + animal(i).fp_wake_EEGtoAUTO(counter)) % also the FPR
                        animal(i).sensitivity_wake_EEGtoAUTO(counter) = animal(i).tp_wake_EEGtoAUTO(counter) ./ (animal(i).tp_wake_EEGtoAUTO(counter) + animal(i).fn_wake_EEGtoAUTO(counter)) % also the TRP, recall
                        animal(i).ppv_wake_EEGtoAUTO(counter) = animal(i).tp_wake_EEGtoAUTO(counter) ./ (animal(i).tp_wake_EEGtoAUTO(counter) + animal(i).fp_wake_EEGtoAUTO(counter)) % also precision
                        animal(i).f1_wake_EEGtoAUTO(counter) = 2 .* ((animal(i).ppv_wake_EEGtoAUTO(counter) .* animal(i).sensitivity_wake_EEGtoAUTO(counter)) ./ (animal(i).ppv_wake_EEGtoAUTO(counter) + animal(i).sensitivity_wake_EEGtoAUTO(counter)))

                                            % use these if you want to set wake/wake as a true positive
                        animal(i).tp_sleep_EEGtoHP(counter) = confusionMatrix_EEGtoHP(1);
                        animal(i).fp_sleep_EEGtoHP(counter) = confusionMatrix_EEGtoHP(2);
                        animal(i).fn_sleep_EEGtoHP(counter) = confusionMatrix_EEGtoHP(3);
                        animal(i).tn_sleep_EEGtoHP(counter) = confusionMatrix_EEGtoHP(4);

                        % use these if you want to set sleep/sleep as the true positive
                        animal(i).tp_wake_EEGtoHP(counter) = confusionMatrix_EEGtoHP(4);
                        animal(i).fp_wake_EEGtoHP(counter) = confusionMatrix_EEGtoHP(3);
                        animal(i).fn_wake_EEGtoHP(counter) = confusionMatrix_EEGtoHP(2);
                        animal(i).tn_wake_EEGtoHP(counter) = confusionMatrix_EEGtoHP(1);

                        animal(i).accuracy_sleep_EEGtoHP(counter) = (animal(i).tp_sleep_EEGtoHP(counter) + animal(i).tn_sleep_EEGtoHP(counter)) ./ (animal(i).tp_sleep_EEGtoHP(counter) + animal(i).tn_sleep_EEGtoHP(counter) + animal(i).fp_sleep_EEGtoHP(counter) + animal(i).fn_sleep_EEGtoHP(counter))
                        animal(i).specificity_sleep_EEGtoHP(counter) = animal(i).tn_sleep_EEGtoHP(counter) ./ (animal(i).tn_sleep_EEGtoHP(counter) + animal(i).fp_sleep_EEGtoHP(counter)) % also the FPR
                        animal(i).sensitivity_sleep_EEGtoHP(counter) = animal(i).tp_sleep_EEGtoHP(counter) ./ (animal(i).tp_sleep_EEGtoHP(counter) + animal(i).fn_sleep_EEGtoHP(counter)) % also the TRP, recall
                        animal(i).ppv_sleep_EEGtoHP(counter) = animal(i).tp_sleep_EEGtoHP(counter) ./ (animal(i).tp_sleep_EEGtoHP(counter) + animal(i).fp_sleep_EEGtoHP(counter)) % also precision
                        animal(i).f1_sleep_EEGtoHP(counter) = 2 .* ((animal(i).ppv_sleep_EEGtoHP(counter) .* animal(i).sensitivity_sleep_EEGtoHP(counter)) ./ (animal(i).ppv_sleep_EEGtoHP(counter) + animal(i).sensitivity_sleep_EEGtoHP(counter)))

                        animal(i).accuracy_wake_EEGtoHP(counter) = (animal(i).tp_wake_EEGtoHP(counter) + animal(i).tn_wake_EEGtoHP(counter)) ./ (animal(i).tp_wake_EEGtoHP(counter) + animal(i).tn_wake_EEGtoHP(counter) + animal(i).fp_wake_EEGtoHP(counter) + animal(i).fn_wake_EEGtoHP(counter))
                        animal(i).specificity_wake_EEGtoHP(counter) = animal(i).tn_wake_EEGtoHP(counter) ./ (animal(i).tn_wake_EEGtoHP(counter) + animal(i).fp_wake_EEGtoHP(counter)) % also the FPR
                        animal(i).sensitivity_wake_EEGtoHP(counter) = animal(i).tp_wake_EEGtoHP(counter) ./ (animal(i).tp_wake_EEGtoHP(counter) + animal(i).fn_wake_EEGtoHP(counter)) % also the TRP, recall
                        animal(i).ppv_wake_EEGtoHP(counter) = animal(i).tp_wake_EEGtoHP(counter) ./ (animal(i).tp_wake_EEGtoHP(counter) + animal(i).fp_wake_EEGtoHP(counter)) % also precision
                        animal(i).f1_wake_EEGtoHP(counter) = 2 .* ((animal(i).ppv_wake_EEGtoHP(counter) .* animal(i).sensitivity_wake_EEGtoHP(counter)) ./ (animal(i).ppv_wake_EEGtoHP(counter) + animal(i).sensitivity_wake_EEGtoHP(counter)))

                                            % use these if you want to set wake/wake as a true positive
                        animal(i).tp_sleep_HPtoAUTO(counter) = confusionMatrix_HPtoAUTO(1);
                        animal(i).fp_sleep_HPtoAUTO(counter) = confusionMatrix_HPtoAUTO(2);
                        animal(i).fn_sleep_HPtoAUTO(counter) = confusionMatrix_HPtoAUTO(3);
                        animal(i).tn_sleep_HPtoAUTO(counter) = confusionMatrix_HPtoAUTO(4);

                        % use these if you want to set sleep/sleep as the true positive
                        animal(i).tp_wake_HPtoAUTO(counter) = confusionMatrix_HPtoAUTO(4);
                        animal(i).fp_wake_HPtoAUTO(counter) = confusionMatrix_HPtoAUTO(3);
                        animal(i).fn_wake_HPtoAUTO(counter) = confusionMatrix_HPtoAUTO(2);
                        animal(i).tn_wake_HPtoAUTO(counter) = confusionMatrix_HPtoAUTO(1);

                        animal(i).accuracy_sleep_HPtoAUTO(counter) = (animal(i).tp_sleep_HPtoAUTO(counter) + animal(i).tn_sleep_HPtoAUTO(counter)) ./ (animal(i).tp_sleep_HPtoAUTO(counter) + animal(i).tn_sleep_HPtoAUTO(counter) + animal(i).fp_sleep_HPtoAUTO(counter) + animal(i).fn_sleep_HPtoAUTO(counter))
                        animal(i).specificity_sleep_HPtoAUTO(counter) = animal(i).tn_sleep_HPtoAUTO(counter) ./ (animal(i).tn_sleep_HPtoAUTO(counter) + animal(i).fp_sleep_HPtoAUTO(counter)) % also the FPR
                        animal(i).sensitivity_sleep_HPtoAUTO(counter) = animal(i).tp_sleep_HPtoAUTO(counter) ./ (animal(i).tp_sleep_HPtoAUTO(counter) + animal(i).fn_sleep_HPtoAUTO(counter)) % also the TRP, recall
                        animal(i).ppv_sleep_HPtoAUTO(counter) = animal(i).tp_sleep_HPtoAUTO(counter) ./ (animal(i).tp_sleep_HPtoAUTO(counter) + animal(i).fp_sleep_HPtoAUTO(counter)) % also precision
                        animal(i).f1_sleep_HPtoAUTO(counter) = 2 .* ((animal(i).ppv_sleep_HPtoAUTO(counter) .* animal(i).sensitivity_sleep_HPtoAUTO(counter)) ./ (animal(i).ppv_sleep_HPtoAUTO(counter) + animal(i).sensitivity_sleep_HPtoAUTO(counter)))

                        animal(i).accuracy_wake_HPtoAUTO(counter) = (animal(i).tp_wake_HPtoAUTO(counter) + animal(i).tn_wake_HPtoAUTO(counter)) ./ (animal(i).tp_wake_HPtoAUTO(counter) + animal(i).tn_wake_HPtoAUTO(counter) + animal(i).fp_wake_HPtoAUTO(counter) + animal(i).fn_wake_HPtoAUTO(counter))
                        animal(i).specificity_wake_HPtoAUTO(counter) = animal(i).tn_wake_HPtoAUTO(counter) ./ (animal(i).tn_wake_HPtoAUTO(counter) + animal(i).fp_wake_HPtoAUTO(counter)) % also the FPR
                        animal(i).sensitivity_wake_HPtoAUTO(counter) = animal(i).tp_wake_HPtoAUTO(counter) ./ (animal(i).tp_wake_HPtoAUTO(counter) + animal(i).fn_wake_HPtoAUTO(counter)) % also the TRP, recall
                        animal(i).ppv_wake_HPtoAUTO(counter) = animal(i).tp_wake_HPtoAUTO(counter) ./ (animal(i).tp_wake_HPtoAUTO(counter) + animal(i).fp_wake_HPtoAUTO(counter)) % also precision
                        animal(i).f1_wake_HPtoAUTO(counter) = 2 .* ((animal(i).ppv_wake_HPtoAUTO(counter) .* animal(i).sensitivity_wake_HPtoAUTO(counter)) ./ (animal(i).ppv_wake_HPtoAUTO(counter) + animal(i).sensitivity_wake_HPtoAUTO(counter)))


                        animal(i).wdcList(counter) = wakeDurationsCutoff(wdc)
                        animal(i).smList(counter) = smoothDuration(sm)
                        animal(i).svtmList(counter) = signalVariabilityThreshMultiplier(svtm)
                        animal(i).nSList(counter) = nSecs(nS)
                        counter = counter + 1;
                    else
                        animal(i).wdcList(counter) = wakeDurationsCutoff(wdc)
                        animal(i).smList(counter) = smoothDuration(sm)
                        animal(i).svtmList(counter) = signalVariabilityThreshMultiplier(svtm)
                        animal(i).nSList(counter) = nSecs(nS)
                        counter = counter + 1;
                    end

                end
            end
        end
    end
end

%% save the workspace for later

save('/Volumes/cookieMonster/mj1lab_mirror/apneaProject/EEG + Pleth/plethAndEEG_optimization.mat', '-v7.3')

%% start here if you already processed the data and are happy with the range of parameters

load('/Volumes/cookieMonster/mj1lab_mirror/apneaProject/EEG + Pleth/plethAndEEG_optimization.mat')


%%

% select the animal you want to inspect
figure('units', 'inch', 'pos', [10 10 20 8])
for i = 2%:size(animal, 2)
    suptitle(strcat("animal ", animal(i).ID))


    subplot(1,3,1)
        hold on
        for counter = 1:length(animal(i).ppv_sleep_EEGtoAUTO)
            plot(normrnd(1:4, .1), [animal(i).ppv_sleep_EEGtoAUTO(counter), animal(i).f1_sleep_EEGtoAUTO(counter), animal(i).ppv_wake_EEGtoAUTO(counter), animal(i).f1_wake_EEGtoAUTO(counter)], '.', 'markerSize', 20)
            xticks(1:4)
            xticklabels({'PPV sleep', 'F1 sleep', 'PPV wake', 'F1 wake'});
            xlim([0.5 4.5])
            ylim([0 1])
            title('Sleep Scoring Comparison - EEG to AUTO ')
            xtickangle(45)
        end
    subplot(1,3,2)
        hold on
        for counter = 1:length(animal(i).ppv_sleep_EEGtoAUTO)
            plot(normrnd(1:4, .1), [animal(i).ppv_sleep_EEGtoHP(counter), animal(i).f1_sleep_EEGtoHP(counter), animal(i).ppv_wake_EEGtoHP(counter), animal(i).f1_wake_EEGtoHP(counter)], '.', 'markerSize', 20)
            xticks(1:4)
            xticklabels({'PPV sleep', 'F1 sleep', 'PPV wake', 'F1 wake'});
            xlim([0.5 4.5])
            ylim([0 1])
            title('Sleep Scoring Comparison - EEG to HP ')
            xtickangle(45)
        end
        
        subplot(1,3,3)
        hold on
        for counter = 1:length(animal(i).ppv_sleep_EEGtoAUTO)
            plot(normrnd(1:4, .1), [animal(i).ppv_sleep_HPtoAUTO(counter), animal(i).f1_sleep_HPtoAUTO(counter), animal(i).ppv_wake_HPtoAUTO(counter), animal(i).f1_wake_HPtoAUTO(counter)], '.', 'markerSize', 20)
            xticks(1:4)
            xticklabels({'PPV sleep', 'F1 sleep', 'PPV wake', 'F1 wake'});
            xlim([0.5 4.5])
            ylim([0 1])
            title('Sleep Scoring Comparison - HP to AUTO')
            xtickangle(45)
        end
end
%%
i = 8
figure('units', 'inch', 'pos', [10 10 20 8])
f1_sleep = animal(i).f1_sleep_HPtoAUTO;
f1_wake = animal(i).f1_wake_HPtoAUTO;
    suptitle(strcat("animal ", animal(i).ID))

ylimset = [0.5 1];

subplot(2,4,1)
    plot(animal(i).wdcList, f1_sleep, '.', 'MarkerSize', 20)
    xlabel('Wake Duration Cuttoffs (s)')
    ylabel('f1 sleep')
    ylim(ylimset)
subplot(2,4,2)
    plot(animal(i).nSList, f1_sleep, '.', 'MarkerSize', 20)
    xlabel('Epoch Duration (s)')
    ylabel('f1 sleep')
    ylim(ylimset)
subplot(2,4,3)
    plot(animal(i).svtmList, f1_sleep, '.', 'MarkerSize', 20)
    xlabel('Signal Variability Thresh Multiplier (stds)')  
    ylabel('f1 sleep')
    ylim(ylimset)
subplot(2,4,4)
    plot(animal(i).smList, f1_sleep, '.', 'MarkerSize', 20)
    xlabel('Smooth Window (s)')  
    ylabel('f1 sleep')
    ylim(ylimset)
subplot(2,4,5)
    plot(animal(i).wdcList, f1_wake, '.', 'MarkerSize', 20)
    xlabel('Wake Duration Cuttoffs (s)')
    ylabel('f1 wake')
    ylim(ylimset)
subplot(2,4,6)
    plot(animal(i).nSList, f1_wake, '.', 'MarkerSize', 20)
    xlabel('Epoch Duration (s)')
    ylabel('f1 wake')
    ylim(ylimset)
subplot(2,4,7)
    plot(animal(i).svtmList, f1_wake, '.', 'MarkerSize', 20)
    xlabel('Signal Variability Thresh Multiplier (stds) wake')  
    ylabel('f1 wake')
    ylim(ylimset)
subplot(2,4,8)
    plot(animal(i).smList, f1_wake, '.', 'MarkerSize', 20)
    xlabel('Smooth Window (s)')  
    ylabel('f1 wake')
    ylim(ylimset)
    
    %%
for i = 1:8
    
        figure('units', 'inch', 'pos', [10 10 20 8])

    f1_sleep = animal(i).f1_sleep_EEGtoAUTO; 
    f1_wake = animal(i).f1_wake_EEGtoAUTO;
    accuracy_sleep = animal(i).accuracy_sleep_EEGtoAUTO;
    suptitle('animal(i).EEG to AUTO')

    subplot(1,2,1)
        hold on
        plot(f1_sleep, f1_wake, '.', 'MarkerSize', 20)
        xlabel('F1 Sleep')
        ylabel('F1 Wake')
   
    subplot(1,2,2)
        hold on
        plot(f1_sleep, accuracy_sleep, '.', 'MarkerSize', 20)
        xlabel('F1 Sleep')
        ylabel('Accuracy Sleep')
      
end

%% find the max value for f1_wake 
for i = 1:8
    quantity = animal(i).f1_wake_HPtoAUTO;
    %quantity = animal(i).accuracy_wake_HPtoAUTO;
    [values(i), maxindex(i)] = max(quantity);
    
    svtmListOpt(i) = animal(i).svtmList(maxindex(i));
    nSListOpt(i) = animal(i).nSList(maxindex(i));
    smListOpt(i) = animal(i).smList(maxindex(i));
    wdcListOpt(i) = animal(i).wdcList(maxindex(i));
end

svtmListOpt
nSListOpt
smListOpt
wdcListOpt
    %%
        
    %%
    
    
    
    figure
    
    f1_sleep = animal(i).f1_sleep_HPtoAUTO;
f1_wake = animal(i).f1_wake_HPtoAUTO;
suptitle('HP to AUTO')

    subplot(1,2,1)
        scatter3(animal(i).smList, animal(i).nSList, animal(i).svtmList, 40, f1_sleep, 'filled')
        xlabel('Smooth Durations (s)')
        ylabel('Epoch Duration (s)')
        zlabel('Signal Variability Thresh Multiplier (stds)')
        colormap('redgreenblue')
        colorbar()
    subplot(1,2,2)
        scatter3(animal(i).wdcList, animal(i).nSList, animal(i).svtmList, 40, f1_wake, 'filled')
        xlabel('Wake Duration Cuttoffs (s)')
        ylabel('Epoch Duration (s)')
        zlabel('Signal Variability Thresh Multiplier (stds)')
        colormap('redgreenblue')
        colorbar()    
        
        
        

                        
%%

% use brush on previous plot to set optimal.

% find(animal(i).f1_sleep_EEGtoAUTO == optimal(1) & animal(i).f1_wake_EEGtoAUTO == optimal(2));



optimal = 1;

%

smList(optimal)
wdcList(optimal)
svtmList(optimal)
nSList(optimal)
      
                % plot sleep from algorithm vs sleep from humans.
                figure
                plot(animal(i).EPOCH, animal(i).SCORE)
                hold on

                ylim([-1 7])
                plot(animal(i).EPOCH, tempPlethSignal(optimal).plethAutomatedSleepIdeal + 2) 
                plot(animal(i).EPOCH, animal(i).humanPlethSleepIdeal + 4) 
                legend({'Human Scoring of animal(i).EEG', 'Automated Scoring from Pleth', 'Human Scoring of Pleth'})

                figure
                plot(animal(i).EPOCH(find(animal(i).SCORE == 2)), animal(i).SCORE(find(animal(i).SCORE == 2)), '.')
                hold on

                ylim([1 7])
                plot(animal(i).EPOCH(tempPlethSignal(optimal).plethAutomatedSleepIdeal == 2), tempPlethSignal(optimal).plethAutomatedSleepIdeal(tempPlethSignal(optimal).plethAutomatedSleepIdeal == 2) + 2, '.') 
                plot(animal(i).EPOCH(animal(i).humanPlethSleepIdeal == 2), animal(i).humanPlethSleepIdeal(animal(i).humanPlethSleepIdeal == 2) + 4, '.') 
                legend({'Human Scoring of animal(i).EEG', 'Automated Scoring from Pleth'})
         
                %%
                figure
                plot(animal(i).EPOCH, animal(i).SCORE - tempPlethSignal(optimal).plethAutomatedSleepIdeal)
                hold on
                ylim([-2, 2])
