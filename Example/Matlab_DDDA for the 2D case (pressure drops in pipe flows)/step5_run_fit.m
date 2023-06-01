clear 

%% data fitting

%% loading clustering results

load Da_clust.mat

noise=linspace(0,16,5)';
smooth=linspace(1,9,3)';

M=[1.1; 2; 3; 4];

sub_param=0.1.*linspace(1,9,3)';


n=2;


%% designing fitting formats

%  index of Linear polynomial
poly=[];
for i=0:2
    for j=0:2
        if i==0 && j==0
            
            Frame_Name=[];
        
        else
            
            Frame_Name=['poly' num2str(i) num2str(j)];
        
        end
        
        poly=[poly;Frame_Name];
        
    end
end 
% index of Nonlinear polynomial
poly1=[];
for i=0:1
    for j=0:1
        if i==0 && j==0
            
            Frame_Name=[];
        
        else
            
            Frame_Name=['poly' num2str(i) num2str(j)];
        
        end
        
        poly1=[poly1;Frame_Name];
        
    end
end 
% 20 kinds of linear fitting are performed, so we convert the independent variables formats
% to make the nolinear polynomial obtaining from linear fitting, fitting
% scheme of the four kinds result (formula values, linear interpolation,
% smooth interpolation, and machine learning) ues the same fitting scheme,
% Chinese marks can be ignored. 



%% formula values

% formula values for the comparison with linear interpolation and machine
% learning

% converting the independent varibles formats to satify the linear fitting

