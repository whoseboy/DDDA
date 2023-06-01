function [x,y,f,pFpX,pFpY]=liner_inter(xArray,yArray,fArray,noise,smooth,x_dep,y_dep,in_in,Num_x,Num_y,h)
%%  adding noise
N_dep=length(x_dep);

a=0.05*randn(length(fArray),1);

fArray_noise=fArray.*(1+ noise.*a);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% liner interpolation

DT=delaunay(xArray,yArray);         

NoDT=length(DT(:,1));              
PiDT=zeros(N_dep,1);
x_DT=cell(NoDT,1);
y_DT=cell(NoDT,1);
f_DT=cell(NoDT,1);
for i=1:N_dep
    
    for j=1:NoDT
        for l=1:3
            
    x_DT{j}(l)=xArray(DT(j,l));          
    y_DT{j}(l)=yArray(DT(j,l));
    f_DT{j}(l)=fArray_noise(DT(j,l));
        end
        
    in=inpolygon(x_dep(i),y_dep(i),x_DT{j},y_DT{j});  
    
    if in==1
        PiDT(i)=j;                                  
    end
    
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Interpolate_DT=zeros(N_dep,1);

for i=1:N_dep     

    Interpolate_DT(i)=griddata(x_DT{PiDT(i)},y_DT{PiDT(i)},f_DT{PiDT(i)},x_dep(i),y_dep(i));
    
end





%% Gaussian smoothing
f_smooth=imgaussfilt(Interpolate_DT,smooth);

%% formular differential calculation

f_smooth_martix=reshape(f_smooth,Num_y,Num_x);


for i=1:Num_x
    if i<Num_x
         pFpX_intial_martix(:,i)=(f_smooth_martix(:,i+1)-f_smooth_martix(:,i))./h;
    else 
        pFpX_intial_martix(:,i)=(f_smooth_martix(:,i)-f_smooth_martix(:,i-1))./h;
    
    end 
end

for i=1:Num_y
    if i<Num_y
         pFpY_intial_martix(i,:)=(f_smooth_martix(i+1,:)-f_smooth_martix(i,:))./h;
    else 
        pFpY_intial_martix(i,:)=(f_smooth_martix(i,:)-f_smooth_martix(i-1,:))./h;
    
    end 
end

%% data output

f=f_smooth(in_in);

x=x_dep(in_in);

y=y_dep(in_in);



pFpX_intial=pFpX_intial_martix(:);
pFpY_intial=pFpY_intial_martix(:);


pFpX=pFpX_intial(in_in);

pFpY=pFpY_intial(in_in);




end







