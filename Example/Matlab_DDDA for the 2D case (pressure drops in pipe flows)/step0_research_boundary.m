clear 
% the merging papameter space of the 'pressure drops in the pipe flows' case

%liminar 
x1_l=log(125);
x1_h=log(3360);
y1_l=log(3.75e-6);
y1_h=log(1.6e-4);
x1=linspace(x1_l,x1_h,10);
y1=linspace(y1_l,y1_h,10);
[X1,Y1]=meshgrid(x1,y1);
%middle
x2_l=log(1e+4);
x2_h=log(5.6e+5);
y2_l=log(5e-4);
y2_h=log(4e-3);
x2=linspace(x2_l,x2_h,10);
y2=linspace(y2_l,y2_h,10);
[X2,Y2]=meshgrid(x2,y2);
%turbulent
x3_l=log(2.5e+6);
x3_h=log(9.8e+7);
y3_l=log(0.01);
y3_h=log(0.08);
x3=linspace(x3_l,x3_h,10);
y3=linspace(y3_l,y3_h,10);
[X3,Y3]=meshgrid(x3,y3);

%total
x1=4.8283;
x2=18.4005;
y1=-12.4938;
y2=-2.5257;