for l=1:length(Da.initial.C)
                 Da.initial.sub.sub(l).xd_yd=1./Da.initial.sub.sub(l).x_y_new;
                 Da.initial.sub.sub(l).xg_yg=(Da.initial.sub.sub(l).x_y_new).^0.5;
                 Da.initial.sub.sub(l).xd_y=[1./Da.initial.sub.sub(l).x_y_new(:,1) Da.initial.sub.sub(l).x_y_new(:,2)];
                 Da.initial.sub.sub(l).x_yd=[Da.initial.sub.sub(l).x_y_new(:,1) 1./Da.initial.sub.sub(l).x_y_new(:,2)];
                 Da.initial.sub.sub(l).xg_y=[(Da.initial.sub.sub(l).x_y_new(:,1)).^0.5  Da.initial.sub.sub(l).x_y_new(:,2)];
                 Da.initial.sub.sub(l).x_yg=[Da.initial.sub.sub(l).x_y_new(:,1) (Da.initial.sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.initial.sub.sub(l).xd_yg=[1./Da.initial.sub.sub(l).x_y_new(:,1) (Da.initial.sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.initial.sub.sub(l).xg_yd=[(Da.initial.sub.sub(l).x_y_new(:,1)).^0.5 1./Da.initial.sub.sub(l).x_y_new(:,2)];
end 

% fitting 

    bb=0.02; % a constant for the Formula optimization
    
    

             for l=1:length(Da.initial.C)
                 for z=1:20
                     
                     if length(Da.initial.sub.sub(l).x_y_new)<=10
                       
                         Da.initial.sub.sub(l).fit(z).F=0;
                     elseif z<=8
                         
                         [Da.initial.sub.sub(l).fit(z).F,Da.initial.sub.sub(l).fit(z).Rsq]=fit(Da.initial.sub.sub(l).x_y_new,Da.initial.sub.sub(l).f,poly(z,:));
                        
                         
                         Da.initial.sub.sub(l).fit(z).poly=['poly_liner' num2str(poly(z,:))];
                     elseif z>8&&z<=11
                         [Da.initial.sub.sub(l).fit(z).F,Da.initial.sub.sub(l).fit(z).Rsq]=fit(Da.initial.sub.sub(l).xd_yd,Da.initial.sub.sub(l).f,poly1(z-8,:));
                         Da.initial.sub.sub(l).fit(z).poly=['poly_xd_yd' num2str(poly1(z-8,:))];
                     elseif z>11&&z<=14
                         [Da.initial.sub.sub(l).fit(z).F,Da.initial.sub.sub(l).fit(z).Rsq]=fit(Da.initial.sub.sub(l).xg_yg,Da.initial.sub.sub(l).f,poly1(z-11,:));
                         Da.initial.sub.sub(l).fit(z).poly=['poly_xg_yg' num2str(poly1(z-11,:))];
                     elseif z==15
                         [Da.initial.sub.sub(l).fit(z).F,Da.initial.sub.sub(l).fit(z).Rsq]=fit(Da.initial.sub.sub(l).xd_y,Da.initial.sub.sub(l).f,poly1(z-12,:));
                         Da.initial.sub.sub(l).fit(z).poly=['poly_xd_y' num2str(poly1(z-12,:))];
                     elseif z==16
                         [Da.initial.sub.sub(l).fit(z).F,Da.initial.sub.sub(l).fit(z).Rsq]=fit(Da.initial.sub.sub(l).x_yd,Da.initial.sub.sub(l).f,poly1(z-13,:));
                         Da.initial.sub.sub(l).fit(z).poly=['poly_x_yd' num2str(poly1(z-13,:))];
                     elseif z==17
                         [Da.initial.sub.sub(l).fit(z).F,Da.initial.sub.sub(l).fit(z).Rsq]=fit(Da.initial.sub.sub(l).xg_y,Da.initial.sub.sub(l).f,poly1(z-14,:));
                         Da.initial.sub.sub(l).fit(z).poly=['poly_xg_y' num2str(poly1(z-14,:))];
                     elseif z==18
                         [Da.initial.sub.sub(l).fit(z).F,Da.initial.sub.sub(l).fit(z).Rsq]=fit(Da.initial.sub.sub(l).x_yg,Da.initial.sub.sub(l).f,poly1(z-15,:));
                         Da.initial.sub.sub(l).fit(z).poly=['poly_x_yg' num2str(poly1(z-15,:))];
                     elseif z==19
                         [Da.initial.sub.sub(l).fit(z).F,Da.initial.sub.sub(l).fit(z).Rsq]=fit(Da.initial.sub.sub(l).xd_yg,Da.initial.sub.sub(l).f,poly1(z-16,:));
                         Da.initial.sub.sub(l).fit(z).poly=['poly_xd_yg' num2str(poly1(z-16,:))];
                     else
                         [Da.initial.sub.sub(l).fit(z).F,Da.initial.sub.sub(l).fit(z).Rsq]=fit(Da.initial.sub.sub(l).xg_yd,Da.initial.sub.sub(l).f,poly1(z-17,:));
                         Da.initial.sub.sub(l).fit(z).poly=['poly_xg_yd' num2str(poly1(z-17,:))];
                 
                         
                     end
                     Da.initial.sub.sub(l).fit(z).cofi=confint(Da.initial.sub.sub(l).fit(z).F);
                     Da.initial.sub.sub(l).fit(z).rsquare=Da.initial.sub.sub(l).fit(z).Rsq.rsquare;
                     Da.initial.sub.sub(l).fit(z).determ= Da.initial.sub.sub(l).fit(z).rsquare-bb*width(Da.initial.sub.sub(l).fit(z).cofi);
                     
                     % Da.initial.sub.sub(l).fit(z).determ is a number
                     % reflects the quality of the fitting formula, the
                     % Rsquare and the Number of terms of polynomial are
                     % combined to represent the quality, high quality is
                     % obtained from the high Rsquare and low number of
                     % terms, bb is a constant to make the Orders of 
                     % magnitude of the number of the terms is equal to
                     % Rsquare
                     
                 end
             end
 
% Formula optimization

  
             for l=1:length(Da.initial.C)
                 for z=1:20
                     Da.initial.sub.sub(l).determ_who(z,1)=Da.initial.sub.sub(l).fit(z).determ;
               
                     if Da.initial.sub.sub(l).fit(z).determ==max(Da.initial.sub.sub(l).determ_who)
                   
                        Da.initial.sub.sub(l).F_s=Da.initial.sub.sub(l).fit(z).F;
                        Da.initial.sub.sub(l).poly_s=Da.initial.sub.sub(l).fit(z).poly;
                        Da.initial.sub.sub(l).rsquare_s=Da.initial.sub.sub(l).fit(z).rsquare;
             
                     end 
                 end
             end
             
             
             
% formula values for the comparison with smooth differnetial calculation

% Da.initial.s(i).sub_param(j)

% converting the independent varibles formats

 for i=1:length(noise)
     for j=1:length(sub_param)
             for l=1:length(Da.initial.s(i).sub_param(j).C)
                 Da.initial.s(i).sub_param(j).sub.sub(l).xd_yd=1./Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new;
                 Da.initial.s(i).sub_param(j).sub.sub(l).xg_yg=(Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new).^0.5;
                 Da.initial.s(i).sub_param(j).sub.sub(l).xd_y=[1./Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,1) Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,2)];
                 Da.initial.s(i).sub_param(j).sub.sub(l).x_yd=[Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,1) 1./Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,2)];
                 Da.initial.s(i).sub_param(j).sub.sub(l).xg_y=[(Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,1)).^0.5  Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,2)];
                 Da.initial.s(i).sub_param(j).sub.sub(l).x_yg=[Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,1) (Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.initial.s(i).sub_param(j).sub.sub(l).xd_yg=[1./Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,1) (Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.initial.s(i).sub_param(j).sub.sub(l).xg_yd=[(Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,1)).^0.5 1./Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new(:,2)];
             end
     end
 end

% fitting
    bb=0.02;
   


 for i=1:length(noise)
     for j=1:length(sub_param)       
             for l=1:length(Da.initial.s(i).sub_param(j).C)
                 for z=1:20
                     
                     if length(Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new)<=10
                         
                         Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F=0;
                     elseif z<=8
                         
                         [Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F,Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).sub_param(j).sub.sub(l).x_y_new,Da.initial.s(i).sub_param(j).sub.sub(l).f,poly(z,:));
                      
                         
                         Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_liner' num2str(poly(z,:))];
                     elseif z>8&&z<=11
                         [Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F,Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).sub_param(j).sub.sub(l).xd_yd,Da.initial.s(i).sub_param(j).sub.sub(l).f,poly1(z-8,:));
                         Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xd_yd' num2str(poly1(z-8,:))];
                     elseif z>11&&z<=14
                         [Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F,Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).sub_param(j).sub.sub(l).xg_yg,Da.initial.s(i).sub_param(j).sub.sub(l).f,poly1(z-11,:));
                         Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xg_yg' num2str(poly1(z-11,:))];
                     elseif z==15
                         [Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F,Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).sub_param(j).sub.sub(l).xd_y,Da.initial.s(i).sub_param(j).sub.sub(l).f,poly1(z-12,:));
                         Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xd_y' num2str(poly1(z-12,:))];
                     elseif z==16
                         [Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F,Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).sub_param(j).sub.sub(l).x_yd,Da.initial.s(i).sub_param(j).sub.sub(l).f,poly1(z-13,:));
                         Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_x_yd' num2str(poly1(z-13,:))];
                     elseif z==17
                         [Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F,Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).sub_param(j).sub.sub(l).xg_y,Da.initial.s(i).sub_param(j).sub.sub(l).f,poly1(z-14,:));
                         Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xg_y' num2str(poly1(z-14,:))];
                     elseif z==18
                         [Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F,Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).sub_param(j).sub.sub(l).x_yg,Da.initial.s(i).sub_param(j).sub.sub(l).f,poly1(z-15,:));
                         Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_x_yg' num2str(poly1(z-15,:))];
                     elseif z==19
                         [Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F,Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).sub_param(j).sub.sub(l).xd_yg,Da.initial.s(i).sub_param(j).sub.sub(l).f,poly1(z-16,:));
                         Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xd_yg' num2str(poly1(z-16,:))];
                     else
                         [Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F,Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).sub_param(j).sub.sub(l).xg_yd,Da.initial.s(i).sub_param(j).sub.sub(l).f,poly1(z-17,:));
                         Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xg_yd' num2str(poly1(z-17,:))];
                 
                         
                     end
                     Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).cofi=confint(Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F);
                     Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).rsquare=Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).Rsq.rsquare;
                     Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).determ= Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).rsquare-bb*width(Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).cofi);
                 end
             end
     end
 end
       
    
