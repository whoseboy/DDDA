function [W_Gauij,W_Gauij1,D1_Gauij_x,D1_Gauij_y,D1_Gauij_z] = GauQuiry3D_FixedH(x,y,z,x_Q,y_Q,z_Q,h,Area,d_var)

xarray = x;         %输入3D坐标点
yarray = y;  
zarray = z;
N = length(xarray);

aGau = 1/((pi^(3/2))*(h*h*h));

D1_Gauij_x = 0;
D1_Gauij_y = 0;
D1_Gauij_z = 0;
 W_Gauij = 0;
W_Gauij1 = 0;


for j = 1:N
      
        xij = x_Q - xarray(j);   % x distances
        yij = y_Q - yarray(j);   % y distances
        zij = z_Q - zarray(j);   % y distances
       
        rij = sqrt(xij*xij + yij*yij + zij*zij);
        
        xDr = xij/rij;
        yDr = yij/rij;
        zDr = zij/rij;        

        if isnan(xDr)
            xDr = 0;
        end
         if isnan(yDr)
            yDr = 0;
         end   
           if isnan(zDr)
              zDr = 0;
           end   
        
        q(j) = rij/h;
        
        % 高斯核函数计算 
        if q(j) <= 3 
             W_Gau_neigh = aGau*exp(-q(j)^2);
             else
            W_Gau_neigh = 0;
        end
       
        W_Gauij1 = W_Gauij1 + d_var(j)*W_Gau_neigh*Area(j); 
        W_Gauij = W_Gauij + W_Gau_neigh*Area(j); 
        
%          % 高斯核函数计算 x方向导数
        
      
        W1_Gau_neigh_x = xDr*(-2.*rij/(h^2))*W_Gau_neigh;
        D1_Gauij_x = D1_Gauij_x + d_var(j)*W1_Gau_neigh_x*Area(j); 
         
%         % 高斯核函数计算 y方向导数  
     
        W1_Gau_neigh_y = yDr*(-2.*rij/(h^2))*W_Gau_neigh;
        D1_Gauij_y = D1_Gauij_y + d_var(j)*W1_Gau_neigh_y*Area(j); 
   
%         % 高斯核函数计算 z方向导数   
       
        W1_Gau_neigh_z = zDr*(-2.*rij/(h^2))*W_Gau_neigh;
        D1_Gauij_z = D1_Gauij_z + d_var(j)*W1_Gau_neigh_z*Area(j); 
end



