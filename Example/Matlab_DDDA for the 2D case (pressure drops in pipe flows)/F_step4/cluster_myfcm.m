function [D,F]=cluster_myfcm(x,y,f,pFpX,pFpY,M,sub_p,n,f_dep)

%% local dominated eigenvector
D_d.N=length(pFpY);

for i=1:D_d.N
    
    D_d.d(i).pFp_i=[pFpX(i);pFpY(i)];
    
    D_d.d(i).W=D_d.d(i).pFp_i*D_d.d(i).pFp_i';
    
    [D_d.d(i).ve,D_d.d(i).va]=eig(D_d.d(i).W,'nobalance');
    
    [D_d.d(i).d,D_d.d(i).ind] = sort(diag(D_d.d(i).va));
    D_d.d(i).vas = D_d.d(i).va(D_d.d(i).ind,D_d.d(i).ind);
    
    D_d.d(i).ves = D_d.d(i).ve(:,D_d.d(i).ind); % the position of the max eigenvalue corresponding to the dominated eigenvector 
    
end

s=zeros(length(pFpY),n);
for i=1:D_d.N
    for j=1:n
    s(i,j)=D_d.d(i).ves(j,n);
    end
end

%% estimating the number of the clusting center 

[F,S] = subclust(s,sub_p);% C是中心点矩阵；S是 Cluster Influence Range for Each Data Dimension

%% FCM clusting


% options = [M NaN NaN 0];
% [centers,U] = myfcm(s,length(F),F,options);

dist_initi=distfcm(F+0.1.*ones(length(F),n),s);
tmp_initi=dist_initi.^(-2/(M-1));     
U = tmp_initi./(ones(length(F), 1)*sum(tmp_initi));
max_iter=100;
min_impro=1e-5;
for i = 1:max_iter
	[U, center, obj_fcn(i)] = stepfcm(s, U, length(F), M);
	
	% check termination condition
	if i>1
        
		if abs(obj_fcn(i) - obj_fcn(i-1)) < min_impro, break; end
        
    end
end

% iter_n = i;	% Actual number of iterations 
% obj_fcn(iter_n+1:max_iter) = [];

 maxU = max(U);
for i=1:length(F)+1
    if i<=length(F)
    D.sub(i).index=find(U(i,:)==maxU&U(i,:)>=0.6);
    else
        D.sub(i).index=find(maxU<0.6);
    end
    D.sub(i).x=x(D.sub(i).index);
    D.sub(i).y=y(D.sub(i).index);
    D.sub(i).f=f(D.sub(i).index);
    D.sub(i).fo=f_dep(D.sub(i).index);
    D.sub(i).pFpX=pFpX(D.sub(i).index);
    D.sub(i).pFpY=pFpY(D.sub(i).index);
   
    
end

