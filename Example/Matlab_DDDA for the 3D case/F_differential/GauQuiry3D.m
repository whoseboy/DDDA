function [W_Gauij,rij,xij,yij,zij] = GauQuiry3D(x,y,z,x_Q,y_Q,z_Q,h0,h1,hn,Area,d_var)

xarray = x;         %输入3D坐标点
yarray = y;
zarray = z;
N = length(xarray);
     
N_Q = length(x_Q);



xij = zeros(N_Q,N_Q);
yij = zeros(N_Q,N_Q);
zij = zeros(N_Q,N_Q);
rij = zeros(N_Q,N);
xDx = zeros(N_Q,N_Q);
yDy = zeros(N_Q,N_Q);
zDz = zeros(N_Q,N_Q);

for i = 1:N_Q
    for j = 1:N
       
        
        xij(i,j) = x_Q(i) - xarray(j);   % x distances
        yij(i,j) = y_Q(i) - yarray(j);   % y distances
        zij(i,j) = z_Q(i) - zarray(j);   % y distances
       
        rij(i,j) = sqrt(xij(i,j)*xij(i,j) + yij(i,j)*yij(i,j) + zij(i,j)*zij(i,j));
        
        xDx(i,j) = xij(i,j)/rij(i,j);
        yDy(i,j) = yij(i,j)/rij(i,j);
        zDz(i,j) = zij(i,j)/rij(i,j);
        
        if isnan(xDx(i,j))
            xDx(i,j) = 0;
        end
         if isnan(yDy(i,j))
            yDy(i,j) = 0;
         end   
         if isnan(zDz(i,j))
            zDz(i,j) = 0;
         end   
     end
    
end

% % ConfidenceRange=0.99;
% % Vol=dp*dp;  % the volume in 2-D is simply dx*dx
% % SmoothLength_Coefficient=1.5;            %平滑系数
% 
W_Gauij = zeros(N_Q,hn);
W_Gauij1 = zeros(N_Q,hn);

for k = 1:hn
    
     h = (((h1-h0)/hn))*k+h0;
     aGau = 1/((pi^(3/2))*(h*h*h));

q = rij./h;

D1_Gauij_x = zeros(N_Q,1);
D1_Gauij_y = zeros(N_Q,1);
D1_Gauij_z = zeros(N_Q,1);

for i = 1:N_Q
    W_Gauij(i,k) = 0;
    W_Gauij1(i,k) = 0;
    for j = 1:N   
        q(i,j) = rij(i,j)/h;
        
        % 高斯核函数计算 
        W_Gau_neigh = aGau*exp(-q(i,j)^2);
        W_Gauij1(i,k) = W_Gauij1(i,k) + d_var(j)*W_Gau_neigh*Area(j); 
        W_Gauij(i,k) = W_Gauij(i,k) + W_Gau_neigh*Area(j); 
        
%          % 高斯核函数计算 x方向导数
        W1_Gau_neigh_x = xDx(i,j)*(-2*rij(i,j)/(h^2))*aGau*exp(-q(i,j)^2);
        D1_Gauij_x(i) = D1_Gauij_x(i) + d_var(j)*W1_Gau_neigh_x*Area(j); 
%         
%         % 高斯核函数计算 y方向导数   
        W1_Gau_neigh_y = yDy(i,j)*(-2*rij(i,j)/(h^2))*aGau*exp(-q(i,j)^2);
        D1_Gauij_y(i) = D1_Gauij_y(i) + d_var(j)*W1_Gau_neigh_y*Area(j); 
   
%         % 高斯核函数计算 z方向导数   
        W1_Gau_neigh_z = zDz(i,j)*(-2*rij(i,j)/(h^2))*aGau*exp(-q(i,j)^2);
        D1_Gauij_z(i) = D1_Gauij_z(i) + d_var(j)*W1_Gau_neigh_z*Area(j); 
    end
end
end

