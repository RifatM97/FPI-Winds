function [h] = Scandi_zones(C,r)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating SCANDI zones 

figure;
th = linspace(0,2*pi) ;   % angles 

% Creating the circles
for i = 1:length(r)
    % parametric equation of circles
    x = C(1)+r(i)*cos(th) ;
    y = C(2)+r(i)*sin(th) ;
    plot(x,y,'r') ;
    hold on    
end
axis equal


th1 = deg2rad([60, 120,180,240,300,0]);
t = linspace(0,1) ;                     
% Draw lines in second circle (6 sectors)
for i = 1:length(th1)
    x0 = C(1)+r(1)*cos(th1(i)) ; y0 = C(2) +  r(1)*sin(th1(i)) ;
    x2 = C(1)+ r(2)*cos(th1(i)) ; y2 = C(2) + r(2)*sin(th1(i)) ; 
    x = x0+t*(x2-x0) ;y = y0+t*(y2-y0) ;
    plot(x,y,'b');
    hold on
end

th1 = deg2rad([60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,0,20,40,60]);
t = linspace(0,1) ;  

% Draw lines in the outer circles (18 sectors)
for i = 1:length(th1)
    x2 = C(1)+ r(2)*cos(th1(i)) ; y2 =C(2)+ r(2)*sin(th1(i)) ;
    x1 = C(1)+ r(end)*cos(th1(i)) ; y1 = C(2)+ r(end)*sin(th1(i)) ;
    x = x2+t*(x1-x2) ;y = y2+t*(y1-y2) ;
    plot(x,y,'b');
end
hold off
axis on
end

