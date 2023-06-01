clear
clc
%% setting a cube parameters space

Lim.x0 = 0;    Lim.x1 = 3;
Lim.y0 = 0;    Lim.y1 = 3;
Lim.z0 = -1.5;    Lim.z1 = 1.5;

num = 15;                             
n_Quiry = num^3;                      % 3D DATA

dxArray = (Lim.x1-Lim.x0)/num;         
dyArray = (Lim.y1-Lim.y0)/num;
dzArray = (Lim.z1-Lim.z0)/num;

xfp = linspace(Lim.x0,Lim.x1,num);    
yfp = linspace(Lim.y0,Lim.y1,num);
zfp = linspace(Lim.z0,Lim.z1,num);

Arrayx = zeros(n_Quiry,1);
Arrayy = zeros(n_Quiry,1);
Arrayz = zeros(n_Quiry,1);
Arrayf = zeros(n_Quiry,1);

for i = 1:num
   for j = 1:num
       for k = 1:num
           
                Arrayx((i-1)*num*num+(j-1)*num+k) = xfp(k);   
                Arrayy((i-1)*num*num+(j-1)*num+k) = yfp(j);    
                Arrayz((i-1)*num*num+(j-1)*num+k) = zfp(i);    
                
                if Arrayz((i-1)*num*num+(j-1)*num+k) <= 0      
                    
                    Arrayf((i-1)*num*num+(j-1)*num+k) = f1(Arrayx((i-1)*num*num+(j-1)*num+k),Arrayy((i-1)*num*num+(j-1)*num+k),Arrayz((i-1)*num*num+(j-1)*num+k));
                
                elseif Arrayz((i-1)*num*num+(j-1)*num+k) > 0
                        
                    Arrayf((i-1)*num*num+(j-1)*num+k) = f2(Arrayx((i-1)*num*num+(j-1)*num+k),Arrayy((i-1)*num*num+(j-1)*num+k),Arrayz((i-1)*num*num+(j-1)*num+k));
                        
                end
       end
   end
end

%figure()
%scatter3(Arrayx,Arrayy,Arrayz,'.');

%axis equal

%% adding noise


for i = 1:num
   for j = 1:num
       for k = 1:num
           
                Exyz = rand(1)*0.05; 
                Arrayx((i-1)*num*num+(j-1)*num+k) = Arrayx((i-1)*num*num+(j-1)*num+k) + ((-1)^round(Exyz))*Exyz*Arrayx((i-1)*num*num+(j-1)*num+k);
                Arrayy((i-1)*num*num+(j-1)*num+k) = Arrayy((i-1)*num*num+(j-1)*num+k) + ((-1)^round(Exyz))*Exyz*Arrayy((i-1)*num*num+(j-1)*num+k);
                Arrayz((i-1)*num*num+(j-1)*num+k) = Arrayz((i-1)*num*num+(j-1)*num+k) + ((-1)^round(Exyz))*Exyz*Arrayz((i-1)*num*num+(j-1)*num+k);
                
       end
   end
end
Arrayf_color = Arrayf;

% figure()
% scatter3(Arrayx,Arrayy,Arrayz,'.');
% 
% axis equal
% 
% figure()
% scatter3(Arrayx,Arrayy,Arrayz,80,Arrayf_color,'.');
% 
% axis equal



Arrayf_Pert = Arrayf;
for i = 1:num
   for j = 1:num
       for k = 1:num
           
                Exyz = rand(1)*0.05; 
                Arrayf_Pert((i-1)*num*num+(j-1)*num+k) = Arrayf_Pert((i-1)*num*num+(j-1)*num+k) + ((-1)^round(Exyz))*Exyz*Arrayf_Pert((i-1)*num*num+(j-1)*num+k);
                
       end
   end
end
Arrayf_Pert_color = Arrayf_Pert;

% figure()
% scatter3(Arrayx,Arrayy,Arrayz,80,Arrayf_Pert_color,'.');
% 
% axis equal

save ox.mat Arrayx;
save oy.mat Arrayy;
save oz.mat Arrayz;
save of.mat Arrayf_Pert_color;

