
clear
%% cutting the parameter space using subculst-FCM algorithm

%% loading the partial different 

load Da.mat

noise=linspace(0,16,5)';
smooth=linspace(1,9,3)';

M=[1.1; 2; 3; 4];% M=m

sub_param=0.1.*linspace(1,9,3)';% sub_param=ra

% case dimensions
n=2;
%% formula values clustering 

% clusering for the comparison with linear interpolation and machine
% learning since no points are deleted 

Da.initial.sub_inf=['M' num2str(M(2)),  '_ra' num2str(sub_param(3))];% marking clustering parameters
    
[Da.initial.sub,Da.initial.C]=cluster_myfcm_f(Da.initial.x,Da.initial.y,Da.initial.f,Da.initial.pFpX,Da.initial.pFpY,M(2),sub_param(3),n,Da.initial.f);
%[D,F]=cluster(x,y,f,pFpX,pFpY,M,sub_param,n,f_dep), subclust-FCM
%clustering
    
Da.initial.sub= new_var(Da.initial.sub,n,Da.initial.C); 
%D=new_var(D,n,F), obtaining unique dimensionless group



% clusering for the comparison with smooth interpolation since no points are deleted

for i=1:length(noise)
    for k=1:length(sub_param)
             
        Da.initial.s(i).sub_param(k).sub_inf=['M' num2str(M(2)),  '_ra' num2str(sub_param(k))];
    
        [Da.initial.s(i).sub_param(k).sub,Da.initial.s(i).sub_param(k).C]=cluster_myfcm_f(Da.initial.s(i).x,Da.initial.s(i).y,Da.initial.s(i).f,Da.initial.s(i).pFpX,Da.initial.s(i).pFpY,M(2),sub_param(k),n,Da.initial.f);
        
        Da.initial.s(i).sub_param(k).sub= new_var(Da.initial.s(i).sub_param(k).sub,n,Da.initial.s(i).sub_param(k).C); 
             
    end
end

for i=1:length(noise)
    for k=1:length(M)
             
        Da.initial.s(i).M(k).sub_inf=['M' num2str(M(k)),  '_ra' num2str(sub_param(2))];% 标注overlap ra
    
        [Da.initial.s(i).M(k).sub,Da.initial.s(i).M(k).C]=cluster_myfcm_f(Da.initial.s(i).x,Da.initial.s(i).y,Da.initial.s(i).f,Da.initial.s(i).pFpX,Da.initial.s(i).pFpY,M(k),sub_param(2),n,Da.initial.f);
        
        Da.initial.s(i).M(k).sub= new_var(Da.initial.s(i).M(k).sub,n,Da.initial.s(i).M(k).C); 
             
    end
end

%% smooth differential clustring 

% ra
for i=1:length(noise)
    for k=1:length(sub_param)
             
        Da.s_noise(i).sub_param(k).sub_inf=['M' num2str(M(2)),  '_ra' num2str(sub_param(k))];% 标注overlap ra
    
        [Da.s_noise(i).sub_param(k).sub,Da.s_noise(i).sub_param(k).C]=cluster_myfcm(Da.s_noise(i).x,Da.s_noise(i).y,Da.s_noise(i).f,Da.s_noise(i).pFpX,Da.s_noise(i).pFpY,M(2),sub_param(k),n,Da.initial.f);
        
        Da.s_noise(i).sub_param(k).sub= new_var(Da.s_noise(i).sub_param(k).sub,n,Da.s_noise(i).sub_param(k).C); 
             
    end
end

% m
for i=1:length(noise)
    for k=1:length(M)
             
        Da.s_noise(i).M(k).sub_inf=['M' num2str(M(k)),  '_ra' num2str(sub_param(2))];% 标注overlap ra
    
        [Da.s_noise(i).M(k).sub,Da.s_noise(i).M(k).C]=cluster_myfcm(Da.s_noise(i).x,Da.s_noise(i).y,Da.s_noise(i).f,Da.s_noise(i).pFpX,Da.s_noise(i).pFpY,M(k),sub_param(2),n,Da.initial.f);
        
        Da.s_noise(i).M(k).sub= new_var(Da.s_noise(i).M(k).sub,n,Da.s_noise(i).M(k).C); 
             
    end
end


%% machine learning clustering

% clustering under M=2；sub_param=0.9

for i=1:length(noise)
    for j=1:length(smooth)
             
        Da.m_noise(i).smooth(j).sub_inf=['M' num2str(M(2)),  '_ra' num2str(sub_param(3))];% 标注overlap ra
    
        [Da.m_noise(i).smooth(j).sub,Da.m_noise(i).smooth(j).C]=cluster_myfcm(Da.m_noise(i).smooth(j).x,Da.m_noise(i).smooth(j).y,Da.m_noise(i).smooth(j).f,Da.m_noise(i).smooth(j).pFpX,Da.m_noise(i).smooth(j).pFpY,M(2),sub_param(3),n,Da.initial.f);
            
        Da.m_noise(i).smooth(j).sub= new_var(Da.m_noise(i).smooth(j).sub,n,Da.m_noise(i).smooth(j).C); 

    end
end


%% linear interpolation clustering

% clustering under M=2；sub_param=0.9

for i=1:length(noise)
    for j=1:length(smooth)
             
        Da.l_noise(i).smooth(j).sub_inf=['M' num2str(M(2)),  '_ra' num2str(sub_param(3))];% 标注overlap ra
    
        [Da.l_noise(i).smooth(j).sub,Da.l_noise(i).smooth(j).C]=cluster_myfcm(Da.l_noise(i).smooth(j).x,Da.l_noise(i).smooth(j).y,Da.l_noise(i).smooth(j).f,Da.l_noise(i).smooth(j).pFpX,Da.l_noise(i).smooth(j).pFpY,M(2),sub_param(3),n,Da.initial.f);
            
        Da.l_noise(i).smooth(j).sub= new_var(Da.l_noise(i).smooth(j).sub,n,Da.l_noise(i).smooth(j).C); 

    end
end


save Da_clust.mat Da