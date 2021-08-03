function [zon, mer] = rot_transf(theta,zonal,merid)
% Function rotates the wind field vectors towards the
% geomagnetic north direction. This corresponds to theta = 32.
% The output corresponds to transformed zonal and meridional wind arrays.
% The original vector directions are taken from the windfit data as the
% zonal and meridional wind speeds. Once these are transformed the output
% are given as zon and mer vectors. 

% Important !
% rot_transf.m file must stay saved in the same directory of the other functions,
% otherwise this script will not run correctly. Therefore it must stay 
% inside the directory named "...\FPI-winds".

    % matrix to rotate 32 counterclockwise
    M = [cosd(theta) -sind(theta); sind(theta) cosd(theta)]; 
    
    % initilising new arrays to store transformed vectors
    v2=[];
    zon = [];
    mer = [];
    
    % iterating over each position vector and transforming it using M
    for i=1:length(zonal)
       
        v2 = [zonal(i) merid(i)]';
        rotpoint2 = M*v2;
        zon(i) = rotpoint2(1);
        mer(i) = rotpoint2(2);
    end

    zon = zon';
    mer = mer'; 

end

