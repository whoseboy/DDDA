function [D,F]=cluster(x,y,f,pFpX,pFpY,M,sub_param,n,f_dep)

%% local dominated eigenvector

D_d.N=length(pFpY);% data number

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

[F,S] = subclust(s,sub_param);

%% FCM clusting


options = [M NaN NaN 0];
[centers,U] = fcm(s,length(F),options);
 maxU = max(U);
for i=1:length(F)+1
    if i<=length(F)
    D.sub(i).index=find(U(i,:)==maxU);
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

