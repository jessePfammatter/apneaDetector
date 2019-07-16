# apneaDetector

Software for the detection of apneas from rodent pleth data. This code allows the installation of a Matlab app that can take rodent pleth data from an EDF file and outputs data for apnea detection. This app was built under Matlab 2019a and may require this version of the software in order to run properly. Please contact Jesse Pfammatter (pfammatter@wisc.edu or jesse.pfammatter@gmail.com) for questions, comments, bug notifications, feature enhancement suggestions, etc. 

This software requires Matlab's curvefitting toolbox to be installed.

Please download sample files from https://www.dropbox.com/sh/5dpmzuvlebjbheq/AABBQOaLNCXxSjBD-T89iSk4a?dl=0 to test software.

# Update 3 07/15/19

Added additional files to app package so that it runs on naive machines. Other additions include:

1. Toggle button to add raw data visibility to event window.. this isn't finished.
2. Some plotting visual changes.
3. Added a 'session notes' section where users can enter information relevant to their session of scoring.

A few of the features to be added in next release:

1. legends for all plots.
2. Improved speed during apnea detection.
3. Improve event inspector display window to include ability to change the xlimits and view a wider timescale and additional plot toggle functionality.


# Update 2 07/15/19

Updated app to apneaDetector v0.2

1. The 'Save' functionality doesn't seem to be functioning properly in the deployed app so for the time being I created an 'Export Data' menu item which allows users to save data from the app to be manipulated outside of the app.
2. I also fixed the known issue listed as #6 in Update 1 07/15/19.

# Update 1 07/15/19

First beta relase of this software on July 15th 2019. apneaDetector v0.1

Currently Known Issues:

1. 'Close' menus item not functional.
2. Ability to load in a human scored sleep file is not currently available.
3. Suporting plots on the right of the detection window are not functional.
4. 'Save' functionality is available which allows saving of the current state of the app, however the warning, 'Unable to save App Designer app object. Save not supported for matlab.apps.AppBase objects' shows up. Essentially the relevant data is saved and can be accessed directly via Matlab but cannot be 'Loaded' back into the application. This is due to a Matlab glitch and is being worked on through a support ticket at Matlab.
5. Sporatic display problems when slecting different channels from the imported EDF file or using the zoom menu functionality. This is due to a Matlab glitch and is being worked on through a support ticket at Matlab.
6. Errors saying, 'Error using newplot (line 64), Error while evaluating Figure CreateFcn. Previously accesible file ... is not inaccesible' appear during apnea detection. The app appears to run properly desipte these errors.
