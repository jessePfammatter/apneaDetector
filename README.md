# apneaDetector

Software for the detection of apneas from rodent pleth data. This code allows the installation of a Matlab app that can take rodent pleth data from an EDF file and outputs data for apnea detection. This app was built under Matlab 2019a and may require this version of the software in order to run properly. Please contact Jesse Pfammatter (pfammatter@wisc.edu or jesse.pfammatter@gmail.com) for questions, comments, bug notifications, feature enhancement suggestions, etc. 

This software requires Matlab's curvefitting toolbox to be installed.

Please download sample files from https://www.dropbox.com/sh/5dpmzuvlebjbheq/AABBQOaLNCXxSjBD-T89iSk4a?dl=0 to test software.

Please visit the help document (https://github.com/jessePfammatter/apneaDetector/blob/master/apneaDetector_Help.md) for information on using the app to analyzing data.

***A note to non-developer types:*** I've included my development scripts/functions such that the experienced user can modify and repackage this app to suit their needs. It's not suggested to download and manipulate the extra program files unless you are familiar with this process.


# Update 21 07/03/20, version 0.21
1. Fixed an error where unchecking 'Display Event Marker' prior to loading signal caused an error in the command window.
2. Added the ability for the computer to identify REM-like periods marked by humans in nueroscore. Summary data and export functionality include REM specific apnea numbers. Apneas identified in REM-like periods are included in the regular summary data and then counted again in the REM summary data.

# Update 20 04/14/20, version 0.20
1. Added a toggle to show post sigh plus (PSP) duration in the event window. This helps in the case where a sigh is missed and subsequent apneas might need to be manually classified as PSP.
2. Fixed a glitch where human sleep scores and apnea scores loaded for a particular file don't clear from system memory when a new EDF record is analyzed for apneas.
3. Added more user friendly control of sigh detection threshold near the event inspector.
4. Fixed a few menu items to be a bitmore user friendly.

# Update 19 04/02/20, version 0.19
1. Fixed promblem where the data timeSincePreviousSigh was showing up as zero except for the last apnea.
2. Simplified apnea classification settings by removing the requirement for sighs to have a particular tidal volume.
3. Fixed issue where menu items that are not ready to be used were visibile.
4. Fixed an issue where Sleep scoring confusion matrix had false positives and true negatives reversed.
5. Fixed a display issue where when 'use human sleep scoring is selected' the label says, 'Machine Sleep' instead of 'Human Sleep'.
6. Fixed several other small errors throughout the code.

# Update 18 02/19/20, version 0.18
1. Fixed an error with file output when saving the output as a .mat file.
2. Changed the method of dropping the last 2 minutes of apneas. Now last 2 minutes of the record are considered wake and therefore apneas are not found in that section. This is better than the previous method because the apnea frequency is now calculated properly. 
3. A few other bug fixes.

# Update 17 02/17/20, version 0.17
1. A bunch of random bug fixes to make saving and loading .mat files work properly again. Changes by Jonathan Ouellette.
2. Fixed some bug issues related to loading of the splash screen. 

# Update 16 02/13/20, version 0.16

1. Changed the background of apneaTypeLabel to white so it is more visable.
2. Changed the save features back to uisave so that users can determine where they save their files.
3. Changed the autosaved name for .mat and spreadsheet outputs so they use a underscore instead of a period for the version number. Previously this was causing confusion for computer interpretation of the file extensions.
4. Added warning to users when selecting PSP multiplier change.
5. Dropped the last 2 minutes from consideration of apnea detection. During this time any 'potential apneas' are likely artifact caused by dissconection of the system/recording.
6. Changed the default PSP multiplier to 7 -- 3 was way too short, an effective time of around 2 seconds, 10 produces a duration of around 7 seconds and a default of 7 produces abot 5 second durations.
7. Fixed a few errors with loading human sleep scores for apnea detection. Jonathan Ouellette made these changes.
8. Converted all the time axis to datetime objects so that users know what time of day the apneas are occuring. It also makes the axes a little more easy to interpret.
9. Improved export functions to include time of day informtaion.

# Update 15 02/07/20, version 0.15

1. Fixed a bug in the PSP multiplier label where it wouldn't show up properly once a signal was loaded.
2. Moved the explore signal label in the filtered signal and apnea detection window so that it no longer is in the way of the sleep and apnea records.
3. Fixed an error where exporting to spreadsheet wasn't allowed because of duplicate naming of a variable.
4. Implemented a color coding in the event inspector window. This edit written by Jonathan Ouellette.


# Update 14 01/31/20, version 0.14

1. Converted Post Sigh Duration default to a multiplier of 3 instead of 10 as default and added a spinner in the Event Inspector window that allows users to change this default. There was some confusion about if this parameter was coded as a function of the breath rate and indeed it is and has been for several versions of the code.
2. Improved the excel output file to have more information and better labeling. Now includes data sheets for parameters used in detection, summary statistics for apneas, data on every apnea found at used thresholds, data for every breath identified, sleep scoring, and some truth tables if manual sleep and apnea comparisons are loaded. Many of the changes to this output file come from collaborative work with Jonathan Ouellette.
3. Changed the background color to powder blue.. This was a very important change.
4. Fixed an error in the saving of the .mat output file that resulted in a crash previously.

# Update 13 11/14/19, version 0.13

1. Simplified the input of detectBreathsApneasAndSleepFromPleth function utilized by the GUI.

# Update 12 11/08/19, version 0.12

Changelog:
1. Added text to the title of the Notes box to inform users not to use the Return key. It's a temporary fix but it will hopefully prevent the problem where users loose notes that they have added after starting a new line.
2. I've added the ability to export files to csv. Upon selection of this method the file automatically saves in the same directory as the file that is being analyzed.
3. I've added progress dialog bars after user loads certain files. Previously users were unaware that the app was processing data and on slower machines it's unclear what's going on.
4. Updated help file to help users navigate .mat app internals.
5. changed the representation of the machine wake/sleep scoring to match the human sleep scoring instead of being inverse.
6. Fixed an error where the truth table was incorrect for the sleep scoring.
7. Added an additional information bar at the bottom of the app screen so that users can see which apnea scoring file they have loaded if they choose to load human apneas.

# Update 11 10/07/19, version 0.11

The updates in this version were provided by Jonathan Ouellette. Thanks!

Changelog:
1. Fixed the uisave error.
2. Added a text box that displays the filepath of the human sleep scoring.
3. Added a few lines in the import .mat section that will display the filepath of the human sleep if it was used for the exported file.
4. Fixed error that previously incorrectly converted the wake start/stop times from 20Hz to 500Hz. Changed conversion factor value from 24 to 25.

# Update 10 08/29/19, version 0.10

Changelog:

1. Added the ability to use human sleep scoring rather than just automated detection when doing apnea detection.
2. Included summary information for hypopneas in summary outputs.
3. Provided an instruction manual for and analyzing a file and navigating the Matlab structure produced after an analysis.
4. Fixed file export glitches.
5. Removed hypopneas that were listed during automated or human identified 'wake'.

# Update 9 08/08/19, version 0.9

Changelog:

1. fixed the toggle button add/remove identification circles in filtered signal window and breath clustering window.
2. Added some menu settings for sleep detection, sigh detection, and display settings.
3. Added an 'About' menu item pointing to the github repository and the software version number.
4. Fixed plotting for human scored apneas in the eventInspector window.
5. Fixed an issue where some apnea durations were not getting labeled properly in the breath clustering window.

# Update 8 08/01/19, version 0.8

Changelog:

1. Added ability to import human sleep score files. These files must be in nueroscore output for NeuroScore. If they are not from neuroscore then files must be a csv file with columns called StartTime1 (start times of sleep sections in seconds) and EndTime1 (end times in seconds).
2. Added ability to load/edit previously saved files.
3. Reduced height of app window and disabled resize of inspector window because it causes problems with plotting.
4. Added a window to allow a popout window the filtered signal that can be used for zooming around and exploring the signal.
5. Removed the toggle button group for auto apnea classification and replaced it with a single line of text that isn't editable and that's hopefully less confusing for users.
6. Removed menu option for changing of apnea threshold as 2x the average breath interval is the published apnea accepted duration.
7. Added a menu button to toggle on/off the circles which indicate which event the event inspector in currently highlighting -- this helps with app speed for slower machines.
8. Updated the detection of sighs to utilize tidal volume to help differentiate sighs from regular breaths. (Using the negative deflection associated with some sighs isn't consistently workable for all files.)
9. Fixed the plotting of events in the cluster window to match their appropriate events.
10. Fixed plotting the apnea durations in the event inspector window.

Known Issues:
1. the breath amplitude histogram should show a display of 'breaths' including those from wake. This is not what is used in the algorithm and as such I need to fix this window.

# Update 7 07/25/19, version 0.7

Changelog:

1. Updated supporting plots on right of screen to fix axes disappearing problem.
2. Changed y label of main plots to indicate that signals are normalized.
3. Fixed problem where post-sigh artifacts are causing mistakes in the breath clustering view.
4. Fixed issue where marker data points are showing up in the legend.
5. Changed the 'Unset' button to read 'Unadjusted' for clarity.
6. Fixed plotting issue where some 'normal breaths' were shown in the range of apneas in the clustering window. This was caused because some long duration missed breaths were found during wake were getting counted as normal breaths.
7. Checked all options and made sure that unavailable functionality is greyed out or not visible.
8. Fixed issue where importing apnea scoring isn't properly displayed.
9. Fixed plotting of apnea comparisons.
10. Added functionality to zoom in and out of event Inspector window to look for sighs, etc. prior to apnea.
11. Added hotkeys for loading signal and apnea detection.
12. Used Matlab profiler to identify slow areas in app and reduced runtime from ~80 seconds to ~45 seconds on my machine. Still other areas to improve speed if needed.
13. Added a cancel button to apnea detection wait window.

Future Updates:
1. Show hypopneas in breath clustering window.
2. Clicking on event in the clustering window or in the filtered signal window will take you to that event in the event inspector window.
3. Allow importing of sleep score files.
4. Allow import of saved data to inspect record.

# Update 6 07/22/19, version 0.6

Changelog:

1. Added summary plots for windows 2/3 on the right side of the plot
2. Updated the starting position of the apneaDetector window to [0, 0] to prevent problems on smaller screens... Still problematic on really small screens.
3. Changed the aesthetic of the plots to all have white background.
4. Added a version indicator to the menu list.

Known issues:

Duration of apnea is plotted a bit short. The data for the apneas are stored correctly. I think this has to do with the new plotting methods which reduce the number of data points shown/drawn in each plot.

# Update 5 07/19/19, version 0.5

Changelog:

1. Improved code annotation and cleaned up some unnecessary text in apneaDetector.mlapp
2. Improved support plots on the right side of app.
3. Fixed issue where artifact after sigh was causing breaths to be detected after sigh which caused shortened apneas and inaccurate classification.
4. Identified all sighs, including ones that don't have an apnea directly following.
5. Fixed issue where apnea durations were being plotted incorrectly in the event inspector window. Events are still plotted a bit on the short end for some reason but the relative durations are correct after a fix to some indexing.
6. Added a button to visualize raw signal in event inspector window.

# Update 4 07/16/19, version 0.4

Changelog:

1. Added log for version and date to export object.
2. Removed visualization of fminsearch processing plots during breath and apnea detection, this improved code run time by ~80 seconds. Full run time for detecting breaths and apneas is now around ~80 seconds on an iMac (Retina 5K, 27-inch, Late 2014, 4 GHz Intel Core i7).
3. disabled mouse interactions and the toolbar visibility for all plots until bugs are repaired (Matlab ticket in progress).
4. Hid visibility of save and load functionality from the file menu until bugs are worked out.. Currently only the data export functionality is available.
5. Changed the value of the manual apnea category assign button to 'Unset' rather than to mimic the automated score. This aids the user in knowing on which events they have made a manual change.
6. Added a Legend to and improved visualization of the Filtered Signal and Apnea Detection Plot Window.
7. Reduced number of data points plotted in serval plot windows in order to reduce the number of 'glitches' as a workaround for Matlab's plotting methods issues.

New Known Issues:
As a result of this update the display indicating, 'Please Wait..' does not show at all during processing.

# Update 3 07/15/19, version 0.3

Added additional files to app package so that it runs on naive machines. Other additions include:

1. Toggle button to add raw data visibility to event window.. this isn't finished.
2. Some plotting visual changes.
3. Added a 'session notes' section where users can enter information relevant to their session of scoring.

A few of the features to be added in next release:

1. legends for all plots.
2. Improved speed during apnea detection.
3. Improve event inspector display window to include ability to change the xlimits and view a wider timescale and additional plot toggle functionality.

# Update 2 07/15/19, version 0.2

Updated app to apneaDetector v0.2

1. The 'Save' functionality doesn't seem to be functioning properly in the deployed app so for the time being I created an 'Export Data' menu item which allows users to save data from the app to be manipulated outside of the app.
2. I also fixed the known issue listed as #6 in Update 1 07/15/19.

# Update 1 07/15/19, version 0.1

First beta release of this software on July 15th 2019. apneaDetector v0.1

Currently Known Issues:

1. 'Close' menus item not functional.
2. Ability to load in a human scored sleep file is not currently available.
3. Supporting plots on the right of the detection window are not functional.
4. 'Save' functionality is available which allows saving of the current state of the app, however the warning, 'Unable to save App Designer app object. Save not supported for matlab.apps.AppBase objects' shows up. Essentially the relevant data is saved and can be accessed directly via Matlab but cannot be 'Loaded' back into the application. This is due to a Matlab glitch and is being worked on through a support ticket at Matlab.
5. Sporatic display problems when slecting different channels from the imported EDF file or using the zoom menu functionality. This is due to a Matlab glitch and is being worked on through a support ticket at Matlab.
6. Errors saying, 'Error using newplot (line 64), Error while evaluating Figure CreateFcn. Previously accessible file ... is not inaccessible' appear during apnea detection. The app appears to run properly despite these errors.
