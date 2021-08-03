function SCANDI_video(windfit,posz,posm,path)
% This function takes the SCANDI data as an argument to create a video of
% discretely changing wind fields within the SCANDI zones. The routine
% creates a plot of horizontal wind fields for each time stamp. These plots
% are then stacked together using a for loop. The "videowriter" function
% takes each plot to create each frame of the video. Playing all these
% frames back to back at a fixed FPS, gives the resulting video. 
% The path argument takes the directory in which the user wants to store
% the video and the name of thefile. 
% Example path = "SCANDI_animations\SCANDI_March14", where SCANDI_March14
% is the file name.
% posz and posm are the position of the wind vectors within the SCANDI
% zones. These will be taken from the output of import_SCANDI.

% Important !
% SCANDI_video.m file must stay saved in the same directory of the other functions,
% otherwise this script will not run correctly. Therefore it must stay 
% inside the directory named "...\FPI-winds".

    % Initiating the videowriter function
    v = VideoWriter(path,"MPEG-4")
    v.FrameRate = 4; % hard coded FPS 
    open(v);
    theta = 32; %%% CHANGE THIS TO 0 DEG TO KEEP ZONES GEO NORTH %%%
    % iterating over each plot to create frame by frame video
    for n = 1:10:height(windfit)
        if n+3 > height(windfit)
            break
        end

        U = windfit(n+2,1:end)';
        V = windfit(n+3,1:end)';
        [zon, mer] = rot_transf(theta,U,V); 
        Scandi_zones([0,0],1);
        hold on
        quiver(posz/1000,posm/1000,zon,mer,"b","LineWidth",1.5);
        axis off;
        xlim([-700 700]);
        ylim([-600 600]);
        capt = duration(hours(windfit(n,1)),"Format","hh:mm");
        title("SCANDI: "+string(capt)+" UT",'Position',[-630, 515, 0], "FontSize",10);
        frame = getframe(gcf);
        writeVideo(v,frame);

    end

    close(v);
    hold off;

end

