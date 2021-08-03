%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FPImain.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------------------------------------------------------------------------%

%%% Notes:

% This script merges all the other MATLAB functions and runs them to produce
% the SCANDI and ASC videos. The algorithm works by first importing the
% SCANDI textfile data by using 'import_SCANDI'. This function extracts the
% data as a matrix format and extracts the position vectors of each vector
% field. The next function involves creating and saving the video in
% appropriate directory using 'SCANDI_video' function. Once this is done the 
% 'select_start_end' calculates the starting and ending frames at which the
% two vidoes should overlap. Using 'frameRate' the script calculate the
% appropriate frame rate (fps) at which the ASC video should run in order
% to accurately overlay on top of the SCANDI video. The last function
% 'sky_video' puts these calculations together to create the ASC video.
% This file needs to be saved inside "...\FPI\FPI-winds" directory for it
% to work. 

% Important !
% FPImain.m file must stay saved in the same directory of the other functions,
% otherwise this script will not run correctly. Therefore it must stay 
% inside the directory named "...\FPI-winds".

% Warning !
% If you want to change the rotation/theta please change the theta variable
% in SCANDI_video.m

% Clear command line
clc;
%clears workspace
clear;
% Change directory to folder in which txt files are stored
cd ("C:\Users\Rifat\OneDrive - University College London\Rifat's PC\Internship 2021\FPI\FPI-Winds"); 
% Turning off figure generation
set(0, 'DefaultFigureVisible', 'off')
%% Choosing files from the command line

prompt1 = "Please choose directory of SCANDI file with (.txt) format:";
textfile = input(prompt1);

prompt2 = "Please choose directory of ASC folder:";
ASCfold = input(prompt2);


%% importing data
[windfit,posz,posm] = import_SCANDI(textfile)

%% saving video (feb 2015)
% Change the naming of SCANDI video accordingly
SCANDI_video(windfit,posz,posm,"trial1")


%% Checking the frame selector function
[ASC_start_frame,SCANDI_start_frame,SCANDI_end_frame,ASC_end_frame] = select_start_end(windfit,ASCfold)


%% calculating correct FPS
[FPS] = frameRate(windfit,SCANDI_start_frame,SCANDI_end_frame,ASC_start_frame,ASC_end_frame)

%% creating a video from ASC
% Change the naming of ASC video accordingly
sky_video(FPS,ASCfold,"trial2")

%% saving the work space variables for importing to Python
save("FPIdata")