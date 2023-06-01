function [f,pFpX,pFpY]=smooth(xArray,yArray,noise,x_dep,y_dep)

N_dep=length(x_dep);

[V,C,XY]=VoronoiLimit(xArray,yArray);
%Jakob Sievers (2022). VoronoiLimit(varargin) (https://www.mathworks.com/matlabcentral/fileexchange/34428-voronoilimit-varargin), MATLAB Central File Exchange. Retrieved February 15, 2022
% voronoi(xArray,yArray);
% hold on
% scatter(V(:,1),V(:,2));
% hold on

C_region=length(C);
C_Area=zeros(C_region,1);
C_Vertex=cell(C_region,1);

%提取每个多边形的顶点到每个单元格
for i=1:C_region
    
    C_Vertex{i}=V(C{i},:);
    
end

%计算面积/体积
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%选择想知道的数据点
%任意选择
% [x_Quiry,y_Quiry]=GetPointsFromPlot(xArray,yArray,n_Quiry,4,20,-11,-2);
% n_Quiry=8;
% 全局选择
x_Quiry=x_dep;
y_Quiry=y_dep;
n_Quiry=length(x_dep);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%核函数光滑计算【归一化返回值，点间距，x方向偏导，y方向偏导】
[W_Gauij,W_Gauij_var,rij]=GauQuiry2D(xArray,yArray,x_Quiry,y_Quiry,h0,h1,hn,C_Area(:),fArray);
figure()
for i=1:n_Quiry
       
    xh=linspace(h0,h1,hn);
    plot(xh,W_Gauij(i,:));
    hold on
    xlabel('Smooth length(h)');
    
end
title('核函数归一性随h变化的曲线')

figure()
scatter(x_Quiry,y_Quiry,'.');
xlim([4,20]);
ylim([-11,-2]);
hold on

h_Quiry=zeros(1,hn);
W_STD=zeros(1,n_Quiry);
h_r1=zeros(1,n_Quiry);
w_Gau_std=zeros(1,n_Quiry);
w_Gau_var=zeros(1,n_Quiry);
for i=1:n_Quiry
    
    for j=1:hn
    h_Quiry(j)=abs(W_Gauij(i,j)-1);
    [hQT,W_STD(i)]=min(h_Quiry);

    
    [qq,h_r]=min(abs(h_Quiry-hQT));
    end
    
    w_Gau_std(i)=W_Gauij(i,W_STD(i));
    w_Gau_var(i)=W_Gauij_var(i,W_STD(i));
    h_r=h_r*hdn+h0;
    h_r1(i)=h_r;
    [xunit,yunit]=DrawCircle(x_Quiry(i),y_Quiry(i),h_r);
    plot(xunit,yunit);
    hold on
    
end

ppp=cell(n_Quiry,1);
for i=1:n_Quiry
    
    j=1;
    [rn]=findPointsInH(rij(i,:),h_r1(i));
    ppp{i}=rn;
    
end


% for i=1:n_Quiry
%     
%  scatter(XY(ppp{i},1),XY(ppp{i},2),'.');   
%  hold on
% 
% end
% title('每个问题点中支持域中的的点');
% hold on
% voronoi(xArray,yArray);
% axis equal

% t=linspace(0,2*pi);
% bs_ext=[(cos(t)*h_r)+x_dep;(sin(t)*h_r)+y_dep]';
% [Vv,Cc,XYxy]=VoronoiLimit(xArray,yArray,'bs_ext',bs_ext);
% axis equal
% hold on
% scatter(XYxy(:,1),XYxy(:,2));
% hold on
% scatter(Vv(:,1),Vv(:,2));
% 
% lllll=length(XYxy(:,2));
% lll=zeros(lllll,1);
% f_kkp=zeros(lllll,1);
% 
% for i=1:length(XYxy(:,2))
%  
%     p=find(XYxy(i,2)==yArray);
%     q=find(XYxy(i,1)==xArray);
%     lll(i)=intersect(p,q);
%     f_kkp(i)=fArray(lll(i));  
%  
% end


[W_Gau_fixH,W_Gau_fixH1,rij_fixH,D1_Gauij_x_fixH,D1_Gauij_y_fixH]=GauQuiry2DFixedh(xArray,yArray,x_Quiry,y_Quiry,h_r1,C_Area(:),fArray);

% C_region_kkp=length(Cc);
% C_Area_kkp=zeros(C_region_kkp,1);
% C_Vertex_kkp=cell(C_region_kkp,1);
% 
% %提取每个多边形的顶点到每个单元格
% for i=1:C_region_kkp
%     
%     C_Vertex_kkp{i}=Vv(Cc{i},:);
%     
% end
% 
% %计算面积/体积
% for i=1:C_region_kkp
%     
%     Temp_L_kkp=size(Cc{i},1);
%     for j=1:Temp_L_kkp
%         
%         k=j+1;
%         C_Area_kkp(i)=C_Area_kkp(i)+C_Vertex_kkp{i}(j,1)*C_Vertex_kkp{i}(k,2)-C_Vertex_kkp{i}(k,1)*C_Vertex_kkp{i}(j,2);
%     
%         if j==Temp_L_kkp-1
%            
%             k=1;
%             C_Area_kkp(i)=C_Area_kkp(i)+C_Vertex_kkp{i}(Temp_L_kkp,1)*C_Vertex_kkp{i}(k,2)-C_Vertex_kkp{i}(k,1)*C_Vertex_kkp{i}(Temp_L_kkp,2);
%             break;
%             
%         end
%     end
% end
% Temp_L_kkp=0;
% C_Area_kkp=C_Area_kkp./2;
% 
% 
% [W_kkp,W_kkp1,rij_kkp,D1_x_kkp,D1_y_kkp]=GauQuiry2DFixedh(XYxy(:,1),XYxy(:,2),x_Quiry,y_Quiry,h_r1,C_Area_kkp,f_kkp);

figure()
plot3(x_dep,y_dep,h_r1','.');
title('h收敛后的数值');

figure()
plot3(x_dep,y_dep,w_Gau_std','.');
title('核函数归一化数值');

figure()
plot3(x_dep,y_dep,W_Gau_fixH1,'.');
title('加入因变量后的最佳h数值');