clear
clc

%% 正方体标准值测试

clear
clc

%% 设置数据点及数据点数据
% 本程序块首先定义了数值（实验）点域，再结合王驰提供的两个分段函数对每个数值点的位置和数值大小进行定义
% lim为数据点的范围
Lim.x0 = 0;    Lim.x1 = 3;
Lim.y0 = 0;    Lim.y1 = 3;
Lim.z0 = -1.5;    Lim.z1 = 1.5;

num = 5;                             % 设置数值点在每一个维度上的数量
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

voronoi(Arrayx,Arrayz);