
clear
%% performing the smooth, linear interpolation, and machine learning method to get the differential
%% note that the function "smooth_inter" uses smooth differential calculation method, you can use
%% the fomular differential calculation method (in the functions: "fomular","liner_inter","ml_inter") to get the 
%% differential based on the smooth interpolation.

%% loading data
% loading original data
load xArray.mat
load yArray.mat
load fArray.mat
load in_in.mat% the boundary of the original data points

% loading interpolation point coordinate
load x_dep.mat
load y_dep.mat
load f_dep.mat

h=0.3; 
Num_x=45;
Num_y=33;


noise=linspace(0,16,5)';% noise gradient
smooth=linspace(1,9,3)';% smoothing gradient uesd in the linear interpolation and machine learning 

%% smooth differential calculation

for i=1:length(noise)
   
        % calculating interpolation and partial differential
        [Da.s_noise(i).x,Da.s_noise(i).y,Da.s_noise(i).f,Da.s_noise(i).pFpX,Da.s_noise(i).pFpY,Da.s_noise(i).norm_v]=smooth_inter(xArray,yArray,fArray,noise(i),x_dep,y_dep,in_in);
        %[x,y,f,pFpX,pFpY,norm_v]=smooth_inter(xArray,yArray,fArray,noise,x_dep,y_dep,in_in)

        Da.s_noise(i).sd=[ num2str(0.05*noise(i)) 'f'];% marking the noise level

end

%% calculating the partial differentical using formula values of the interpolation, which is benefits for the 
%% evaluation of the three interpolation methods  
Da.initial.x=x_dep(in_in);
Da.initial.y=y_dep(in_in);
Da.initial.f=f_dep(in_in);


[Da.initial.pFpX,Da.initial.pFpY]=fomular(f_dep,h,Num_x,Num_y,in_in);

% evaluation for the smooth interpolation since some points are deleted
% after interpolation
for i=1:length(noise)
Da.initial.s(i).x=Da.initial.x(Da.s_noise(i).norm_v>0.98&Da.s_noise(i).norm_v<1.02);
Da.initial.s(i).y=Da.initial.y(Da.s_noise(i).norm_v>0.98&Da.s_noise(i).norm_v<1.02);
Da.initial.s(i).f=Da.initial.f(Da.s_noise(i).norm_v>0.98&Da.s_noise(i).norm_v<1.02);
Da.initial.s(i).pFpX=Da.initial.pFpX(Da.s_noise(i).norm_v>0.98&Da.s_noise(i).norm_v<1.02);
Da.initial.s(i).pFpY=Da.initial.pFpY(Da.s_noise(i).norm_v>0.98&Da.s_noise(i).norm_v<1.02);
end

%% Machine learning

for i=1:length(noise)
    for j=1:length(smooth)
   
        % calculating interpolation and partial differential
        [Da.m_noise(i).smooth(j).x,Da.m_noise(i).smooth(j).y,Da.m_noise(i).smooth(j).f,Da.m_noise(i).smooth(j).pFpX,Da.m_noise(i).smooth(j).pFpY]=ml_inter(xArray,yArray,fArray,noise(i),smooth(j),x_dep,y_dep,in_in,Num_x,Num_y,h);
        %[x,y,f,pFpX,pFpY]=ml_inter(xArray,yArray,fArray,noise,smooth,x_dep,y_dep,in_in,Num_x,Num_y,h)

        Da.m_noise(i).sd=[ num2str(0.05*noise(i)) 'f'];% marking the noise level
   
        Da.m_noise(i).smooth(j).sigma=smooth(j);% marking the smoothing level
        
    end
end

%% linear interpolation

for i=1:length(noise)
    for j=1:length(smooth)
   
        
        [Da.l_noise(i).smooth(j).x,Da.l_noise(i).smooth(j).y,Da.l_noise(i).smooth(j).f,Da.l_noise(i).smooth(j).pFpX,Da.l_noise(i).smooth(j).pFpY]=liner_inter(xArray,yArray,fArray,noise(i),smooth(j),x_dep,y_dep,in_in,Num_x,Num_y,h);
        %[x,y,f,pFpX,pFpY]=ml_inter(xArray,yArray,fArray,noise,smooth,x_dep,y_dep,in_in,Num_x,Num_y,h)

        Da.l_noise(i).sd=[ num2str(0.05*noise(i)) 'f'];
   
        Da.l_noise(i).smooth(j).sigma=smooth(j);
        
    end
end



save Da.mat Da