% Formula optimization

for i=1:length(noise)
     for j=1:length(sub_param)  
             for l=1:length(Da.initial.s(i).sub_param(j).C)
                 for z=1:20
                     Da.initial.s(i).sub_param(j).sub.sub(l).determ_who(z,1)=Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).determ;
               
                     if Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).determ==max(Da.initial.s(i).sub_param(j).sub.sub(l).determ_who)
                   
                        Da.initial.s(i).sub_param(j).sub.sub(l).F_s=Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).F;
                        Da.initial.s(i).sub_param(j).sub.sub(l).poly_s=Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).poly;
                        Da.initial.s(i).sub_param(j).sub.sub(l).rsquare_s=Da.initial.s(i).sub_param(j).sub.sub(l).fit(z).rsquare;
             
                     end 
                 end
             end
     end
end

% Da.initial.s(i).M(j)
% converting the indenpendent variables formats

 for i=1:length(noise)
     for j=1:length(M)
             for l=1:length(Da.initial.s(i).M(j).C)
                 Da.initial.s(i).M(j).sub.sub(l).xd_yd=1./Da.initial.s(i).M(j).sub.sub(l).x_y_new;
                 Da.initial.s(i).M(j).sub.sub(l).xg_yg=(Da.initial.s(i).M(j).sub.sub(l).x_y_new).^0.5;
                 Da.initial.s(i).M(j).sub.sub(l).xd_y=[1./Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,1) Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,2)];
                 Da.initial.s(i).M(j).sub.sub(l).x_yd=[Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,1) 1./Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,2)];
                 Da.initial.s(i).M(j).sub.sub(l).xg_y=[(Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,1)).^0.5  Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,2)];
                 Da.initial.s(i).M(j).sub.sub(l).x_yg=[Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,1) (Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.initial.s(i).M(j).sub.sub(l).xd_yg=[1./Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,1) (Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.initial.s(i).M(j).sub.sub(l).xg_yd=[(Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,1)).^0.5 1./Da.initial.s(i).M(j).sub.sub(l).x_y_new(:,2)];
             end
     end
 end

% fitting 
    bb=0.02;
 


 for i=1:length(noise)
     for j=1:length(M)       
             for l=1:length(Da.initial.s(i).M(j).C)
                 for z=1:20
                     
                     if length(Da.initial.s(i).M(j).sub.sub(l).x_y_new)<=10
                         
                         Da.initial.s(i).M(j).sub.sub(l).fit(z).F=0;
                     elseif z<=8
                         
                         [Da.initial.s(i).M(j).sub.sub(l).fit(z).F,Da.initial.s(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).M(j).sub.sub(l).x_y_new,Da.initial.s(i).M(j).sub.sub(l).f,poly(z,:));
                      
                         
                         Da.initial.s(i).M(j).sub.sub(l).fit(z).poly=['poly_liner' num2str(poly(z,:))];
                     elseif z>8&&z<=11
                         [Da.initial.s(i).M(j).sub.sub(l).fit(z).F,Da.initial.s(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).M(j).sub.sub(l).xd_yd,Da.initial.s(i).M(j).sub.sub(l).f,poly1(z-8,:));
                         Da.initial.s(i).M(j).sub.sub(l).fit(z).poly=['poly_xd_yd' num2str(poly1(z-8,:))];
                     elseif z>11&&z<=14
                         [Da.initial.s(i).M(j).sub.sub(l).fit(z).F,Da.initial.s(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).M(j).sub.sub(l).xg_yg,Da.initial.s(i).M(j).sub.sub(l).f,poly1(z-11,:));
                         Da.initial.s(i).M(j).sub.sub(l).fit(z).poly=['poly_xg_yg' num2str(poly1(z-11,:))];
                     elseif z==15
                         [Da.initial.s(i).M(j).sub.sub(l).fit(z).F,Da.initial.s(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).M(j).sub.sub(l).xd_y,Da.initial.s(i).M(j).sub.sub(l).f,poly1(z-12,:));
                         Da.initial.s(i).M(j).sub.sub(l).fit(z).poly=['poly_xd_y' num2str(poly1(z-12,:))];
                     elseif z==16
                         [Da.initial.s(i).M(j).sub.sub(l).fit(z).F,Da.initial.s(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).M(j).sub.sub(l).x_yd,Da.initial.s(i).M(j).sub.sub(l).f,poly1(z-13,:));
                         Da.initial.s(i).M(j).sub.sub(l).fit(z).poly=['poly_x_yd' num2str(poly1(z-13,:))];
                     elseif z==17
                         [Da.initial.s(i).M(j).sub.sub(l).fit(z).F,Da.initial.s(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).M(j).sub.sub(l).xg_y,Da.initial.s(i).M(j).sub.sub(l).f,poly1(z-14,:));
                         Da.initial.s(i).M(j).sub.sub(l).fit(z).poly=['poly_xg_y' num2str(poly1(z-14,:))];
                     elseif z==18
                         [Da.initial.s(i).M(j).sub.sub(l).fit(z).F,Da.initial.s(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).M(j).sub.sub(l).x_yg,Da.initial.s(i).M(j).sub.sub(l).f,poly1(z-15,:));
                         Da.initial.s(i).M(j).sub.sub(l).fit(z).poly=['poly_x_yg' num2str(poly1(z-15,:))];
                     elseif z==19
                         [Da.initial.s(i).M(j).sub.sub(l).fit(z).F,Da.initial.s(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).M(j).sub.sub(l).xd_yg,Da.initial.s(i).M(j).sub.sub(l).f,poly1(z-16,:));
                         Da.initial.s(i).M(j).sub.sub(l).fit(z).poly=['poly_xd_yg' num2str(poly1(z-16,:))];
                     else
                         [Da.initial.s(i).M(j).sub.sub(l).fit(z).F,Da.initial.s(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.initial.s(i).M(j).sub.sub(l).xg_yd,Da.initial.s(i).M(j).sub.sub(l).f,poly1(z-17,:));
                         Da.initial.s(i).M(j).sub.sub(l).fit(z).poly=['poly_xg_yd' num2str(poly1(z-17,:))];
                 
                         
                     end
                     Da.initial.s(i).M(j).sub.sub(l).fit(z).cofi=confint(Da.initial.s(i).M(j).sub.sub(l).fit(z).F);
                     Da.initial.s(i).M(j).sub.sub(l).fit(z).rsquare=Da.initial.s(i).M(j).sub.sub(l).fit(z).Rsq.rsquare;
                     Da.initial.s(i).M(j).sub.sub(l).fit(z).determ= Da.initial.s(i).M(j).sub.sub(l).fit(z).rsquare-bb*width(Da.initial.s(i).M(j).sub.sub(l).fit(z).cofi);
                 end
             end
     end
 end
       
    
% formula optimization

for i=1:length(noise)
     for j=1:length(M)  
             for l=1:length(Da.initial.s(i).M(j).C)
                 for z=1:20
                     Da.initial.s(i).M(j).sub.sub(l).determ_who(z,1)=Da.initial.s(i).M(j).sub.sub(l).fit(z).determ;
               
                     if Da.initial.s(i).M(j).sub.sub(l).fit(z).determ==max(Da.initial.s(i).M(j).sub.sub(l).determ_who)
                   
                        Da.initial.s(i).M(j).sub.sub(l).F_s=Da.initial.s(i).M(j).sub.sub(l).fit(z).F;
                        Da.initial.s(i).M(j).sub.sub(l).poly_s=Da.initial.s(i).M(j).sub.sub(l).fit(z).poly;
                        Da.initial.s(i).M(j).sub.sub(l).rsquare_s=Da.initial.s(i).M(j).sub.sub(l).fit(z).rsquare;
             
                     end 
                 end
             end
     end
end


%% smooth differential calculation

% Da.s_noise(i).sub_param(j)

% converting independent variables formats

 for i=1:length(noise)
     for j=1:length(sub_param)
             for l=1:length(Da.s_noise(i).sub_param(j).C)
                 Da.s_noise(i).sub_param(j).sub.sub(l).xd_yd=1./Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new;
                 Da.s_noise(i).sub_param(j).sub.sub(l).xg_yg=(Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new).^0.5;
                 Da.s_noise(i).sub_param(j).sub.sub(l).xd_y=[1./Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,1) Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,2)];
                 Da.s_noise(i).sub_param(j).sub.sub(l).x_yd=[Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,1) 1./Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,2)];
                 Da.s_noise(i).sub_param(j).sub.sub(l).xg_y=[(Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,1)).^0.5  Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,2)];
                 Da.s_noise(i).sub_param(j).sub.sub(l).x_yg=[Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,1) (Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.s_noise(i).sub_param(j).sub.sub(l).xd_yg=[1./Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,1) (Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.s_noise(i).sub_param(j).sub.sub(l).xg_yd=[(Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,1)).^0.5 1./Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new(:,2)];
             end
     end
 end

% fitting
    bb=0.02;
   


 for i=1:length(noise)
     for j=1:length(sub_param)       
             for l=1:length(Da.s_noise(i).sub_param(j).C)
                 for z=1:20
                     
                     if length(Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new)<=10
                         
                         Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F=0;
                     elseif z<=8
                         
                         [Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F,Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).sub_param(j).sub.sub(l).x_y_new,Da.s_noise(i).sub_param(j).sub.sub(l).f,poly(z,:));
                         
                         Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_liner' num2str(poly(z,:))];
                     elseif z>8&&z<=11
                         [Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F,Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).sub_param(j).sub.sub(l).xd_yd,Da.s_noise(i).sub_param(j).sub.sub(l).f,poly1(z-8,:));
                         Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xd_yd' num2str(poly1(z-8,:))];
                     elseif z>11&&z<=14
                         [Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F,Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).sub_param(j).sub.sub(l).xg_yg,Da.s_noise(i).sub_param(j).sub.sub(l).f,poly1(z-11,:));
                         Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xg_yg' num2str(poly1(z-11,:))];
                     elseif z==15
                         [Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F,Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).sub_param(j).sub.sub(l).xd_y,Da.s_noise(i).sub_param(j).sub.sub(l).f,poly1(z-12,:));
                         Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xd_y' num2str(poly1(z-12,:))];
                     elseif z==16
                         [Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F,Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).sub_param(j).sub.sub(l).x_yd,Da.s_noise(i).sub_param(j).sub.sub(l).f,poly1(z-13,:));
                         Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_x_yd' num2str(poly1(z-13,:))];
                     elseif z==17
                         [Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F,Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).sub_param(j).sub.sub(l).xg_y,Da.s_noise(i).sub_param(j).sub.sub(l).f,poly1(z-14,:));
                         Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xg_y' num2str(poly1(z-14,:))];
                     elseif z==18   
                         [Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F,Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).sub_param(j).sub.sub(l).x_yg,Da.s_noise(i).sub_param(j).sub.sub(l).f,poly1(z-15,:));
                         Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_x_yg' num2str(poly1(z-15,:))];
                     elseif z==19
                         [Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F,Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).sub_param(j).sub.sub(l).xd_yg,Da.s_noise(i).sub_param(j).sub.sub(l).f,poly1(z-16,:));
                         Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xd_yg' num2str(poly1(z-16,:))];
                     else
                         [Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F,Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).sub_param(j).sub.sub(l).xg_yd,Da.s_noise(i).sub_param(j).sub.sub(l).f,poly1(z-17,:));
                         Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).poly=['poly_xg_yd' num2str(poly1(z-17,:))];
                 
                         
                     end
                     Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).cofi=confint(Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F);
                     Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).rsquare=Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).Rsq.rsquare;
                     Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).determ= Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).rsquare-bb*width(Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).cofi);
                 end
             end
     end
 end
       
    
