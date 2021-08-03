function sky_video(FPS,ASCPath,savedir)

% The function loops over all the ASC pictures for a given date and creates
% a video with a given frame rate(fps). The inputs for this function
% involve the FPS, the path in which the ASC pictures are stored and the
% directory in which the video needs to be saved with the file name
% extension. The output of this function is the ASC video being saved in
% the same directory as this function.

% importing images from ASC folder and setting FPS

% Important !
% sky_video.m file must stay saved in the same directory of the other functions,
% otherwise this script will not run correctly. Therefore it must stay 
% inside the directory named "...\FPI-winds".

files = dir(ASCPath +"\*.jpg");
v = VideoWriter(savedir,"MPEG-4");
v.FrameRate = FPS;
open(v);

for k = 1:length(files)
    
    chr = files(k).name;
    h = imread(ASCPath+"\"+chr);
    chr = strrep(chr, '_', ' ');
    h = flipdim(h,2);
    h = imshow(h,"XData", [-840 800], "YData", [-610 580]);
    annotation('textbox',[0.60 0.79 0.3 0.1],"FitBoxToText","on",'String',chr,"BackgroundColor","w","FontSize", 16)
    annotation('textbox',[0.66 0.86 0.3 0.1],"FitBoxToText","on",'String',chr,"BackgroundColor","black","FontSize", 25)
    frame = getframe(gcf);
    writeVideo(v,frame);
    
end

close(v);
hold off;
end

