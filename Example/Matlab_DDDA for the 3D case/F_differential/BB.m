clear
clc

%% 正方体标准值测试

%% 设置数据点及数据点数据
% 本程序块首先定义了数值（实验）点域，再结合王驰提供的两个分段函数对每个数值点的位置和数值大小进行定义
% lim为数据点的范围
Lim.x0 = 0;    Lim.x1 = 3;
Lim.y0 = 0;    Lim.y1 = 3;
Lim.z0 = -1.5;    Lim.z1 = 1.5;

num = 20;                             % 设置数值点在每一个维度上的数量
n_Quiry = num^3;                      % 数值点的总数（3维）

dxArray = (Lim.x1-Lim.x0)/num;        % 步长
dyArray = (Lim.y1-Lim.y0)/num;
dzArray = (Lim.z1-Lim.z0)/num;

xfp = linspace(Lim.x0,Lim.x1,num);    % 按照数值点的数量平均分布间距
yfp = linspace(Lim.y0,Lim.y1,num);
zfp = linspace(Lim.z0,Lim.z1,num);

Arrayx = zeros(n_Quiry,1);
Arrayy = zeros(n_Quiry,1);
Arrayz = zeros(n_Quiry,1);
Arrayf = zeros(n_Quiry,1);

for i = 1:num
   for j = 1:num
       for k = 1:num
           
                Arrayx((i-1)*num*num+(j-1)*num+k) = xfp(k);    % 定义点坐标， x为一步一变
                Arrayy((i-1)*num*num+(j-1)*num+k) = yfp(j);    % y为n步一变（n为一个维度上点的数量）
                Arrayz((i-1)*num*num+(j-1)*num+k) = zfp(i);    % z为n^2步一变
                
                if Arrayz((i-1)*num*num+(j-1)*num+k) <= 0      % 调用王驰的分段函数为数据点赋值
                    
                    Arrayf((i-1)*num*num+(j-1)*num+k) = f1(Arrayx((i-1)*num*num+(j-1)*num+k),Arrayy((i-1)*num*num+(j-1)*num+k),Arrayz((i-1)*num*num+(j-1)*num+k));
                
                elseif Arrayz((i-1)*num*num+(j-1)*num+k) > 0
                        
                    Arrayf((i-1)*num*num+(j-1)*num+k) = f2(Arrayx((i-1)*num*num+(j-1)*num+k),Arrayy((i-1)*num*num+(j-1)*num+k),Arrayz((i-1)*num*num+(j-1)*num+k));
                        
                end
       end
   end
end

figure()
scatter3(Arrayx,Arrayy,Arrayz,'.');
title('未扰动的数据点')
axis equal

%% 给数据点加上位置扰动
% 反应实验中的问题，在xyz坐标上加入有正负值的扰动

for i = 1:num
   for j = 1:num
       for k = 1:num
           
                Exyz = rand(1)*0.05; % 正负百分之十以内的随机误差
                Arrayx((i-1)*num*num+(j-1)*num+k) = Arrayx((i-1)*num*num+(j-1)*num+k) + ((-1)^round(Exyz))*Exyz*Arrayx((i-1)*num*num+(j-1)*num+k);
                Arrayy((i-1)*num*num+(j-1)*num+k) = Arrayy((i-1)*num*num+(j-1)*num+k) + ((-1)^round(Exyz))*Exyz*Arrayy((i-1)*num*num+(j-1)*num+k);
                Arrayz((i-1)*num*num+(j-1)*num+k) = Arrayz((i-1)*num*num+(j-1)*num+k) + ((-1)^round(Exyz))*Exyz*Arrayz((i-1)*num*num+(j-1)*num+k);
                
       end
   end
end
Arrayf_color = Arrayf;

figure()
scatter3(Arrayx,Arrayy,Arrayz,'.');
title('加入扰动后的原数据')
axis equal

figure()
scatter3(Arrayx,Arrayy,Arrayz,80,Arrayf_color,'.');
title('数值f扰动前')
axis equal

%% 给数值点加上数值扰动

Arrayf_Pert = Arrayf;
for i = 1:num
   for j = 1:num
       for k = 1:num
           
                Exyz = rand(1)*0.05; % 正负百分之十以内的随机误差
                Arrayf_Pert((i-1)*num*num+(j-1)*num+k) = Arrayf_Pert((i-1)*num*num+(j-1)*num+k) + ((-1)^round(Exyz))*Exyz*Arrayf_Pert((i-1)*num*num+(j-1)*num+k);
                
       end
   end
end
Arrayf_Pert_color = Arrayf_Pert;

figure()
scatter3(Arrayx,Arrayy,Arrayz,80,Arrayf_Pert_color,'.');
title('数值f扰动后')
axis equal

%% 数值点边界处理 镜像（对称） 其中R为旋转矩阵，针对存在非垂直坐标轴的情况
% MATLAB中自带的voronoi算法不会对外边界进行特殊处理，所以当对最外层数据点画网格时会导致许多的顶点超出我们定义的
% 数据域，甚至会有距离无限远的顶点，从而导致原先的边界模糊且无法计算。
% 在外边界倾斜时我们可以引入旋转矩阵来辅助镜像，在本例子中由于所有外边界都为垂直，所以没有使用此功能
% 整体镜像偏移过程像是叠箱子，在过程中数组是增大的
% 为了对齐数列的长度，方便计算，镜像后的数据点的数值f定为0

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

% 以下是按顺序对每个面进行重复 先识别出最外侧面的所有点，再对垂直坐标轴进行偏移镜像
% xMin
ArrayxJ_xMin = Arrayx;
ArrayxB_xMin = Arrayx;
ArrayyB_xMin = Arrayy;
ArrayzB_xMin = Arrayz;