% formula optimization

for i=1:length(noise)
     for j=1:length(sub_param)  
             for l=1:length(Da.s_noise(i).sub_param(j).C)
                 for z=1:20
                     Da.s_noise(i).sub_param(j).sub.sub(l).determ_who(z,1)=Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).determ;
               
                     if Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).determ==max(Da.s_noise(i).sub_param(j).sub.sub(l).determ_who)
                   
                        Da.s_noise(i).sub_param(j).sub.sub(l).F_s=Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).F;
                        Da.s_noise(i).sub_param(j).sub.sub(l).poly_s=Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).poly;
                        Da.s_noise(i).sub_param(j).sub.sub(l).rsquare_s=Da.s_noise(i).sub_param(j).sub.sub(l).fit(z).rsquare;
             
                     end 
                 end
             end
     end
end

% Da.s_noise(i).M(k)

% converting independent variables formats

 for i=1:length(noise)
     for j=1:length(M)
             for l=1:length(Da.s_noise(i).M(j).C)
                 Da.s_noise(i).M(j).sub.sub(l).xd_yd=1./Da.s_noise(i).M(j).sub.sub(l).x_y_new;
                 Da.s_noise(i).M(j).sub.sub(l).xg_yg=(Da.s_noise(i).M(j).sub.sub(l).x_y_new).^0.5;
                 Da.s_noise(i).M(j).sub.sub(l).xd_y=[1./Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,1) Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,2)];
                 Da.s_noise(i).M(j).sub.sub(l).x_yd=[Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,1) 1./Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,2)];
                 Da.s_noise(i).M(j).sub.sub(l).xg_y=[(Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,1)).^0.5  Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,2)];
                 Da.s_noise(i).M(j).sub.sub(l).x_yg=[Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,1) (Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.s_noise(i).M(j).sub.sub(l).xd_yg=[1./Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,1) (Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.s_noise(i).M(j).sub.sub(l).xg_yd=[(Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,1)).^0.5 1./Da.s_noise(i).M(j).sub.sub(l).x_y_new(:,2)];
             end
     end
 end

% fitting 
    bb=0.02;



 for i=1:length(noise)
     for j=1:length(M)       
             for l=1:length(Da.s_noise(i).M(j).C)
                 for z=1:20
                     
                     if length(Da.s_noise(i).M(j).sub.sub(l).x_y_new)<=10
                         
                         Da.s_noise(i).M(j).sub.sub(l).fit(z).F=0;
                     elseif z<=8
                         
                         [Da.s_noise(i).M(j).sub.sub(l).fit(z).F,Da.s_noise(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).M(j).sub.sub(l).x_y_new,Da.s_noise(i).M(j).sub.sub(l).f,poly(z,:));
                         
                         
                         Da.s_noise(i).M(j).sub.sub(l).fit(z).poly=['poly_liner' num2str(poly(z,:))];
                     elseif z>8&&z<=11
                         [Da.s_noise(i).M(j).sub.sub(l).fit(z).F,Da.s_noise(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).M(j).sub.sub(l).xd_yd,Da.s_noise(i).M(j).sub.sub(l).f,poly1(z-8,:));
                         Da.s_noise(i).M(j).sub.sub(l).fit(z).poly=['poly_xd_yd' num2str(poly1(z-8,:))];
                     elseif z>11&&z<=14
                         [Da.s_noise(i).M(j).sub.sub(l).fit(z).F,Da.s_noise(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).M(j).sub.sub(l).xg_yg,Da.s_noise(i).M(j).sub.sub(l).f,poly1(z-11,:));
                         Da.s_noise(i).M(j).sub.sub(l).fit(z).poly=['poly_xg_yg' num2str(poly1(z-11,:))];
                     elseif z==15
                         [Da.s_noise(i).M(j).sub.sub(l).fit(z).F,Da.s_noise(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).M(j).sub.sub(l).xd_y,Da.s_noise(i).M(j).sub.sub(l).f,poly1(z-12,:));
                         Da.s_noise(i).M(j).sub.sub(l).fit(z).poly=['poly_xd_y' num2str(poly1(z-12,:))];
                     elseif z==16
                         [Da.s_noise(i).M(j).sub.sub(l).fit(z).F,Da.s_noise(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).M(j).sub.sub(l).x_yd,Da.s_noise(i).M(j).sub.sub(l).f,poly1(z-13,:));
                         Da.s_noise(i).M(j).sub.sub(l).fit(z).poly=['poly_x_yd' num2str(poly1(z-13,:))];
                     elseif z==17
                         [Da.s_noise(i).M(j).sub.sub(l).fit(z).F,Da.s_noise(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).M(j).sub.sub(l).xg_y,Da.s_noise(i).M(j).sub.sub(l).f,poly1(z-14,:));
                         Da.s_noise(i).M(j).sub.sub(l).fit(z).poly=['poly_xg_y' num2str(poly1(z-14,:))];
                     elseif z==18
                         [Da.s_noise(i).M(j).sub.sub(l).fit(z).F,Da.s_noise(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).M(j).sub.sub(l).x_yg,Da.s_noise(i).M(j).sub.sub(l).f,poly1(z-15,:));
                         Da.s_noise(i).M(j).sub.sub(l).fit(z).poly=['poly_x_yg' num2str(poly1(z-15,:))];
                     elseif z==19
                         [Da.s_noise(i).M(j).sub.sub(l).fit(z).F,Da.s_noise(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).M(j).sub.sub(l).xd_yg,Da.s_noise(i).M(j).sub.sub(l).f,poly1(z-16,:));
                         Da.s_noise(i).M(j).sub.sub(l).fit(z).poly=['poly_xd_yg' num2str(poly1(z-16,:))];
                     else
                         [Da.s_noise(i).M(j).sub.sub(l).fit(z).F,Da.s_noise(i).M(j).sub.sub(l).fit(z).Rsq]=fit(Da.s_noise(i).M(j).sub.sub(l).xg_yd,Da.s_noise(i).M(j).sub.sub(l).f,poly1(z-17,:));
                         Da.s_noise(i).M(j).sub.sub(l).fit(z).poly=['poly_xg_yd' num2str(poly1(z-17,:))];
                 
                         
                     end
                     Da.s_noise(i).M(j).sub.sub(l).fit(z).cofi=confint(Da.s_noise(i).M(j).sub.sub(l).fit(z).F);
                     Da.s_noise(i).M(j).sub.sub(l).fit(z).rsquare=Da.s_noise(i).M(j).sub.sub(l).fit(z).Rsq.rsquare;
                     Da.s_noise(i).M(j).sub.sub(l).fit(z).determ= Da.s_noise(i).M(j).sub.sub(l).fit(z).rsquare-bb*width(Da.s_noise(i).M(j).sub.sub(l).fit(z).cofi);
                 end
             end
     end
 end
       
    
% formual optimization

for i=1:length(noise)
     for j=1:length(M)  
             for l=1:length(Da.s_noise(i).M(j).C)
                 for z=1:20
                     Da.s_noise(i).M(j).sub.sub(l).determ_who(z,1)=Da.s_noise(i).M(j).sub.sub(l).fit(z).determ;
               
                     if Da.s_noise(i).M(j).sub.sub(l).fit(z).determ==max(Da.s_noise(i).M(j).sub.sub(l).determ_who)
                   
                        Da.s_noise(i).M(j).sub.sub(l).F_s=Da.s_noise(i).M(j).sub.sub(l).fit(z).F;
                        Da.s_noise(i).M(j).sub.sub(l).poly_s=Da.s_noise(i).M(j).sub.sub(l).fit(z).poly;
                        Da.s_noise(i).M(j).sub.sub(l).rsquare_s=Da.s_noise(i).M(j).sub.sub(l).fit(z).rsquare;
             
                     end 
                 end
             end
     end
end
%% machine learning

% converting
for i=1:length(noise)
    for j=1:length(smooth)
        
             for l=1:length(Da.m_noise(i).smooth(j).C)
                 Da.m_noise(i).smooth(j).sub.sub(l).xd_yd=1./Da.m_noise(i).smooth(j).sub.sub(l).x_y_new;
                 Da.m_noise(i).smooth(j).sub.sub(l).xg_yg=(Da.m_noise(i).smooth(j).sub.sub(l).x_y_new).^0.5;
                 Da.m_noise(i).smooth(j).sub.sub(l).xd_y=[1./Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,1) Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)];
                 Da.m_noise(i).smooth(j).sub.sub(l).x_yd=[Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,1) 1./Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)];
                 Da.m_noise(i).smooth(j).sub.sub(l).xg_y=[(Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,1)).^0.5  Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)];
                 Da.m_noise(i).smooth(j).sub.sub(l).x_yg=[Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,1) (Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.m_noise(i).smooth(j).sub.sub(l).xd_yg=[1./Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,1) (Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.m_noise(i).smooth(j).sub.sub(l).xg_yd=[(Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,1)).^0.5 1./Da.m_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)];
             end 
        
    end