%% Voronoi_limit cell

% Mirroring of boundaries

reflectB = zeros(num*6,1);
xmin = zeros(num*num,1);
ymin = zeros(num*num,1);
zmin = zeros(num*num,1);
xmax = zeros(num*num,1);
ymax = zeros(num*num,1);
zmax = zeros(num*num,1);

ArrayyJ = Arrayy;
ArrayzJ = Arrayz;
xmaxB = cell(100,1);
xminB = cell(100,1);
ymaxB = cell(100,1);
yminB = cell(100,1);
zmaxB = cell(100,1);  
zminB = cell(100,1);


% xMin
ArrayxJ_xMin = Arrayx;
ArrayxB_xMin = Arrayx;
ArrayyB_xMin = Arrayy;
ArrayzB_xMin = Arrayz;

for i = 1:num*num

    [rBxl,rBxil] = min(ArrayxJ_xMin);           
    xmin(i) = rBxil;                          
    ArrayxJ_xMin(rBxil) = (Lim.x1-Lim.x0)/2;    
    xminB{i} =  [-1*ArrayxB_xMin(xmin(i))-dxArray+ArrayxB_xMin(xmin(i)),ArrayyB_xMin(xmin(i)),ArrayzB_xMin(xmin(i))];
   
    ArrayxB_xMin = [ArrayxB_xMin;xminB{i}(1)];  
    ArrayyB_xMin = [ArrayyB_xMin;xminB{i}(2)];
    ArrayzB_xMin = [ArrayzB_xMin;xminB{i}(3)];
    Arrayf = [Arrayf;0];
    
end

% yMin
ArrayyJ_yMin = ArrayyB_xMin;
ArrayxB_yMin = ArrayxB_xMin;
ArrayyB_yMin = ArrayyB_xMin;
ArrayzB_yMin = ArrayzB_xMin;

for i = 1:num*num+10

    [rByl,rByil] = min(ArrayyJ_yMin);
    ymin(i) = rByil;
    ArrayyJ_yMin(rByil) = (Lim.y1-Lim.y0)/2;
    yminB{i} =  [ArrayxB_yMin(ymin(i)),-1*ArrayyB_yMin(ymin(i))-dyArray+ArrayyB_yMin(ymin(i)),ArrayzB_yMin(ymin(i))];
    ArrayxB_yMin = [ArrayxB_yMin;yminB{i}(1)];
    ArrayyB_yMin = [ArrayyB_yMin;yminB{i}(2)];
    ArrayzB_yMin = [ArrayzB_yMin;yminB{i}(3)];
    Arrayf = [Arrayf;0];
    
end

% xMax
ArrayxJ_xMax = ArrayxB_yMin;
ArrayxB_xMax = ArrayxB_yMin;
ArrayyB_xMax = ArrayyB_yMin;
ArrayzB_xMax = ArrayzB_yMin;

for i = 1:num*num+20

    [rBxr,rBxir] = max(ArrayxJ_xMax);
    xmax(i) = rBxir;
    ArrayxJ_xMax(rBxir) = (Lim.x1-Lim.x0)/2;
    xmaxB{i} =  [-1*ArrayxB_xMax(xmax(i))+ArrayxB_xMax(xmax(i))*2+dxArray,ArrayyB_xMax(xmax(i)),ArrayzB_xMax(xmax(i))];
    ArrayxB_xMax = [ArrayxB_xMax;xmaxB{i}(1)];
    ArrayyB_xMax = [ArrayyB_xMax;xmaxB{i}(2)];
    ArrayzB_xMax = [ArrayzB_xMax;xmaxB{i}(3)];
    Arrayf = [Arrayf;0];
    
end

% yMax
ArrayyJ_yMax = ArrayyB_xMax;
ArrayxB_yMax = ArrayxB_xMax;
ArrayyB_yMax = ArrayyB_xMax;
ArrayzB_yMax = ArrayzB_xMax;

