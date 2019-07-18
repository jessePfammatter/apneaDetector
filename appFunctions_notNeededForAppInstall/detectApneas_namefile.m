% namefile for detectApneas

i = 0;

basePath2 = '/Volumes/cookieMonster/mj1lab_mirror/apneaProject/';

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '1A';
animal(i).animalID = '5_6C_A';
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).time = 0;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/1A_1B/1A_1B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/1A_1B/1A_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/1A_1B/1A2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/1A_1B/1B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '1B';
animal(i).animalID = '5_6C_B';
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).time = 0;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/1A_1B/1A_1B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/1A_1B/1B_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/1A_1B/1B2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/1A_1B/1B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '2A';
animal(i).animalID = '5_6C_A';
animal(i).time = 1;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/2A_2B/2A_2B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/2A_2B/2A_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/2A_2B/2A2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/2A_2B/2A_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '2B';
animal(i).animalID = '5_6C_B';
animal(i).time = 1;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/2A_2B/2A_2B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/2A_2B/2B_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/2A_2B/2B2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/2A_2B/2B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '3A';
animal(i).animalID = '5_6C_A';
animal(i).time = 7; % days post treatment
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/3A_3B/3A_3B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/3A_3B/3A_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/3A_3B/3A2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/3A_3B/3A_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '3B';
animal(i).animalID = '5_6C_B';
animal(i).time = 7; % days post treatment
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/3A_3B/3A_3B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/3A_3B/3B_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/3A_3B/3B2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/3A_3B/3B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '4A';
animal(i).animalID = '7_8N_A';
animal(i).time = 0;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/4A_4B/4A_4B_EDF.edf'); 
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/4A_4B/4A_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/4A_4B/4A2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/4A_4B/4A_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '4B';
animal(i).animalID = '7_8N_B';
animal(i).time = 0;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/4A_4B/4A_4B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/4A_4B/4B_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/4A_4B/4B2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/4A_4B/4B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '5A';
animal(i).animalID = '7_8N_A';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/5A_5B/5A_5B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/5A_5B/5A_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/5A_5B/5A2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/5A_5B/5A_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '5B';
animal(i).animalID = '7_8N_B';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/5A_5B/5A_5B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/5A_5B/5B_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/5A_5B/5B2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/5A_5B/5B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '6A';
animal(i).animalID = '7_8N_A';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/6A_6B/6A_6B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '6B';
animal(i).animalID = '7_8N_B';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/6A_6B/6A_6B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;


% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '7A';
animal(i).animalID = '7_8C_A';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 0; % baseline
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/7A_7B/7A_7B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/7A_7B/7A_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/7A_7B/7A2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/7A_7B/7A_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '7B';
animal(i).animalID = '7_8C_B';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 0;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/7A_7B/7A_7B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/7A_7B/7B_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/7A_7B/7B2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/7A_7B/7B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '8A';
animal(i).animalID = '7_8C_A';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 1;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/8A_8B/8A_8B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/8A_8B/8A_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/8A_8B/8A2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/8A_8B/8A_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '8B';
animal(i).animalID = '7_8C_B';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 1;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/8A_8B/8A_8B_EDF.edf'); 
animal(i).breathChannel = 7; 
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/8A_8B/8B_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/8A_8B/8B2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/8A_8B/8B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '9A';
animal(i).animalID = '7_8C_A';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 7;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/9A_9B/9A_9B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/9A_9B/9A_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/9A_9B/9A2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/9A_9B/9A_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '9B';
animal(i).animalID = '7_8C_B';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 7;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/9A_9B/9A_9B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;
animal(i).humanScoreFilesep1 = strcat(basePath2, '190218_EDF_Exports_Scored/9A_9B/9B_Marker.csv');
animal(i).humanScoreFilesep2 = strcat(basePath2, '190218_EDF_Exports_Scored/9A_9B/9B2_Marker.csv');
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/9A_9B/9B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '10A';
animal(i).animalID = '3_4C_A';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 0;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/10A_10B/10A_10B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/10A_10B/10A_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '10B';
animal(i).animalID = '3_4C_B';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 0;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/10A_10B/10A_10B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/10A_10B/10B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '11A';
animal(i).animalID = '3_4C_A';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 1;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/11A_11B/11A_11B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/11A_11B/11A_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '11B';
animal(i).animalID = '3_4C_B';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 1;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/11A_11B/11A_11B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/11A_11B/11B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '12A';
animal(i).animalID = '3_4C_A';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 7;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/12A_12B/12A_12B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/12A_12B/12A_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '12B';
animal(i).animalID = '3_4C_B';
animal(i).combinedTreatment = 'CIH_NTsiRNA';
animal(i).treatment = 'CIH';
animal(i).intervention = 'NTsiRNA';
animal(i).time = 7;
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/12A_12B/12A_12B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;
animal(i).humanSleepScoreFilesep = strcat(basePath2, '190218_EDF_Exports_Scored/12A_12B/12B_Sleep.csv');

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '13A';
animal(i).animalID = '1_2C_A';
animal(i).time = 0;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/13A_13B/13A_13B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '13B';
animal(i).animalID = '1_2C_B';
animal(i).time = 0;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/13A_13B/13A_13B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '14A';
animal(i).animalID = '1_2C_A';
animal(i).time = 1;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/14A_14B/14A_14B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '14B';
animal(i).animalID = '1_2C_B';
animal(i).time = 1;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/14A_14B/14A_14B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '15A';
animal(i).animalID = '1_2C_A';
animal(i).time = 7;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/15A_15B/15A_15B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '15B';
animal(i).animalID = '1_2C_B';
animal(i).time = 7;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/15A_15B/15A_15B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '16A';
animal(i).animalID = '1_2N_A';
animal(i).time = 0;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/16A_16B/16A_16B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '16B';
animal(i).animalID = '1_2N_B';
animal(i).time = 0;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/16A_16B/16A_16B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '17A';
animal(i).animalID = '1_2N_A';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/17A_17B/17A_17B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '17B';
animal(i).animalID = '1_2N_B';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/17A_17B/17A_17B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;


% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '18A';
animal(i).animalID = '1_2N_A';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/18A_18B/18A_18B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '18B';
animal(i).animalID = '1_2N_B';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/18A_18B/18A_18B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '19A';
animal(i).animalID = '3_4N_A';
animal(i).time = 0;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/19A_19B/19A_19B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '19B';
animal(i).animalID = '3_4N_B';
animal(i).time = 0;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/19A_19B/19A_19B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '20A';
animal(i).animalID = '3_4N_A';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/20A_20B/20A_20B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '20B';
animal(i).animalID = '3_4N_B';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/20A_20B/20A_20B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;


% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '21A';
animal(i).animalID = '3_4N_A';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/21A_21B/21A_21B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '21B';
animal(i).animalID = '3_4N_B';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/21A_21B/21A_21B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;


% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '22A';
animal(i).animalID = '9_10N_A';
animal(i).time = 0;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/22A_22B/22A_22B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '22B';
animal(i).animalID = '9_10N_B';
animal(i).time = 0;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/22A_22B/22A_22B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '23A';
animal(i).animalID = '9_10N_A';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/23A_23B/23A_23B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '23B';
animal(i).animalID = '9_10N_B';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/23A_23B/23A_23B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '24A';
animal(i).animalID = '9_10N_A';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/24A_24B/24A_24B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '24B';
animal(i).animalID = '9_10N_B';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/24A_24B/24A_24B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '25A';
animal(i).animalID = '5_6N_A';
animal(i).time = 0;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/25A_25B/25A_25B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '25B';
animal(i).animalID = '5_6N_B';
animal(i).time = 0;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/25A_25B/25A_25B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '26A';
animal(i).animalID = '5_6N_A';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/26A_26B/26A_26B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '26B';
animal(i).animalID = '5_6N_B';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/26A_26B/26A_26B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '27A';
animal(i).animalID = '5_6N_A';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/27A_27B/27A_27B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '27B';
animal(i).animalID = '5_6N_B';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_siPKCz';
animal(i).treatment = 'Nx';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/27A_27B/27A_27B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '28A';
animal(i).animalID = '9_10C_A';
animal(i).time = 0;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/28A_28B/28A_28B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '28B';
animal(i).animalID = '9_10C_B';
animal(i).time = 0;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/28A_28B/28A_28B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '29A';
animal(i).animalID = '9_10C_A';
animal(i).time = 1;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/29A_29B/29A_29B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '29B';
animal(i).animalID = '9_10C_B';
animal(i).time = 1;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/29A_29B/29A_29B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '30A';
animal(i).animalID = '9_10C_A';
animal(i).time = 7;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/30A_30B/30A_30B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '30B';
animal(i).animalID = '9_10C_B';
animal(i).time = 7;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/30A_30B/30A_30B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '31A';
animal(i).animalID = '11_12C_A';
animal(i).time = 0;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/31A_31B/31A_31B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '31B';
animal(i).animalID = '11_12C_B';
animal(i).time = 0;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/31A_31B/31A_31B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '32A';
animal(i).animalID = '11_12C_A';
animal(i).time = 1;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/32A_32B/32A_32B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '32B';
animal(i).animalID = '11_12C_B';
animal(i).time = 1;
animal(i).combinedTreatment = 'CIH_siPKCz';
animal(i).treatment = 'CIH';
animal(i).intervention = 'siPKCz';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/32A_32B/32A_32B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '33A';
animal(i).animalID = '11_12N_A';
animal(i).time = 0;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/33A_33B/33A_33B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '33B';
animal(i).animalID = '11_12N_B';
animal(i).time = 0;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/33A_33B/33A_33B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '34A';
animal(i).animalID = '11_12N_A';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/34A_34B/34A_34B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '34B';
animal(i).animalID = '11_12N_B';
animal(i).time = 1;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/34A_34B/34A_34B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '35A';
animal(i).animalID = '11_12N_A';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/35A_35B/35A_35B_EDF.edf'); 
animal(i).breathChannel = 6;
animal(i).temperatureChannel = 3;

% ---------------------------------------------------------- %
i = i + 1;
animal(i).recordID = '35B';
animal(i).animalID = '11_12N_B';
animal(i).time = 7;
animal(i).combinedTreatment = 'Nx_NTsiRNA';
animal(i).treatment = 'Nx';
animal(i).intervention = 'NTsiRNA';
animal(i).filespec = strcat(basePath2, '190218_EDF_Exports_Scored/35A_35B/35A_35B_EDF.edf'); 
animal(i).breathChannel = 7;
animal(i).temperatureChannel = 3;


