clear
clc

n=5;
n_Quiry=5;
D1L=0;
D1R=10;
D2L=0;
D2R=10;
h0=0.2;
hn=800;
h1=4;
hdn=(h1-h0)/hn;

a=10*rand(1,500);
b=10*rand(1,500);
[x,y]=GetPointsFromPlot(a,b,n,D1L,D1R);
x=[x,a];
y=[y,b];




[V,C,XY]=VoronoiLimit(x,y);
%Jakob Sievers (2022). VoronoiLimit(varargin) (https://www.mathworks.com/matlabcentral/fileexchange/34428-voronoilimit-varargin), MATLAB Central File Exchange. Retrieved February 15, 2022
voronoi(x,y);
hold on
scatter(V(:,1),V(:,2));
hold on

C_region=length(C);
C_Area=zeros(C_region,1);
C_Vertex=cell(C_region,1);


for i=1:C_region
    
    C_Vertex{i}=V(C{i},:);
    
end

for i=1:C_region
    
    Temp_L=size(C{i},1);
    
    for j=1:Temp_L
        
        k=j+1;
        C_Area(i)=C_Area(i)+C_Vertex{i}(j,1)*C_Vertex{i}(k,2)-C_Vertex{i}(k,1)*C_Vertex{i}(j,2);
    
        if j==Temp_L-1
           
            k=1;
            C_Area(i)=C_Area(i)+C_Vertex{i}(Temp_L,1)*C_Vertex{i}(k,2)-C_Vertex{i}(k,1)*C_Vertex{i}(Temp_L,2);
            break;
            
        end
        
    end
end
    Temp_L=0;
C_Area=C_Area./2;

[x_Quiry,y_Quiry]=GetPointsFromPlot(x,y,n_Quiry,D1L,D1R);

% text(XY(:,1),XY(:,2),num2str(C_Area(:),'%4.2f'));
[W_Gauij,rij]=GauQuiry2D(XY(:,1),XY(:,2),x_Quiry,y_Quiry,h0,h1,hn,C_Area(:));



figure()
for i=1:n_Quiry
       
    xh=linspace(h0,h1,hn);
    plot(xh,W_Gauij(i,:));
    hold on
    xlabel('Smooth length(h)');
    
end
title('核函数归一性随h变化的曲线')
legend('1','2','3','4','5');

figure()
scatter(x_Quiry,y_Quiry,'.');
xlim([0,10]);
ylim([0,10]);
hold on

h_Quiry=zeros(1,hn);
h_r1=zeros(1,n_Quiry);
for i=1:n_Quiry
    
    for j=1:hn
    h_Quiry(j)=sqrt((W_Gauij(i,j)-1).^2);
    hQT=min(h_Quiry);
    h_r=find(h_Quiry== hQT)*hdn;
    end
    h_r1(i)=h_r;
    [xunit,yunit]=DrawCircle(x_Quiry(i),y_Quiry(i),h_r);
    plot(xunit,yunit);
    hold on
    
end
legend('1','2','3','4','5');
ppp=cell(n_Quiry,1);
for i=1:n_Quiry
    
    j=1;
    [rn]=findPointsInH(rij(i,:),h_r1(i));
    ppp{i}=rn;
    
end


for i=1:n_Quiry
    
scatter(XY(ppp{i},1),XY(ppp{i},2),'.');
hold on

end
title('每个问题点中支持域中的的点');
