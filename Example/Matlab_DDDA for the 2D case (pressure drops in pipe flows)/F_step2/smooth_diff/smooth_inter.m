function [x,y,f,pFpX,pFpY,norm_v]=smooth_inter(xArray,yArray,fArray,noise,x_dep,y_dep,in_in)

%% adding nosie
x_dep=x_dep(in_in);
y_dep=y_dep(in_in);

a=0.05*randn(length(fArray),1);

fArray=fArray.*(1+ noise.*a);

% N_dep=length(x_dep);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% h interval
hn=300;                  % steps
h1=7;                    % h max
h0=0.6;                  % h min
hdn=(h1-h0)/hn;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% calculating Voronoi cell

[V,C,XY]=VoronoiLimit(xArray,yArray);
%Jakob Sievers (2022). VoronoiLimit(varargin) (https://www.mathworks.com/matlabcentral/fileexchange/34428-voronoilimit-varargin), MATLAB Central File Exchange. Retrieved February 15, 2022
% voronoi(xArray,yArray);
% hold on
% scatter(V(:,1),V(:,2));
% hold on

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_Quiry=x_dep;
y_Quiry=y_dep;
n_Quiry=length(x_dep);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% calculating smooth interpolation

[W_Gauij,W_Gauij_var,rij]=GauQuiry2D(xArray,yArray,x_Quiry,y_Quiry,h0,h1,hn,C_Area(:),fArray);
figure()
for i=1:n_Quiry
       
    xh=linspace(h0,h1,hn);
    plot(xh,W_Gauij(i,:));
    hold on
    xlabel('Smooth length(h)');
    
end
title('kernel function normalization')

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


%% smooth differential calculation

[W_Gau_fixH,W_Gau_fixH1,rij_fixH,D1_Gauij_x_fixH,D1_Gauij_y_fixH]=GauQuiry2DFixedh(xArray,yArray,x_Quiry,y_Quiry,h_r1,C_Area(:),fArray);



norm_v=w_Gau_std';

f=W_Gau_fixH1((norm_v>0.98&norm_v<1.02));

x=x_dep((norm_v>0.98&norm_v<1.02));
y=y_dep((norm_v>0.98&norm_v<1.02));

pFpX=D1_Gauij_x_fixH((norm_v>0.98&norm_v<1.02));
pFpY=D1_Gauij_y_fixH((norm_v>0.98&norm_v<1.02));
end








