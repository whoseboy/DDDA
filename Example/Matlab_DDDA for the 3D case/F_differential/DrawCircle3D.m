function [xunit,yunit,zunit] = DrawCircle3D(x,y,z,r)

th = 0:pi/50:2*pi;

xunit(1,:) = r * cos(th) + x;
yunit(1,:) = r * sin(th) + y;
zunit(1,:) = r * cos(th) + z;

xunit(2,:) = r * cos(th) + x;
yunit(2,:) = r * sin(th) + y;
zunit(2,:) = r * -cos(th) + z;


xunit(3,:) = r * -cos(th) + x;
yunit(3,:) = r * -sin(th) + y;
zunit(3,:) = 0 * cos(th) + z;