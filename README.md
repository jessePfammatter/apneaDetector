# apneaDetector

Software for the detection of apneas from rodent pleth data. This code allows the installation of a Matlab app that can take rodent pleth data from an EDF file and outputs data for apnea detection. This app was built under Matlab 2019a and may require this version of the software in order to run properly. Please contact Jesse Pfammatter (pfammatter@wisc.edu or jesse.pfammatter@gmail.com) for questions, comments, bug notifications, feature enhancement suggestions, etc. 

This software requires Matlab's curvefitting toolbox to be installed.

Please download sample files from https://www.dropbox.com/sh/5dpmzuvlebjbheq/AABBQOaLNCXxSjBD-T89iSk4a?dl=0 to test software.

Please visit the help document (https://github.com/jessePfammatter/apneaDetector/blob/master/apneaDetector_Help.md) for infomration on using the app to analyzing data.

***A note to non-developer types:*** I've included my development scripts/functions such that the experienced user can modify and repackage this app to suit their needs. It's not suggested to download and manipulate the extra program files unless you are familiar with this process.

# Update 11 10/07/19, version 0.10

The updates in this version were provided by Jonathan Ouellette. Thanks!

Changelog:
1. Fixed the uisave error.
2. Added a text box that displays the filepath of the human sleep scoring.
3. Added a few lines in the import .mat section that will display the filepath of the human sleep if it was used for the exported file.
4. Fixed error that preivously incorrectly converted the wake start/stop times from 20Hz to 500Hz. Changed conversion factor value from 24 to 25.

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
5. Fixed an issue where some apnea durations were not getting labeled propertly in the breath clustering window.

# Update 8 08/01/19, version 0.8

Changelog:

1. Added ability to import human sleep score files. These files must be in nueroscore output for NeuroScore. If they are not from neuroscore then files must be a csv file with columns called StartTime1 (start times of sleep sections in seconds) and EndTime1 (end times in seconds).
2. Added ability to load/edit previously saved files.
3. Reduced hight of app window and disabled resize of insepctor window because it causes problems with plotting.
4. Added a window to allow a popout window the filtered signal that can be used for zooming around and exploring the signal.
5. Removed the toggle button group for auto apnea classification and replaced it with a single line of text that isn't editable and that's hopefully less confusing for users.
6. Removed menu option for changing of apnea threshold as 2x the average breath interval is the published apnea accepted duration.
7. Added a menu button to toggle on/off the circles which indicate which event the event inspector in currently highlighting -- this helps with app speed for slower machines.
8. Updated the detection of sighs to utilize tidal volume to help differentite sighs from regular breaths. (Using the negative deflection associated with some sighs isn't consitently workable for all files.)
9. Fixed the plotting of events in the cluster window to match their appropriate events.
10. Fixed plotting the the apnea durations in the event inspector window.

Known Issues:
1. the breath amplitude histogram should shows a display of 'breaths' including those from wake. This is not what is used in the algorithm and as such I need to fix this window.

# Update 7 07/25/19, version 0.7

Changelog:

1. Updated supporting plots on right of screen to fix axes dissapearing problem.
2. Changed y label of main plots to indicate that signals are normalized.
3. Fixed problem where post-sigh artifacts are causing mistakes in the breath clustering view.
4. Fixed issue where marker data points are showing up in the legend.
5. Changed the 'Unset' button to read 'Unadjusted' for clarity.
6. Fixed plotting issue where some 'normal breaths' were shown in the range of apneas in the clustering window. This was caused because some dong duration missed breaths were found during wake were getting counted as normal breaths.
7. Checked all options and made sure that unavailable functionality is greyed out or not visible.
8. Fixed issue where importing apnea scoring isn't properly displayed.
9. Fixed plotting of apnea comparisons.
10. Added functionality to zoom in and out of event Inspector window to look for sighs, etc. prior to anpea.
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
3. Changed the asthetic of the plots to all have white background.
4. Added a version indicator to the menu list.

Known issues:

Duration of apnea is plotted a bit short. The data for the apneas are stored correctly. I think this has to do with the new plotting methods which reduce the number of data points shown/drawn in each plot.

# Update 5 07/19/19, version 0.5

Changelog:

1. Improved code annotation and cleaned up some unecessary text in apneaDetector.mlapp
2. Improved support plots on the right side of app.
3. Fixed issue where artifact after sigh was causing breaths to be detected after sigh which caused shortened apneas and innaccurate classification.
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
7. Reduced number of data points plotted in serval plot windows in order to reduce the number of 'glitches' as a woraround for Matlab's plotting methods issues.

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

First beta relase of this software on July 15th 2019. apneaDetector v0.1

Currently Known Issues:

1. 'Close' menus item not functional.
2. Ability to load in a human scored sleep file is not currently available.
3. Suporting plots on the right of the detection window are not functional.
4. 'Save' functionality is available which allows saving of the current state of the app, however the warning, 'Unable to save App Designer app object. Save not supported for matlab.apps.AppBase objects' shows up. Essentially the relevant data is saved and can be accessed directly via Matlab but cannot be 'Loaded' back into the application. This is due to a Matlab glitch and is being worked on through a support ticket at Matlab.
5. Sporatic display problems when slecting different channels from the imported EDF file or using the zoom menu functionality. This is due to a Matlab glitch and is being worked on through a support ticket at Matlab.
6. Errors saying, 'Error using newplot (line 64), Error while evaluating Figure CreateFcn. Previously accesible file ... is not inaccesible' appear during apnea detection. The app appears to run properly desipte these errors.
