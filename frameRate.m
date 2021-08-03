function [FPS] = frameRate(windfit,SCANDI_start_frame,SCANDI_end_frame,ASC_start_frame,ASC_end_frame)
% This function calculates the correct frame rate that is required for the
% videos to correctly overlap on top of each other. The inputs for the
% function are the starting and ending frames calculated by
% "select_start_end.m" script. The output gives an FPS values for the frame
% rate of the ASC  video.

% Important !
% frameRate.m file must stay saved in the same directory of the other functions,
% otherwise this script will not run correctly. Therefore it must stay 
% inside the directory named "...\FPI-winds".

    % CASE 1: SCANDI time stamps are larger than ASC
    if SCANDI_start_frame > 1 && SCANDI_end_frame < round(height(windfit)/10)
        FPS = (ASC_end_frame/(SCANDI_end_frame-SCANDI_start_frame))*4; % 4fps = hard coded frame rate of scandi vid
    % CASE 2: SCANDI time stamps are smaller than ASC
    elseif SCANDI_start_frame == 1 && SCANDI_end_frame == round(height(windfit)/10)
        FPS = ((ASC_end_frame-ASC_start_frame)/SCANDI_end_frame)*4;
    % CASE 3: SCANDI start time stamps is smaller than ASC
    elseif SCANDI_start_frame == 1 && SCANDI_end_frame < round(height(windfit)/10)
        FPS = ((ASC_end_frame-ASC_start_frame)/SCANDI_end_frame)*4;
    % CASE 4: SCANDI start time stamps is larger than ASC
    elseif  SCANDI_start_frame > 1 &&  SCANDI_end_frame == round(height(windfit)/10)
        FPS = (ASC_end_frame/(SCANDI_end_frame-SCANDI_start_frame))*4;
    end
       
end