end 




% fitting
    bb=0.02;
    
for i=1:length(noise)
    for j=1:length(smooth)
         
             for l=1:length(Da.m_noise(i).smooth(j).C)
                 for z=1:20
                     
                     if length(Da.m_noise(i).smooth(j).sub.sub(l).x_y_new)<=10
                         
                         Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F=0;
                     elseif z<=8
                         
                         [Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.m_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.m_noise(i).smooth(j).sub.sub(l).x_y_new,Da.m_noise(i).smooth(j).sub.sub(l).f,poly(z,:));
                         
                         
                         Da.m_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_liner' num2str(poly(z,:))];
                     elseif z>8&&z<=11
                         [Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.m_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.m_noise(i).smooth(j).sub.sub(l).xd_yd,Da.m_noise(i).smooth(j).sub.sub(l).f,poly1(z-8,:));
                         Da.m_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xd_yd' num2str(poly1(z-8,:))];
                     elseif z>11&&z<=14
                         [Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.m_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.m_noise(i).smooth(j).sub.sub(l).xg_yg,Da.m_noise(i).smooth(j).sub.sub(l).f,poly1(z-11,:));
                         Da.m_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xg_yg' num2str(poly1(z-11,:))];
                     elseif z==15
                         [Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.m_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.m_noise(i).smooth(j).sub.sub(l).xd_y,Da.m_noise(i).smooth(j).sub.sub(l).f,poly1(z-12,:));
                         Da.m_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xd_y' num2str(poly1(z-12,:))];
                     elseif z==16
                         [Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.m_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.m_noise(i).smooth(j).sub.sub(l).x_yd,Da.m_noise(i).smooth(j).sub.sub(l).f,poly1(z-13,:));
                         Da.m_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_x_yd' num2str(poly1(z-13,:))];
                     elseif z==17
                         [Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.m_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.m_noise(i).smooth(j).sub.sub(l).xg_y,Da.m_noise(i).smooth(j).sub.sub(l).f,poly1(z-14,:));
                         Da.m_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xg_y' num2str(poly1(z-14,:))];
                     elseif z==18
                         [Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.m_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.m_noise(i).smooth(j).sub.sub(l).x_yg,Da.m_noise(i).smooth(j).sub.sub(l).f,poly1(z-15,:));
                         Da.m_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_x_yg' num2str(poly1(z-15,:))];
                     elseif z==19
                         [Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.m_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.m_noise(i).smooth(j).sub.sub(l).xd_yg,Da.m_noise(i).smooth(j).sub.sub(l).f,poly1(z-16,:));
                         Da.m_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xd_yg' num2str(poly1(z-16,:))];
                     else
                         [Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.m_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.m_noise(i).smooth(j).sub.sub(l).xg_yd,Da.m_noise(i).smooth(j).sub.sub(l).f,poly1(z-17,:));
                         Da.m_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xg_yd' num2str(poly1(z-17,:))];
                 
                         
                     end
                     Da.m_noise(i).smooth(j).sub.sub(l).fit(z).cofi=confint(Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F);
                     Da.m_noise(i).smooth(j).sub.sub(l).fit(z).rsquare=Da.m_noise(i).smooth(j).sub.sub(l).fit(z).Rsq.rsquare;
                     Da.m_noise(i).smooth(j).sub.sub(l).fit(z).determ= Da.m_noise(i).smooth(j).sub.sub(l).fit(z).rsquare-bb*width(Da.m_noise(i).smooth(j).sub.sub(l).fit(z).cofi);
                 end
             end
         
    end