for i = 1:num*num+40

    [rByr,rByir] = max(ArrayyJ_yMax);
    ymax(i) = rByir;
    ArrayyJ_yMax(rByir) = (Lim.y1-Lim.y0)/2;
    ymaxB{i} =  [ArrayxB_yMax(ymax(i)),-1*ArrayyB_yMax(ymax(i))+dyArray+ArrayyB_yMax(ymax(i))*2,ArrayzB_yMax(ymax(i))];
    ArrayxB_yMax = [ArrayxB_yMax;ymaxB{i}(1)];
    ArrayyB_yMax = [ArrayyB_yMax;ymaxB{i}(2)];
    ArrayzB_yMax = [ArrayzB_yMax;ymaxB{i}(3)];
    Arrayf = [Arrayf;0];
    
end

% zMax
ArrayzJ_zMax = ArrayzB_yMax;
ArrayxB_zMax = ArrayxB_yMax;
ArrayyB_zMax = ArrayyB_yMax;
ArrayzB_zMax = ArrayzB_yMax;

for i = 1:num*num+44

    [rBzr,rBzir] = max(ArrayzJ_zMax);
    zmax(i) = rBzir;
    ArrayzJ_zMax(rBzir) = 0;
    zmaxB{i} =  [ArrayxB_zMax(zmax(i)),ArrayyB_zMax(zmax(i)),-1*ArrayzB_zMax(zmax(i))+dzArray+ArrayzB_zMax(zmax(i))*2];
    ArrayxB_zMax = [ArrayxB_zMax;zmaxB{i}(1)];
    ArrayyB_zMax = [ArrayyB_zMax;zmaxB{i}(2)];
    ArrayzB_zMax = [ArrayzB_zMax;zmaxB{i}(3)];
    Arrayf = [Arrayf;0];
    
end

% zMin
ArrayzJ_zMin = ArrayzB_zMax;
ArrayxB_zMin = ArrayxB_zMax;
ArrayyB_zMin = ArrayyB_zMax;
ArrayzB_zMin = ArrayzB_zMax;

for i = 1:num*num+44

    [rBzl,rBzil] = min(ArrayzJ_zMin);
    zmin(i) = rBzil;
    ArrayzJ_zMin(rBzil) = 0;
    zminB{i} =  [ArrayxB_zMin(zmin(i)),ArrayyB_zMin(zmin(i)),-1*ArrayzB_zMin(zmin(i))-dzArray+ArrayzB_zMin(zmin(i))*2];
    ArrayxB_zMin = [ArrayxB_zMin;zminB{i}(1)];
    ArrayyB_zMin = [ArrayyB_zMin;zminB{i}(2)];
    ArrayzB_zMin = [ArrayzB_zMin;zminB{i}(3)];
    Arrayf = [Arrayf;0];
    
end


figure()
plot3(Arrayx,Arrayy,Arrayz,'.')
hold on
plot3(Arrayx(xmin),Arrayy(xmin),Arrayz((xmin)),'.r');
hold on
for i = 1:num*num
plot3(xminB{i}(1),xminB{i}(2),xminB{i}(3),'.g');
end

hold on
plot3(ArrayxB_yMin(ymin),ArrayyB_yMin(ymin),ArrayzB_yMin((ymin)),'.r');
hold on
for i = 1:num*num+10
plot3(yminB{i}(1),yminB{i}(2),yminB{i}(3),'.g');
end

hold on
plot3(ArrayxB_xMax(xmax),ArrayyB_xMax(xmax),ArrayzB_xMax((xmax)),'.r');
hold on
for i = 1:num*num+20
plot3(xmaxB{i}(1),xmaxB{i}(2),xmaxB{i}(3),'.g');
end

hold on
plot3(ArrayxB_yMax(ymax),ArrayyB_yMax(ymax),ArrayzB_yMax((ymax)),'.r');
hold on
for i = 1:num*num+40
plot3(ymaxB{i}(1),ymaxB{i}(2),ymaxB{i}(3),'.g');
end

hold on
plot3(ArrayxB_zMax(zmax),ArrayyB_zMax(zmax),ArrayzB_zMax((zmax)),'.r');
hold on
for i = 1:num*num+44
plot3(zmaxB{i}(1),zmaxB{i}(2),zmaxB{i}(3),'.g');
end

