
function [ASC_start_frame,SCANDI_start_frame,SCANDI_end_frame,ASC_end_frame] = select_start_end(windfit,ASCPath)

% Function takes in the SCANDI windfit dataset and ASC pictures and
% calculates how many frames after to start the ASC video so that ASC and
% SCANDI video are correctly overlayed on top each other with their
% respective time stamps. The outputs of the function are end frame values and start
% frame values. Using these, the correct fps for the ASC vidoes can be
% found. 
% This function is required because the time stamps in the ASC pictures
% does not always equal to the time stamps of the SCANDI data. 

% Important !
% select_start_end.m file must stay saved in the same directory of the other functions,
% otherwise this script will not run correctly. Therefore it must stay 
% inside the directory named "...\FPI-winds".

    %%% Matching the starting time

    files = dir(ASCPath +"\*.jpg") ;
    t = duration(hours(windfit(1,1)),"Format","hh:mm");
    strrep(string(t),':','.');
    time = char(strrep(string(t),':','.'));
    chr = files(1).name;
    ASC = regexp(chr,'\d+\.\d+','match');
    if str2double(time) >= str2double(ASC)
        k = 1;
        while str2double(time) > str2double(regexp(files(k).name,'\d+\.\d+','match'))

            k = k + 1;
            %disp(str2double(regexp(files(k).name,'\d+\.\d+','match')));

        end
        ASC_start_frame = round(k);
        SCANDI_start_frame = 1;
    else
        n = 1;
        while str2double(char(strrep(string(duration(hours(windfit(n,1)),"Format","hh:mm")),':','.'))) < str2double(ASC)

            n = n + 10;
            %disp(str2double(char(strrep(string(duration(hours(windfit1(n,:).Var2),"Format","hh:mm")),':','.'))));

        end
        SCANDI_start_frame = round(n/10);
        ASC_start_frame = 1;
    end
    
    
    %%% Matching the end time 
    if windfit(end-9,1) > 24
        t = duration(hours(windfit(end-9,1) - 24),"Format","hh:mm");
    else 
        t = duration(hours(windfit(end-9,1)),"Format","hh:mm");
    end
        strrep(string(t),':','.');
        time = char(strrep(string(t),':','.'));
        chr = files(end).name;
        ASC = regexp(chr,'\d+\.\d+','match');
    if str2double(time) >= str2double(ASC)

        for n = 1:10:height(windfit)

            if n+3 > height(windfit)
                break
            end

            if str2double(char(strrep(string(duration(hours(windfit(n,1)),"Format","hh:mm")),':','.'))) < 24
                if str2double(char(strrep(string(duration(hours(windfit(n,1)),"Format","hh:mm")),':','.'))) < (str2double(ASC))
                    break
                end

            elseif str2double(char(strrep(string(duration(hours(windfit(n,1)),"Format","hh:mm")),':','.'))) > 24
                if str2double(char(strrep(string(duration(hours(windfit(n,1)),"Format","hh:mm")),':','.'))) > (str2double(ASC) + 24)
                    break
                end
            end 
               % disp(str2double(char(strrep(string(duration(hours(windfit1(n,:).Var2),"Format","hh:mm")),':','.'))));
        end
        SCANDI_end_frame = round(n/10);
        ASC_end_frame = length(files);
        
    else   

        for k = 1:length(files)    
            
            %%%%%%%%% this needs changing %%%%%%%
            if (str2double(time)) < 24 && str2double(time) > 12.0
                if  (str2double(regexp(files(k).name,'\d+\.\d+','match'))) > str2double(time)
                    break
                end

            elseif (str2double(time)+24) > 24
                % if  (str2double(regexp(files(k).name,'\d+\.\d+','match'))) > (str2double(time) + 24) 
                if  (str2double(regexp(files(k).name,'\d+\.\d+','match'))) <= 23.59 && (str2double(regexp(files(k).name,'\d+\.\d+','match'))) >= (str2double(regexp(files(1).name,'\d+\.\d+','match'))) 
                    continue
                    %%if %%%%%%%%%%%%
                
                elseif  (str2double(regexp(files(k).name,'\d+\.\d+','match'))) >= (str2double(time))
                    break
                end          
            end 
           % disp(str2double(char(strrep(string(duration(hours(windfit1(n,:).Var2),"Format","hh:mm")),':','.'))));
        end
        
        ASC_end_frame = round(k);
        SCANDI_end_frame = round(height(windfit)/10);

    end




end

