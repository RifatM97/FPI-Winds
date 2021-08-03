function [h] = circle(x, y, r, N)
% Function creates equation of a circle and plots on cartesian coordinates
% Inputs: x ,y are the centre coordinates, r is the radius of the circle
% and theta is the angle 

% th = 0:pi/50:2*pi;
% xunit = r * cos(th) + x;
% yunit = r * sin(th) + y;
% h = plot(xunit, yunit);

                                                        % Number Of Segments
% a = linspace(0, 2*pi, N*10);
% xunits = r*cos(a) + x;
% yunits = r*sin(a) + y;
% figure(1)
% if N > 1
%     h = plot(xunits, yunits, 'Color', 'r', 'LineWidth', 3);
%     fill(xunits,yunits, "w");
%     hold on
%     plot([zeros(1,N); xunits(1:10:end)], [zeros(1,N); yunits(1:10:end)],'color', 'r');
%     hold off
%     axis equal
% elseif N == 0
%     h = plot(xunits, yunits, 'Color', 'r', 'LineWidth', 3);
%     fill(xunits,yunits, "w");
% end

if N > 1
    a = linspace(0, 2*pi, N*10);
    xunits = r*cos(a) + x;
    yunits = r*sin(a) + y;
    figure(1)
    h = plot(xunits, yunits, 'Color', 'r', 'LineWidth', 4);
    fill(xunits,yunits, "w");
    hold on
    plot([repmat(x,1,N); xunits(1:10:end)], [repmat(y,1,N); yunits(1:10:end)],'color', 'r');
    hold off
    axis equal
elseif N == 0
    a = linspace(0, 2*pi, 100);
    xunits = r*cos(a) + x;
    yunits = r*sin(a) + y;
    h = plot(xunits, yunits, 'Color', 'r', 'LineWidth', 3);
    fill(xunits,yunits, "w","FaceAlpha","0.05");
%     p = projcrs('UTM39SW84','Authority','IGNF')
%     [lat,lon] = projinv(p, xunits, yunits)
%     h = geoplot(lat,lon)
end


