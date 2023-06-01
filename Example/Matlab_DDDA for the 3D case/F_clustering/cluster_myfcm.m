function [D,F,U,D_d]=cluster_myfcm(x,y,z,f,pFpX,pFpY,pFpZ,M,sub_p,n)

% obtaining local features, cutting parameter space. F is the cluster
% center matrix; U is the membership matrix. x,y,z,f,pFpX,pFpY,pFpZ are the
% interpolation data; M is m; Sub_p is ra; n is the problem dimension.

%% obtaining local dominated eigenvectors
D_d.N=length(pFpY);% number of data points

for i=1:D_d.N
    
    D_d.d(i).pFp_i=[pFpX(i);pFpY(i);pFpZ(i)];
    
    D_d.d(i).W=D_d.d(i).pFp_i*D_d.d(i).pFp_i';% local feature matrix of each point
    
    [D_d.d(i).ve,D_d.d(i).va]=eig(D_d.d(i).W,'nobalance');
    
    [D_d.d(i).d,D_d.d(i).ind] = sort(diag(D_d.d(i).va));
    
    D_d.d(i).vas = D_d.d(i).va(D_d.d(i).ind,D_d.d(i).ind); % sorting eigenvalues 
    
    D_d.d(i).ves = D_d.d(i).ve(:,D_d.d(i).ind);% sorting eigenvector matrix's column
    
end

s=zeros(length(pFpY),n);% obtain local features
for i=1:D_d.N
    for j=1:n
    s(i,j)=abs(D_d.d(i).ves(j,n));
    end
end

%% preforming subclust algorithm

[F,S] = subclust(s,sub_p);% F is the estimating cluster center matrix ；S is Cluster Influence Range for Each Data Dimension
% sub_p=ra
%% performing FCM algorithm

options = [M NaN NaN 0];
% M=m

[centers,U] = fcm(s,length(F(:,1)),options);

 maxU = max(U);
for i=1:length(F(:,1))+1
    if i<=length(F(:,1))
    D.sub(i).index=find(U(i,:)==maxU&U(i,:)>=0.6);
    else
        D.sub(i).index=find(maxU<0.6);
    end
    D.sub(i).x=x(D.sub(i).index);
    D.sub(i).y=y(D.sub(i).index);
    D.sub(i).z=z(D.sub(i).index);
    D.sub(i).f=f(D.sub(i).index);
    D.sub(i).pFpX=pFpX(D.sub(i).index);
    D.sub(i).pFpY=pFpY(D.sub(i).index);
    D.sub(i).pFpZ=pFpZ(D.sub(i).index);   
end
end

