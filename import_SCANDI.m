function [windfit,posz,posm] = import_SCANDI(textfile)
% This function imports SCANDI data from raw textfiles using MATLAB inbuilt
% function "readTable". Zonal, meridional wind position and speed are
% extracted. These are then transformed to reflect geomagnetic north
% position. The argument of this function is the path of the SCANDI
% dataset. The outputs are the complete windfit data set, and the
% transformed position vectors.

% Important !
% import_SCANDI.m file must stay saved in the same directory of the other functions,
% otherwise this script will not run correctly. Therefore it must stay 
% inside the directory named "...\FPI-winds".
    
    % Determining naming convention to figure out size of data
    [filepath, name] = fileparts(textfile);
    resol = cell2mat(textscan(name, "%*c%c%*s")); %SCANDI resolution
    
    if contains(resol,'N')
        % importing data and extracting position and velocity of neutral winds    
        fid = fopen(textfile);
        N = repmat('%f',1,61);
        windfit = textscan(fid,N, "headerlines", 2);
        fclose(fid);
        windfit = cell2mat(windfit);
        dz = windfit(8,1:end)';
        dm = windfit(9,1:end)';
        
    elseif contains(resol,'H')
        
        fid = fopen(textfile);
        N = repmat('%f',1,91);
        windfit = textscan(fid,N, "headerlines", 2);
        fclose(fid);
        windfit = cell2mat(windfit);
        dz = windfit(8,1:end)';
        dm = windfit(9,1:end)';
        
    elseif contains(resol,'M')
        
        fid = fopen(textfile);
        N = repmat('%f',1,51);
        windfit = textscan(fid,N, "headerlines", 2);
        fclose(fid);
        windfit = cell2mat(windfit);
        dz = windfit(8,1:end)';
        dm = windfit(9,1:end)';   
    
    elseif contains(resol,'L')
        
        fid = fopen(textfile);
        N = repmat('%f',1,25);
        windfit = textscan(fid,N, "headerlines", 2);
        fclose(fid);
        windfit = cell2mat(windfit);
        dz = windfit(8,1:end)';
        dm = windfit(9,1:end)';
    end
    
    % Checking whether it is geographic or magnetic north through naming
    % convention
    north = cell2mat(textscan(name, "%*2c%c%*s"))
    if contains(north,"M") == 1
        
        % transforming position vectors for geomagnetic north allignment
        % initilising new arrays to store transformed vectors
        posz=[];
        posm=[];
        v1=[];

        % matrix to rotate 32 counterclockwise
        theta=32; %%% CHANGE THIS TO 0 DEG TO KEEP ZONES GEO NORTH %%%
        M = [cosd(theta) -sind(theta); sind(theta) cosd(theta)]; 

        % iterating over each position vector and transforming it using M
        for i=1:length(dm)
            v1 = [dz(i) dm(i)]';
            rotpoint1 = M*v1;
            posz(i) = rotpoint1(1);
            posm(i) = rotpoint1(2);
        end

        % printing final trasnformed arrays
        posz = posz';
        posm = posm';
        
    end
   
end

