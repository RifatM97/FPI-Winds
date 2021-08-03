# Python script combines and overlays ASC and SCANDI videos into one single video. The script uses moviepy modules and few
# other routines to decide the correct frames and fps. 

# importing relevant modules
import sys
import scipy.io as scio
import moviepy.editor as mpe
from moviepy.video.fx import resize
import moviepy.video.fx.all as vfx 

# importing and printing workspace data from MATLAB
data = scio.loadmat('FPIdata.mat')
print(float(data['FPS']))
print(data['SCANDI_start_frame'])
print(data['SCANDI_end_frame'])
print(data['ASC_start_frame'])
print(data['ASC_end_frame'])
print(round(len(data['windfit'])/10))

# creating a function that reads in two videos and outputs one video
def main(path1,path2):
    '''
    This function takes in the SCANDI video and the ASC video that were created using MATLAB. By setting the size, position
    fps and luminosity, the function outputs a single video that has the ASC and SCANDI videos overlayed at the correct frame
    timing. 
    Inputs :
            path1 - directory of SCANDI video ending in .mp4 (DO NOT INCLUDE SPEACH MARKS AROUND PATH) 
            path2 - directory of ASC video ending in .mp4 (DO NOT INCLUDE SPEACH MARKS AROUND PATH) 
    Outputs :
            Final combined video saved in the same directory as this file.   
    '''
    # importing video files
    wind = mpe.VideoFileClip(path1)
    skycam = mpe.VideoFileClip(path2)
   # sval = mpe.ImageClip("MapSvalb.jpg")

    # specifying settings 
    skycam = skycam.set_opacity(0.8)
    skycam = skycam.fx(vfx.lum_contrast, lum=3, contrast=1, contrast_thr=126)
    #skycam = skycam.set_position((-85,-68))
    skycam = skycam.set_position((-70,-63))
    #skycam = skycam.resize(0.36)
    skycam = skycam.resize(0.48)
    #skycam = skycam.resize(0.50)
    #wind = wind.set_position((-9,-13)) # changing position to fit centre to ASC azimuth
    wind = wind.set_position((16,-11))
    #sval = sval.set_opacity(0.15)
    #sval = sval.set_duration(wind.duration)
    #sval = sval.resize(0.30)

    # setting ASC fps
    skycam = skycam.set_fps(float(data['FPS']))
    
    # setting the right starting and end time for the overlaying ASC video
    if data['SCANDI_start_frame']>1 and data['SCANDI_end_frame'] < round(len(data['windfit'])/10):
        full_clip = mpe.CompositeVideoClip([wind,skycam.set_start(data['SCANDI_start_frame']/4)]) # 4fps = hard coded frame rate of scandi vid
    
    elif data['SCANDI_start_frame']==1 and data['SCANDI_end_frame'] == round(len(data['windfit'])/10):
        skycam = skycam.set_end(data['ASC_end_frame']/data['FPS'])
        full_clip = mpe.CompositeVideoClip([wind,skycam.set_start(data['ASC_start_frame']/data['FPS'])])
        #full_clip = mpe.CompositeVideoClip([wind,skycam])
    
    elif data['SCANDI_start_frame']==1 and data['SCANDI_end_frame'] < round(len(data['windfit'])/10):
        skycam = skycam.set_end(data['ASC_end_frame']/data['FPS'])
        full_clip = mpe.CompositeVideoClip([wind,skycam.set_start(data['SCANDI_start_frame']/4)])
    elif data['SCANDI_start_frame']>1 and data['SCANDI_end_frame'] == round(len(data['windfit'])/10):
        full_clip = mpe.CompositeVideoClip([wind,skycam.set_start(data['ASC_start_frame']/data['FPS'])])
    
    # writing the combined video into disk
    full_clip.write_videofile("fullTrial.mp4") # to save, change this into "filename.mp4"  

if __name__ == "__main__":

    # asking the user to choose the the directoy of the two SCANDI and ASC vids
    print("Please specify SCANDI video file path as .mp4 (DO NOT INCLUDE SPEACH MARKS AROUND PATH):")
    path1 = str(input())
    print("Please specify ASC video file path as .mp4 (DO NOT INCLUDE SPEACH MARKS AROUND PATH):")
    path2 = str(input())
    main(path1,path2)
    

