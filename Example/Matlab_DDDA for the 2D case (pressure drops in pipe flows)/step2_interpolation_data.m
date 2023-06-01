clear 
%% setting interpolation points and obtaining the corresponding formula values

% setting interpolation points
xLim_L=4.8283;
xLim_H=18.4005;
yLim_L=-12.4938;
yLim_H= -2.5257;

h1=0.3;

Num_x1=round((xLim_H-xLim_L)/h1);
Num_y1=round((yLim_H-yLim_L)/h1);
x=linspace(xLim_L,xLim_H,Num_x1);
y=linspace(yLim_L,yLim_H,Num_y1);

[X,Y]=meshgrid(x,y);

x_dep=X(:);
y_dep=Y(:);

load xv.mat
load yv.mat

xq=x_dep;
yq=y_dep;
in_in = inpolygon(xq,yq,xv,yv);



save x_dep.mat x_dep
save y_dep.mat y_dep
save in_in.mat in_in

% obtaining the corresponding formula values
X_smooth_min=8.1197;
X_smooth_max=8.1197;

f_turb=f_h(x_dep,y_dep);
f_lam=f_l(x_dep,x_dep);

f=f_turb;

f(x_dep<X_smooth_min)=f_lam(x_dep<X_smooth_min);

X_smooth=(x_dep>X_smooth_min) & (x_dep<X_smooth_max);

coef_lam=(X_smooth_max-x_dep(X_smooth))./(X_smooth_max-X_smooth_min);

f(X_smooth)=coef_lam.*f_lam(X_smooth)+(1-coef_lam).*f_turb(X_smooth);

f_dep=f(:);
save f_dep.mat f_dep



% figure
figure()
scatter3(x_dep,y_dep,f,'.')


figure()
plot(xv,yv,'r','LineWidth',2) % polygon
axis equal
hold on
plot(xq(in_in),yq(in_in),'b.','MarkerSize',10) % points inside
% plot(xq(~in),yq(~in),'bo') % points outside
xlabel('log(Re)');
ylabel('log(Relative Roughness)');
title('Axis of Initial Interpolation Points');
hold off