hold on
plot3(ArrayxB_zMin(zmin),ArrayyB_zMin(zmin),ArrayzB_zMin((zmin)),'.r');
hold on
for i = 1:num*num+44
plot3(zminB{i}(1),zminB{i}(2),zminB{i}(3),'.g');
end
title('Mirroring of boundaries')



% figure()
% plot3(ArrayxB_zMin,ArrayyB_zMin,ArrayzB_zMin,'.b')


% setting points for smooth differential calculation


Qp = 20;                   
n_Quiry = Qp^3;
ax = zeros(n_Quiry,1);
ay = zeros(n_Quiry,1);
az = zeros(n_Quiry,1);

xp = linspace(0.3,2.7,Qp);
yp = linspace(0.3,2.7,Qp);
zp = linspace(-1.2,1.2,Qp);

for i = 1:Qp
   for j = 1:Qp
       for k = 1:Qp
           
                ax((i-1)*Qp*Qp+(j-1)*Qp+k) = xp(k);
                ay((i-1)*Qp*Qp+(j-1)*Qp+k) = yp(j);
                az((i-1)*Qp*Qp+(j-1)*Qp+k) = zp(i);
                
       end
   end
end

figure()
scatter3(ax,ay,az,'.b');
hold on
scatter3(ArrayxB_zMin,ArrayyB_zMin,ArrayzB_zMin,'.r');
axis equal
title('points for differential calculatio and original points')

% Voronoi cell original


DataMetrix = [ArrayxB_zMin,ArrayyB_zMin,ArrayzB_zMin];          
DataMetrix = unique(DataMetrix,'rows');                         
[v,c] = voronoin(DataMetrix);                                   

C_region = length(c);
C_Vertex = cell(C_region,1);

for i=1:C_region                                                
    
    C_Vertex{i}=v(c{i},:);

end

% Counting of the points out of the boundary 


C_Vertex_judge = zeros(C_region,1);
for j = 1:C_region              
    
    Lc = size(C_Vertex{j},1);
    
   for k = 1:Lc                       

      for m = 1:3          
       
          switch m
    
              case 1       
                  
                    if C_Vertex{j}(k,m) <= Lim.x0-dxArray 
                        C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    elseif C_Vertex{j}(k,m) >= Lim.x1+dxArray
                        C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    end
                    
              case 2      

                    if C_Vertex{j}(k,m) <= Lim.y0-dyArray 
                       C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    elseif C_Vertex{j}(k,m) >= Lim.y1+dyArray
                       C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    end
                        
              case 3    
            
                    if C_Vertex{j}(k,m) <= Lim.z0-dzArray 
                       C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    elseif C_Vertex{j}(k,m) >= Lim.z1+dzArray
                       C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    end
          end
      end
   end  
end

% calculating the Voronoi cell volume


VolForOne = zeros(C_region,1);
k_vertexs = cell(C_region,1);
for i = 1:C_region             
    
    if isinf(C_Vertex{i}(1,:))              
        
        continue
        
    elseif C_Vertex_judge(i) < 1           
        
        VertexsForOne = C_Vertex{i};
        [k_vertexs{i},VolForOne(i)] = convhulln(VertexsForOne);
        
    end
end


sum(VolForOne)



n_Quiry = length(ax);                         
CircleC = 2;                                  
dh = mean((dxArray+dyArray+dzArray)./3);


h0=0.3;                       
hn=30;
h1=1;
hdn=(h1-h0)/hn;


[W_Gauij,rij,xij,yij,zij]=GauQuiry3D(ArrayxB_zMin,ArrayyB_zMin,ArrayzB_zMin,ax,ay,az,h0,h1,hn,VolForOne,Arrayf);



figure()
xlim([Lim.x0,Lim.x1]);
ylim([Lim.y0,Lim.y1]);
zlim([Lim.z0,Lim.z1]);
scatter3(ax,ay,az,'.');
axis equal
hold on


