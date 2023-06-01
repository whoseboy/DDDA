clear
%% making original random data points

h1=0.1;

xLim_L=4.8283-15*h1;
xLim_H=18.4005+15*h1;
yLim_L=-12.4938-15*h1;
yLim_H= -2.5257+15*h1;



Num_x1=round((xLim_H-xLim_L)/h1);
Num_y1=round((yLim_H-yLim_L)/h1);
x=linspace(xLim_L,xLim_H,Num_x1);
y=linspace(yLim_L,yLim_H,Num_y1);
[X,Y]=meshgrid(x,y);


% Random sampling
xArray=X(:);
yArray=Y(:);
LLength=length(xArray);
PPoint1=0.92;                    % the percentage of the deleted points
P_deletes1=round(LLength*PPoint1);

PP1=sort(randperm(LLength,P_deletes1),'descend');

for i=1:P_deletes1
    
    j=PP1(i);
    xArray(j)=[];
    yArray(j)=[];
end
save xArray.mat xArray
save yArray.mat yArray




% determining the data boundary

xv1=[4.8283;18.4005;18.4005;4.8283];
yv1=[-12.4938;-12.4938;-2.5257;-2.5257];
in1=inpolygon(xArray,yArray,xv1,yv1);
xArray_in=xArray(in1);
yArray_in=yArray(in1);

DT = delaunayTriangulation(xArray_in,yArray_in);
C_b = convexHull(DT);
xv=DT.Points(C_b,1);
yv=DT.Points(C_b,2);

save xv.mat xv
save yv.mat yv


% otaining the formula value of the data point
X_smooth_min=8.1197;
X_smooth_max=8.1197;

f_turb=f_h(xArray,yArray);% Re>3000
f_lam=f_l(xArray,yArray);% Re<=3000

f=f_turb;

% smoothing the formula value of the point in the junction area of the
% formula
f(xArray<X_smooth_min)=f_lam(xArray<X_smooth_min);

X_smooth=(xArray>X_smooth_min) & (xArray<X_smooth_max);

coef_lam=(X_smooth_max-xArray(X_smooth))./(X_smooth_max-X_smooth_min);

f(X_smooth)=coef_lam.*f_lam(X_smooth)+(1-coef_lam).*f_turb(X_smooth);


fArray=f(:);
save fArray.mat fArray


% figure
figure()

plot(DT.Points(:,1),DT.Points(:,2),'b.','MarkerSize',10)
hold on
plot(DT.Points(C_b,1),DT.Points(C_b,2),'r','LineWidth',2) 
xlabel('log(Re)');
ylabel('log(Relative Roughness)');
title('Boundary of Initial Data');
