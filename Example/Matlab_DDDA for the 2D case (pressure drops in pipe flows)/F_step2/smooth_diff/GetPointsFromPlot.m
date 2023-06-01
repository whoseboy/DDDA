function [x,y]=GetPointsFromPlot(a,b,n,R0,LEnd,R20,L2End)

x=zeros(1,n);
y=zeros(1,n);

scatter(a,b,'.b');
xlim([R0,LEnd]);
ylim([R20,L2End]);
hold on

for i=1:n
xlim([R0,LEnd]);
ylim([R20,L2End]);
[x(i),y(i)]=ginput(1);
hold on
scatter(x,y,'.b');

end