h_Quiry = zeros(1,hn);
h_r1 = zeros(1,n_Quiry);
for i = 1:n_Quiry
    
    for j = 1:hn                                 

    h_Quiry(j) = abs(W_Gauij(i,j)-1);        
    [qq,hQT] = min(h_Quiry);                 
    h_r = find(h_Quiry==qq)*hdn;

    end

    h_r2 = hQT*hdn+h0;
 
    for k = 1:CircleC
    h_r1(i) = h_r+h0;
    [xunit,yunit,zunit] = DrawCircle3D(ax(i),ay(i),az(i),h_r1(i));
    plot3(xunit(k,:),yunit(k,:),zunit(k,:));
    xlim([Lim.x0,Lim.x1]);
    ylim([Lim.y0,Lim.y1]);
    zlim([Lim.z0,Lim.z1]);
    hold on
    end
end

ppp=cell(n_Quiry,1);
for i=1:n_Quiry
    
    [rn]=findPointsInH(rij(i,:),h_r1(i));           
    ppp{i}=rn;
    
end


xij = abs(xij);
Dminx = min(xij,[],2);
yij = abs(yij);
Dminy = min(yij,[],2);
zij = abs(zij);
Dminz = min(zij,[],2);


Dh_r1_x = zeros(n_Quiry,1);
Dh_r1_y = zeros(n_Quiry,1);
Dh_r1_z = zeros(n_Quiry,1);
Dh_r1 = zeros(n_Quiry,1);
for i=1:n_Quiry
    
   Dh_r1_x(i) = h_r1(i)/Dminx(i);
   Dh_r1_y(i) = h_r1(i)/Dminy(i);
   Dh_r1_z(i) = h_r1(i)/Dminz(i);
   Dh_r1(i) = sqrt(Dh_r1_x(i)*Dh_r1_x(i)+Dh_r1_y(i)*Dh_r1_y(i)+Dh_r1_z(i)*Dh_r1_z(i));
    
end



% for i = n_Quiry:-1:1
%     
%     if ppp{i} == 0
%         Arrayzf(i) = 0;
%     end
%     
% end



% for i = 1:n_Quiry
%    for j = 1:length(ppp{i})
%     
%        VolForOneq{i}(j) = VolForOne(ppp{i}(j));
%    
%    end
% end
% 
% for i = 1:n_Quiry
%    for j = 1:length(ppp{i})
%     
%        fArrayq{i}(j) = Arrayf(ppp{i}(j));
%        Datax{i}(j) = ArrayxB_zMin((ppp{i}(j)));
%        Datay{i}(j) = ArrayyB_zMin((ppp{i}(j)));
%        Dataz{i}(j) = ArrayzB_zMin((ppp{i}(j)));
%    
%    end
% end
% 
% W_Gauij_fix = zeros(n_Quiry,1);
% W_Gauij1_fix = zeros(n_Quiry,1);
% Wx = zeros(n_Quiry,1);
% Wy = zeros(n_Quiry,1);
% Wz = zeros(n_Quiry,1);  
% for i = 1:n_Quiry
% [W_Gauij_fix(i),W_Gauij1_fix(i),Wx(i),Wy(i),Wz(i)]=GauQuiry3D_FixedH(Datax{i},Datay{i},Dataz{i},ax(i),ay(i),az(i),h_r1(i),VolForOneq{i},fArrayq{i});
% end


%% smooth differential calculation

W_Gauij_fix = zeros(n_Quiry,1);
W_Gauij1_fix = zeros(n_Quiry,1);
Wx = zeros(n_Quiry,1);
Wy = zeros(n_Quiry,1);
Wz = zeros(n_Quiry,1);  
for i = 1:n_Quiry
[W_Gauij_fix(i),W_Gauij1_fix(i),Wx(i),Wy(i),Wz(i)]=GauQuiry3D_FixedH(ArrayxB_zMin,ArrayyB_zMin,ArrayzB_zMin,ax(i),ay(i),az(i),h_r1(i),VolForOne,Arrayf);
end

%% data output

save Arrayx.mat ax
save Arrayy.mat ay
save Arrayz.mat az

save W_Gauij1_fix.mat W_Gauij1_fix
save Wx.mat Wx
save Wy.mat Wy
save Wz.mat Wz
