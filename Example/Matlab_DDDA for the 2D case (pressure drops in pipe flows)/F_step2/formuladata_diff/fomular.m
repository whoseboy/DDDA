function [pFpX,pFpY]=fomular(f_dep,h,Num_x,Num_y,in_in)


f_dep_martix=reshape(f_dep,Num_y,Num_x);




for i=1:Num_x
    if i<Num_x
         pFpX_martix(:,i)=(f_dep_martix(:,i+1)-f_dep_martix(:,i))./h;
    else 
        pFpX_martix(:,i)=(f_dep_martix(:,i)-f_dep_martix(:,i-1))./h;
    
    end 
end

for i=1:Num_y
    if i<Num_y
         pFpY_martix(i,:)=(f_dep_martix(i+1,:)-f_dep_martix(i,:))./h;
    else 
        pFpY_martix(i,:)=(f_dep_martix(i,:)-f_dep_martix(i-1,:))./h;
    
    end 
end

pFpX=pFpX_martix(:);
pFpY=pFpY_martix(:);
pFpX=pFpX(in_in);
pFpY=pFpY(in_in);

end