# apneaDetector Help

Software for the detection of apneas from rodent pleth data. This code allows the installation of a Matlab app that can take rodent pleth data from an EDF file and outputs data for apnea detection. This app was built under Matlab 2019a and may require this version of the software in order to run properly. Please contact Jesse Pfammatter (pfammatter@wisc.edu or jesse.pfammatter@gmail.com) for questions, comments, bug notifications, feature enhancement suggestions, etc. 

This software requires Matlab's curvefitting toolbox to be installed.

Please download sample files from https://www.dropbox.com/sh/5dpmzuvlebjbheq/AABBQOaLNCXxSjBD-T89iSk4a?dl=0 to test software.

***A note to non-developer types:*** I've included my development scripts/functions such that the experienced user can modify and repackage this app to suit their needs. It's not suggested to download and manipulate the extra program files unless you are familiar with this process.

# App Layout.

The top panel (Unfiltered Signal Panel) of the app is dedicated to the original and unfiltered pleth signal and will populate when a user selects a relevant EDF file from their machine via File > Load EDF. The middle panel (Filtered Signal Panel) is dedicated to filtered pleth signal and will populate once a user has detected apneas. The bottom of the app contains the 'Event Inspector' which allows users to view and modify the label for each automatically detected apnea, the 'Breath Clustering' panel which provides additional data on the positioning of apneas breaths relative to other breaths in terms of breath amplitudes and inter-event intervals. On the right side of the app are 3 windows (Optional Plots Panel) were select summary data can be viewed. A user may change the type of data that is shown in each of these panels. On the bottom of app users will find areas dedicated to 'Event Notes' which are logged independentl for each apnea detected and 'Session Notes' where users are encouraged to record relevant thoughts, notes, and metadata (e.g. who is doing the scoring, etc.). At the very bottom of the app is a window that shows the filepath to the current file being analyzed.

# How to Analyze an EDF File for Apneas.

To use the fully automated apnea detection first open the software. Then select File > Load EDF from the menu or the 'Load Signal' hotkey. Next users should select an appropriate pleth channel from the EDF record they imported using the channel dropdown menu located in the upper right corner of 'Unfiltered Signal' window at the top of the app. Once an appropriate pleth channel has been selected users initiate the apnea detection with the menu command File > Detect Apneas and Sleep or by using the 'Detect Apneas' hotkey. Apnea detection may take several minutes depending on the speed of your machine (approximatly 40 seconds on a IMAC 4 GHz Core i7 w/ 32 GB of ram).

# Fully Automated Scoring of Sleep and Apneas.

apneaDetector was designed to be a fully automated method of apnea detection. In order to allow the detector to be robust enough to handle variability in pleth records from different animal models/individuals/recording equipment we select most of the parameters used in the algorithm based on the inherent properties of each file. For example, rather than manually setting a duration of time as an 'apnea' we first detect all breaths taken during the record. We then use the mode and spread of all points histogram (which equals the mean and standard deviation of the data if the data is normally distributed) of breaths that occur during sleep to identify the 'normal' inter-breath interval. We then identify apneas as events that are 2x the normal inter-breath interval. Throughout the analysis there are numerous parameters that are selected in a similar manner. For complete details of our analysis please see *link to future publication* or contact the developer, Jesse Pfammatter (pfammatter@wisc.edu) for more information.

# Using Human Sleep Scoring Instead of Automated Sleep Scoring.

While not encouraged, it is possible to substitute human manual sleep scoring for the computer's automated scoring. To do this, select Settings > Sleep Detection Settings > Use Human Sleep Scoring for Apnea Detection. Then a user should import a sleep scoring file (note that while the file is loaded, there is no changes to plotting or a confirmation that the file was loaded) and then follow the 'How to Analyze an EDF File for Apneas' section. Note that the automated scoring data will not show up in the app window, but it may still be accessed from the exported .mat or .xlsx files. However, apnea data in the app and in the exported files will have been done using the human sleep scoring and not the automated scoring.

# Comparing Human and Automated Sleep and Apnea Detection.

After detecting apneas and sleep, a user may import .csv files containing human scored records for apneas and/or sleep in order to compare performance of the automated detection and manually scored records. In order to load manual apnea detection select File > Load Human Apnea Detection for the menu. To load manual sleep detection select File > Load Human Sleep Scoring. Once either/both manual records are loaded, the app automatically calculates a confusion matrix comparing the automated and human scorings. Data from these comparisons can be accessed from exported .xlsx or .mat files and can also be viewed in optional summary plots on the right of the app. See sample sleep and apnea scoring files for proper format -- format originates from Neuro Score exporting format.

# Exporting Data.

There are currently two ways to export data from apneaDetector: 

1. Users can export data to a csv file by selecting File > Export Data to Spreadsheet. This produces a .xlsx file that includes a page for apnea summary data (and manual apnea scoring if uploaded), a page for hypopnea summary data, automated sleep scoring (and manual sleep scoring if uploaded), and a page that shows full data for every breath.
2. Users may export a .mat file which can be used in the matlab terminal to analyze data and can be re-imported back into apneaDetector to view and explore pleth records that have previously been analyzed.

# Known Glitches.

1. Sometimes data just doesn't show up in a plot window -- this mostly happens in the unfiltered signal window when swithing between different signals. What causes this problem is loading lots of data all at once which has something to do with the way the Matlab app designer uses Java to do plotting for apps.. If this happens just select another channel, and go back to the channel that didn't load properly. This error is not entirely uncommon and Matlab is working on a fix. For my part, I've reduced the number of visible data points as much as possible.
2. If user 'cancels' progress bar, an error is thrown in the Matlab terminal. Users can continue to use the software despite the error.

# Future Improvements.

1. Allow humans to edit which events are breaths.