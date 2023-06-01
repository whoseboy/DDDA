
function D=new_var(D,n,F)

% sub-domains global feature matrix is established, and the unique
% dimensionless group is obtained by matrix's eigenvector. F is the cluster
% center matrix, n is the dimensions of the problem

for i=1:length(F(:,1))


    D.sub(i).dx_dy_dz=[D.sub(i).pFpX,D.sub(i).pFpY,D.sub(i).pFpZ];
    
     for j=1:length(D.sub(i).pFpX)
      
         D.sub(i).c(j).points=D.sub(i).dx_dy_dz(j,:)'*D.sub(i).dx_dy_dz(j,:);
         
     end
end

for i=1:length(F(:,1))

    D.sub(i).C=zeros(n,n);

end

for i=1:length(F(:,1))
    for j=1:length(D.sub(i).pFpX)
        
       D.sub(i).C= D.sub(i).C+D.sub(i).c(j).points;
       
    end 
end



for i=1:length(F(:,1))
    D.sub(i).C1=D.sub(i).C.*length(D.sub(i).pFpX); % obtaining global feature matrix
    
    [D.sub(i).ve,D.sub(i).va]=eig(D.sub(i).C1,'nobalance');
    
    [D.sub(i).d,D.sub(i).ind] = sort(diag(D.sub(i).va));% sorting eigenvalues 
    
    D.sub(i).ves = D.sub(i).ve(:,D.sub(i).ind);% sorting eigenvector matrix's column

    D.sub(i).x_y_z=[D.sub(i).x D.sub(i).y D.sub(i).z];
   
    D.sub(i).lx_y_z_new=D.sub(i).x_y_z* D.sub(i).ves;
   
    D.sub(i).x_y_z_new=exp(D.sub(i).lx_y_z_new); % obating the unique dimensionless group
end
end
        