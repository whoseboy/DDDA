function [x,y,f,pFpX,pFpY]=ml_inter(xArray,yArray,fArray,noise,smooth,x_dep,y_dep,in_in,Num_x,Num_y,h)
%%  Adding noise


a=0.05*randn(length(fArray),1);

fArray_noise=fArray.*(1+ noise.*a);


%% machine learning


x_y=[xArray'; yArray'];



net = feedforwardnet(10);
net = configure(net,x_y,fArray_noise');
fArray1 = net(x_y);


net = train(net,x_y,fArray_noise');
fArray2 = net(x_y);



x_y1=[x_dep';y_dep'];
f_ml=net(x_y1);

%% Gaussian smoothing
f_smooth=imgaussfilt(f_ml',smooth);

%% fomular differential calculation

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
