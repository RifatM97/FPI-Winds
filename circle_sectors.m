function [outy,outx] = circle_sectors(lat,lon,N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Putting together the two arrays to form one array that plots sectors
% across the circles.

    lat1 = circshift(lat,76)
    lon1 = circshift(lon,76);

    t1 = repmat(78.1,N,1)'
    ty = (lat1(1:10:end))'

    out0 = [ty(rem(0:numel(t1)-1,numel(ty))+1);t1];
    outy = out0(:)'

    t2 = repmat(16.0,N,1)'
    tx = (lon1(1:10:end))'

    out0 = [tx(rem(0:numel(t2)-1,numel(tx))+1);t2];
    outx = out0(:)'
end