for i = 1:num*num

    [rBxl,rBxil] = min(ArrayxJ_xMin);           % 识别面上的极端点（在这里是最小点）
    xmin(i) = rBxil;                            % 储存极端点的位置
    ArrayxJ_xMin(rBxil) = (Lim.x1-Lim.x0)/2;    % 使用中位点替代极端点，使得程序可以识别下一个极端点
    xminB{i} =  [-1*ArrayxB_xMin(xmin(i))-dxArray+ArrayxB_xMin(xmin(i)),ArrayyB_xMin(xmin(i)),ArrayzB_xMin(xmin(i))];
    % 上式为镜像及偏移过程
    ArrayxB_xMin = [ArrayxB_xMin;xminB{i}(1)];  % 将镜像后的点组合到原数据中
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
title('镜像边界示例，红色点阵为识别到的边界，绿色点阵为镜像边界')

% 旋转矩阵
% hold on                 
% for i = 1:num*num                   % 镜像中加入旋转角度
% 
%     Rx = rotx(0);
%     Ry = roty(0);
%     Rz = rotz(0);
%     
%     xminB{i} = Rz*[Arrayx(xmin(i));Arrayy(xmin(i));Arrayz(xmin(i))];
%     plot3(xminB{i}(1),xminB{i}(2)+3.5,xminB{i}(3),'.g');
%     hold on
%     
%     yminB{i} = Rz*[Arrayx(ymin(i));Arrayy(ymin(i));Arrayz(ymin(i))];
%     plot3(yminB{i}(1),yminB{i}(2),yminB{i}(3),'.g');
%     hold on
%     
%     zminB{i} = Rz*[Arrayx(zmin(i));Arrayy(zmin(i));Arrayz(zmin(i))]+Arrayz(zmin(i));
%     plot3(zminB{i}(1),zminB{i}(2),zminB{i}(3),'.g');
%     hold on
%     
% end

figure()
plot3(ArrayxB_zMin,ArrayyB_zMin,ArrayzB_zMin,'.b')
title('加入镜像边界后');

%% 设置差值点
% 要插值的点

Qp = 10;                   % 每个维度设置10个差值点
n_Quiry = Qp^3;
ax = zeros(n_Quiry,1);
ay = zeros(n_Quiry,1);
az = zeros(n_Quiry,1);

xp = linspace(0.2,2.8,Qp);
yp = linspace(0.2,2.8,Qp);
zp = linspace(-1.3,1.3,Qp);

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
title('差值点与数据点')

%% 画Voronoi网格
% 直接引用MATLAB中的程序

DataMetrix = [ArrayxB_zMin,ArrayyB_zMin,ArrayzB_zMin];          % 画Voronoi所需的坐标
DataMetrix = unique(DataMetrix,'rows');                         % 删除重复的点
[v,c] = voronoin(DataMetrix);                                   % 画Voronoi网格 得到顶点在数组中的位置和坐标

C_region = length(c);
C_Vertex = cell(C_region,1);

for i=1:C_region                                                % 获得每个Voronoi网格中每一点的坐标值
    
    C_Vertex{i}=v(c{i},:);

end

%% 统计超出边界的多边体
% 在原边界(lim)上增加一层缓冲(dx,dy,dz),而后统计所有存在顶点超过边界的Voronoi网格
% 这里有一个容忍度的功能，C_Vertex_judge是用来判断的变量，每当一个顶点的一个坐标点超过边界限制，
% C_Vertex_judge就会加一。此功能遍历所有Voronoi网格。

C_Vertex_judge = zeros(C_region,1);
for j = 1:C_region              % 遍历每一个多面体，每一个多边体的顶点坐标 C_region
    
    Lc = size(C_Vertex{j},1);
    
   for k = 1:Lc                    % 多边体的边数 Lc     

      for m = 1:3          % 三个方向共六个最大/最小边界 找出点超出哪个边界 Dimensions
       
          switch m
    
              case 1       % 第一个维度(x)
                  
                    if C_Vertex{j}(k,m) <= Lim.x0-dxArray 
                        C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    elseif C_Vertex{j}(k,m) >= Lim.x1+dxArray
                        C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    end
                    
              case 2      % 第二个维度(y)

                    if C_Vertex{j}(k,m) <= Lim.y0-dyArray 
                       C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    elseif C_Vertex{j}(k,m) >= Lim.y1+dyArray
                       C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    end
                        
              case 3    % 第三个维度(z)
            
                    if C_Vertex{j}(k,m) <= Lim.z0-dzArray 
                       C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    elseif C_Vertex{j}(k,m) >= Lim.z1+dzArray
                       C_Vertex_judge(j) = C_Vertex_judge(j)+1;
                    end
          end
      end
   end  
end

%% 计算体积
% 直接引用程序包QHull来计算体积，这是本套代码对于高维度数组计算的唯一限制，维度N被限制小于9。

VolForOne = zeros(C_region,1);
k_vertexs = cell(C_region,1);
figure()
for i = 1:C_region              % 遍历 C_region
    
    if isinf(C_Vertex{i}(1,:))              % 当Voronoi cell存在一无限远的顶点时，跳过这一Voronoi cell
        
        continue
        
    elseif C_Vertex_judge(i) < 1            % 这一步可设置容忍度C_Vertex_judge，本程序中容忍度为零
        
        VertexsForOne = C_Vertex{i};
        [k_vertexs{i},VolForOne(i)] = convhulln(VertexsForOne);
        trisurf(k_vertexs{i},VertexsForOne(:,1),VertexsForOne(:,2),VertexsForOne(:,3),'FaceColor','cyan')
    hold on
    end
    
    
end
title('画出Voronoi凸域');