end
% optimization
for i=1:length(noise)
    for j=1:length(smooth)
       
             for l=1:length(Da.m_noise(i).smooth(j).C)
                 for z=1:20
                     Da.m_noise(i).smooth(j).sub.sub(l).determ_who(z,1)=Da.m_noise(i).smooth(j).sub.sub(l).fit(z).determ;
               
                     if Da.m_noise(i).smooth(j).sub.sub(l).fit(z).determ==max(Da.m_noise(i).smooth(j).sub.sub(l).determ_who)
                   
                        Da.m_noise(i).smooth(j).sub.sub(l).F_s=Da.m_noise(i).smooth(j).sub.sub(l).fit(z).F;
                        Da.m_noise(i).smooth(j).sub.sub(l).poly_s=Da.m_noise(i).smooth(j).sub.sub(l).fit(z).poly;
                        Da.m_noise(i).smooth(j).sub.sub(l).rsquare_s=Da.m_noise(i).smooth(j).sub.sub(l).fit(z).rsquare;
                     end 
                 end
             end
        
    end
end

%% linear interpolation

% when noise0.4，smooth9，clustering results are empty，so a Judgement
% "if isempty(Da.l_noise(i).smooth(j).sub.sub(l).x)
% continue
% end"
% is added

% converting
for i=1:length(noise)
    for j=1:length(smooth)
        
             for l=1:length(Da.l_noise(i).smooth(j).C)
                 Da.l_noise(i).smooth(j).sub.sub(l).xd_yd=1./Da.l_noise(i).smooth(j).sub.sub(l).x_y_new;
                 Da.l_noise(i).smooth(j).sub.sub(l).xg_yg=(Da.l_noise(i).smooth(j).sub.sub(l).x_y_new).^0.5;
                 Da.l_noise(i).smooth(j).sub.sub(l).xd_y=[1./Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,1) Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)];
                 Da.l_noise(i).smooth(j).sub.sub(l).x_yd=[Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,1) 1./Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)];
                 Da.l_noise(i).smooth(j).sub.sub(l).xg_y=[(Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,1)).^0.5  Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)];
                 Da.l_noise(i).smooth(j).sub.sub(l).x_yg=[Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,1) (Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.l_noise(i).smooth(j).sub.sub(l).xd_yg=[1./Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,1) (Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)).^0.5];
                 Da.l_noise(i).smooth(j).sub.sub(l).xg_yd=[(Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,1)).^0.5 1./Da.l_noise(i).smooth(j).sub.sub(l).x_y_new(:,2)];
             end 
        
    end
