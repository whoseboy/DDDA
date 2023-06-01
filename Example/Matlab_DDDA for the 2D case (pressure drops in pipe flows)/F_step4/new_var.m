
function D=new_var(D,n,F)

for i=1:length(F)

    D.sub(i).pFpX;
    D.sub(i).pFpY;
    D.sub(i).dx_dy=[D.sub(i).pFpX,D.sub(i).pFpY];
    
     for j=1:length(D.sub(i).pFpX)
      
         D.sub(i).c(j).points=D.sub(i).dx_dy(j,:)'*D.sub(i).dx_dy(j,:);
         
     end
end

for i=1:length(F)

    D.sub(i).C=zeros(n,n);

end

for i=1:length(F)
    for j=1:length(D.sub(i).pFpX)
        
       D.sub(i).C= D.sub(i).C+D.sub(i).c(j).points;
       
    end 
end



for i=1:length(F)
    D.sub(i).C1=D.sub(i).C.*length(D.sub(i).pFpX);
    
    [D.sub(i).ve,D.sub(i).va]=eig(D.sub(i).C1,'nobalance');
    
    [D.sub(i).d,D.sub(i).ind] = sort(diag(D.sub(i).va));
    
    D.sub(i).ves = D.sub(i).ve(:,D.sub(i).ind);
   
%    D.sub(i).Z=W* D.sub(i).ves;

    D.sub(i).x_y=[D.sub(i).x D.sub(i).y];
   
    D.sub(i).lx_y_new=D.sub(i).x_y* D.sub(i).ves;
   
    D.sub(i).x_y_new=exp(D.sub(i).lx_y_new);
end
end
        