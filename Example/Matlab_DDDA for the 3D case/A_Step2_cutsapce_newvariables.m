clear
%% cutting parameter space and obtaining unique dimensionless group.
% containing three steps:1 loading differnetial data; 2 cutting space
% using function
% [D,F,U,D_d]=cluster_myfcm(x,y,z,f,pFpX,pFpY,pFpZ,M,sub_p,n); 3 obtaining
% unique dimensionless group using function D=new_var(D,n,F)

%% loading interpolation data
% points coordinate
load Arrayx.mat
load Arrayy.mat
load Arrayz.mat


% points interpolation
load W_Gauij1_fix.mat

% partial differential
load Wx.mat
load Wy.mat
load Wz.mat

%% cutting parameter space

M=4; % m=4

sub_p=0.9; % ra=0.9

n=3; % dimensions=3

[D.sub,D.C,U,D_d]=cluster_myfcm(ax,ay,az,W_Gauij1_fix,Wx,Wy,Wz,M,sub_p,n);%这里的f_inter只是方便每一个分区数值的对比

%% obtaining unique dimensionless group

D.sub=new_var(D.sub,n,D.C);