end 




% fitting 
    bb=0.02;
    
for i=1:length(noise)
    for j=1:length(smooth)
         
             for l=1:length(Da.l_noise(i).smooth(j).C)
                 for z=1:20
                     
                     if length(Da.l_noise(i).smooth(j).sub.sub(l).x_y_new)<=10
                     continue
                     end
                         Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F=0;
                     if z<=8
                         
                         [Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.l_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.l_noise(i).smooth(j).sub.sub(l).x_y_new,Da.l_noise(i).smooth(j).sub.sub(l).f,poly(z,:));
                         
                         
                         Da.l_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_liner' num2str(poly(z,:))];
                     elseif z>8&&z<=11
                         [Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.l_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.l_noise(i).smooth(j).sub.sub(l).xd_yd,Da.l_noise(i).smooth(j).sub.sub(l).f,poly1(z-8,:));
                         Da.l_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xd_yd' num2str(poly1(z-8,:))];
                     elseif z>11&&z<=14
                         [Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.l_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.l_noise(i).smooth(j).sub.sub(l).xg_yg,Da.l_noise(i).smooth(j).sub.sub(l).f,poly1(z-11,:));
                         Da.l_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xg_yg' num2str(poly1(z-11,:))];
                     elseif z==15
                         [Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.l_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.l_noise(i).smooth(j).sub.sub(l).xd_y,Da.l_noise(i).smooth(j).sub.sub(l).f,poly1(z-12,:));
                         Da.l_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xd_y' num2str(poly1(z-12,:))];
                     elseif z==16
                         [Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.l_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.l_noise(i).smooth(j).sub.sub(l).x_yd,Da.l_noise(i).smooth(j).sub.sub(l).f,poly1(z-13,:));
                         Da.l_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_x_yd' num2str(poly1(z-13,:))];
                     elseif z==17
                         [Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.l_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.l_noise(i).smooth(j).sub.sub(l).xg_y,Da.l_noise(i).smooth(j).sub.sub(l).f,poly1(z-14,:));
                         Da.l_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xg_y' num2str(poly1(z-14,:))];
                     elseif z==18
                         [Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.l_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.l_noise(i).smooth(j).sub.sub(l).x_yg,Da.l_noise(i).smooth(j).sub.sub(l).f,poly1(z-15,:));
                         Da.l_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_x_yg' num2str(poly1(z-15,:))];
                     elseif z==19
                         [Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.l_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.l_noise(i).smooth(j).sub.sub(l).xd_yg,Da.l_noise(i).smooth(j).sub.sub(l).f,poly1(z-16,:));
                         Da.l_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xd_yg' num2str(poly1(z-16,:))];
                     else
                         [Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F,Da.l_noise(i).smooth(j).sub.sub(l).fit(z).Rsq]=fit(Da.l_noise(i).smooth(j).sub.sub(l).xg_yd,Da.l_noise(i).smooth(j).sub.sub(l).f,poly1(z-17,:));
                         Da.l_noise(i).smooth(j).sub.sub(l).fit(z).poly=['poly_xg_yd' num2str(poly1(z-17,:))];
                 
                         
                     end
                     if isempty(Da.l_noise(i).smooth(j).sub.sub(l).x)
                    continue
                     end
                     Da.l_noise(i).smooth(j).sub.sub(l).fit(z).cofi=confint(Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F);
                     Da.l_noise(i).smooth(j).sub.sub(l).fit(z).rsquare=Da.l_noise(i).smooth(j).sub.sub(l).fit(z).Rsq.rsquare;
                     Da.l_noise(i).smooth(j).sub.sub(l).fit(z).determ= Da.l_noise(i).smooth(j).sub.sub(l).fit(z).rsquare-bb*width(Da.l_noise(i).smooth(j).sub.sub(l).fit(z).cofi);
                 end
             end
         
    end
end
% optamization
for i=1:length(noise)
    for j=1:length(smooth)
       
             for l=1:length(Da.l_noise(i).smooth(j).C)
                 for z=1:20
                     
                    if isempty(Da.l_noise(i).smooth(j).sub.sub(l).x)
                    continue
                     end 
                
                     Da.l_noise(i).smooth(j).sub.sub(l).determ_who(z,1)=Da.l_noise(i).smooth(j).sub.sub(l).fit(z).determ;
               
                     if Da.l_noise(i).smooth(j).sub.sub(l).fit(z).determ==max(Da.l_noise(i).smooth(j).sub.sub(l).determ_who)
                   
                        Da.l_noise(i).smooth(j).sub.sub(l).F_s=Da.l_noise(i).smooth(j).sub.sub(l).fit(z).F;
                        Da.l_noise(i).smooth(j).sub.sub(l).poly_s=Da.l_noise(i).smooth(j).sub.sub(l).fit(z).poly;
                        Da.l_noise(i).smooth(j).sub.sub(l).rsquare_s=Da.l_noise(i).smooth(j).sub.sub(l).fit(z).rsquare;
                     end 
                 end
             end
        
    end
end

save Da_clust_fit.mat Da
