function [h] = circle(x, y, r)
% Function creates equation of a circle and plots on cartesian coordinates

th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit);

end

