function [V,C,XY]=VoronoiLimit(varargin)
% --------------------------------------------------------------
% [V,C,XY]=VoronoiLimit(x,y,additional_variables)
% Provides the Voronoi decomposition of a set of (x,y) data, but with all
% vertices limited to the boundary created by the data itself.
% V contains the vertices of all voronoi-cells and C contains all vertices for each individual
% voronoi-cell. That is: V(C{ij},:) will give you the vertices of the ij'th cell, corresponding 
% to the ij'th data point, in two columns. The order of polygon vertices are given in a counter-clockwise
% manner. XY contains updated xy coordinates as limited by any input boundaries.
%
% Addition variables:
% 'bs_ext':  Describe an arbitrary external boundary by giving an xy matrix of size (n,1) where n are number of vertices.
% 'bs_int':  Describe any number of arbitrary internal boundaries by giving a cell structure of M xy matrices of size
%            (Ni,1) where M are number of internal boundaries and Ni are number of vertices in the respective boundaries. 
%            When defining a single boundary the algorithm automatically converts the given matrix into a cell structure. 
%            (See examples below).
% 'figure':  output figure ('on'/'off'. Default='on').
%
% EXAMPLES
% Example 0: Run with no input to see graphical example.
%
% Example 1: External and one internal boundary
%            bs_int=[.2 .8 .8 .2;.6 .6 .2 .2]';
%            bs_ext=[-.8 .5 1.80 -.8;-.05 1.7 -.05 -.05]';
%            [X,Y] = meshgrid(-.5:.1:1.5, 0.1:.1:1.4);
%            X=X(:);Y=Y(:);
%            [V,C,XY]=VoronoiLimit(X,Y,'bs_ext',bs_ext,'bs_int',bs_int);
%
% Example 2: No external boundary and two internal boundaries
%            bs_int=cell(2,1);
%            bs_int{1}=[.2 .8 .8 .2;.6 .6 .2 .2]';
%            bs_int{2}=[.2 .5 .7 .2;1 1 .7 .7]';
%            [X,Y] = meshgrid(-.5:.1:1.5, 0.1:.1:1.4);
%            X=X(:);Y=Y(:);
%            [V,C,XY]=VoronoiLimit(X,Y,'bs_int',bs_int);
% 
% Example 3: As above but without figure output
%            [V,C,XY]=VoronoiLimit(X,Y,'bs_int',bs_int,'figure','off');
%
% Requires the Polybool function of the mapping toolbox to run!.
% I recommend the tool 'export_fig' for exporting figures. It can be found here:
% http://www.mathworks.com/matlabcentral/fileexchange/23629-export-fig
%
% Made by: Jakob Sievers (PhD, Arctic Geophysics)
% Contact: Jakob.Sievers@gmail.com
% --------------------------------------------------------------
warning('off','map:polygon:noExternalContours');
version=[3 0 2 2];

%% SETUP

% USERTYPE
[~,hostname]=system('hostname');
user=0;
if strcmp(hostname(1:end-1),'DESKTOP-PC4MSAH') || strcmp(hostname(1:end-1),'Sievers')
    user=1;
end


% DETERMINE IF A MORE RECENT VERSION OF OOT IS AVAILABLE ON THE MATHWORKS FILEEXCHANGE
try
    onlinedata = webread('http://se.mathworks.com/matlabcentral/fileexchange/34428-voronoilimit');
    try_ver=1;
catch me
    try_ver=0;
end
if try_ver==1
    try % using hardcoded version (faster)
        ixVersion=strfind(onlinedata,'version ');
        onlinedata=onlinedata(ixVersion+8:ixVersion+80);
        ixsspan=strfind(onlinedata,'</span>');
        onlinedata=onlinedata(1:ixsspan(1)-1);
        ixsp=strfind(onlinedata,'(');
        onlinedata=onlinedata(1:ixsp-2);
        ixp=strfind(onlinedata,'.');
        version_online=sum([str2double(onlinedata(1:ixp(1)-1))*1e3 str2double(onlinedata(ixp(1)+1:ixp(2)-1))*1e2  str2double(onlinedata(ixp(2)+1:ixp(3)-1))*1e1 str2double(onlinedata(ixp(3)+1:end))]);
        version=sum([version(1)*1e3 version(2)*1e2 version(3)*1e1 version(4)]);
        if version_online>version
            warndlg(['NOTE: A more recent version (ver. ',num2str(version_online(1,1)),'.',num2str(version_online(1,2)),'.',num2str(version_online(1,3)),'.',num2str(version_online(1,4)),') of VoronoiLimit is now available on the mathworks fileexchange. Currently running version ',num2str(version(1,1)),'.',num2str(version(1,2)),'.',num2str(version(1,3)),'.',num2str(version(1,4))])
            pause(2)
        end
    catch me
        if user==1
            warndlg('CRASH #1: HARDCODED version of VoronoiLimit_ver script! Update hardcoded/online script!')
            pause(2)
        end
        try %download/unzip most recent script to determine online version (updated in case Mathworks has changed its website and hardcoded version crashes)
            outfilename = websave([pwd,filesep,'Current_version_VoronoiLimit_DONOTDELETE.m'],'https://www.dropbox.com/s/daqya2vv3hh9x9d/Current_version_VoronoiLimit_DONOTDELETE.m?dl=1');
            Current_version_VoronoiLimit_DONOTDELETE(version);
            delete(outfilename)
        catch me2
            if user==1
                warndlg('CRASH #2: ONLINE version of VoronoiLimit_ver script! Update hardcoded/online script!')
                pause(2)
            end
        end
    end
end


%% ALGORITHM BEGINNING
try
    if nargin==0
        val=600;
        x=rand(val,1);
        y=rand(val,1);
        XY=unique([x,y],'rows');
        x=XY(:,1);
        y=XY(:,2);
        
        %EXTERNAL BOUNDARIES
        ButtonName = questdlg('Choose external boundary example:','','Irregular pentagon', 'Triangle', 'Irregular pentagon');
        switch ButtonName
            case 'Irregular pentagon'
                bs_ext=[min(x)-std(x)/2 min(x)-std(x)/2 0.65 max(x)+std(x)/2 max(x)+std(x)/2 min(x)-std(x)/2;min(y)-std(y)/2 max(y)+std(y)/2 max(y)+std(y)/2 .65 min(y)-std(y)/2 min(y)-std(y)/2]';
            case 'Triangle'
                bs_ext=[-.8 .5 1.80 -.8;-.05 1.7 -.05 -.05]';
        end
        
        %INTERNAL OBJECTS
        bs_int=cell(3,1);
        rat=1.5;
        % rectangle
        bs_int{1}=[min(x)+(std(x)*rat) min(x)+(std(x)*rat) max(x)-std(x) max(x)-std(x) min(x)+(std(x)*rat);min(y)+std(y) max(y)-std(y) max(y)-std(y) min(y)+std(y) min(y)+std(y)]';
        t = linspace(0,2*pi)';
        % circle 1
        xc=.25;
        yc=.7;
        rad=.10;
        bs_int{2}=[(cos(t)*rad)+xc (sin(t)*rad)+yc];
        % circle 2
        xc=.4;
        yc=.3;
        rad=.16;
        bs_int{3}=[(cos(t)*rad)+xc (sin(t)*rad)+yc];
        fig='on';
    else
        x=varargin{1}(:);
        y=varargin{2}(:);
        XY=unique([x,y],'rows');
        x=XY(:,1);
        y=XY(:,2);
        for ii=3:2:nargin
            if strcmp(varargin{ii},'bs_ext')
                bs_ext=varargin{ii+1};
            elseif strcmp(varargin{ii},'bs_int')
                bs_int=varargin{ii+1};
                if ~iscell(bs_int)
                    bs_int_cell=cell(1);
                    bs_int_cell{1}=bs_int;
                    bs_int=bs_int_cell;
                end
            elseif strcmp(varargin{ii},'figure')
                fig=varargin{ii+1};
            end
        end
        if exist('fig','var')==0
            fig='on';
        end
    end
    
    
    x=x(:);
    y=y(:);
    rx=[min(x) max(x)];
    ry=[min(y) max(y)];
    
    bnd=[rx ry]; %data bounds
    crs=double([bnd(1) bnd(4);bnd(2) bnd(4);bnd(2) bnd(3);bnd(1) bnd(3);bnd(1) bnd(4)]); %data boundary corners
    
    if exist('bs_ext','var')
        crs=bs_ext;
    end
    crslim=[min(crs(:,1)) max(crs(:,1)) min(crs(:,2)) max(crs(:,2))];
    crslim_pol=[crslim(1) crslim(3)
        crslim(1) crslim(4)
        crslim(2) crslim(4)
        crslim(2) crslim(3)
        crslim(1) crslim(3)];
    if ~any(size(x)==1) || ~any(size(y)==1) || numel(x)==1 || numel(y)==1
        disp('Input vectors should be single rows or columns')
        return
    end
    
    
    dt=delaunayTriangulation(x(:),y(:));
    [V,C]=voronoiDiagram(dt);   % This structure gives vertices for each individual point but is missing all "infinite" vertices
    [vx,vy]=voronoi(x,y);       % This structure includes the "infinite" vertices but provides everything as a completele list of vertices rather than individually for each point.
    % Hence we need to add the missing vertices from vx and vy to the V and C structure.
    vxyl=[vx(:) vy(:)];
    
    
    
    % combine identical V-entries
    epsx=eps(max(abs(crs(:))))*10;
    ctr=0;
    Vun=V;
    while ctr<size(Vun,1)-1
        ctr=ctr+1;
        ix=find(abs(Vun(ctr+1:end,1)-Vun(ctr,1))<epsx & abs(Vun(ctr+1:end,2)-Vun(ctr,2))<epsx);
        if ~isempty(ix)
            Vun(ix+ctr,:)=[];
        end
    end
    for ih=1:length(C)
        for ii=1:length(C{ih})
            if ~isinf(V(C{ih}(ii),1))
                C{ih}(ii)=find(abs(V(C{ih}(ii),1)-Vun(:,1))<epsx & abs(V(C{ih}(ii),2)-Vun(:,2))<epsx);
            end
        end
    end
    V=Vun;
    
    
    %values provided by voronoiDiagram may be an infinitesimal fraction off
    %relative to those provided by "voronoi". Hence we need to make sure all
    %values in V are similar to those located in vxyl.
    vals=unique(vxyl(:));
    for ik=1:length(vals)
        df=abs(V(:)-vals(ik));
        if any(df<=epsx)
            V(df<=epsx)=vals(ik);
        end
    end
    lV0=length(V);
    
    
    %Find missing points that should be added to existing V/C structure
    %     xix=ones(size(vx));
    xix=ones(size(vx));
    for ii=1:length(vxyl)
        %         ch=1;
        fix=find(abs(V(:,1)-vxyl(ii,1))<epsx);
        if ~isempty(fix)
            if any(abs(V(fix,2)-vxyl(ii,2))<epsx)
                xix(ii)=0;
                %                 plot(vxyl(ii,1),vxyl(ii,2),'or','markersize',15)
                %             else
                %                 ch=0;
            end
        else
            %             ch=0;
        end
        %         if ch==0
        %             plot(vxyl(ii,1),vxyl(ii,2),'og','markersize',12)
        %         end
    end
    mix=find(xix==1)./2; %index of missing values
    lmix=length(mix);
    mvx=vx(2,mix); %missing vx
    mvy=vy(2,mix); %missing vy
    mv=[mvx',mvy'];
    cpx=vx(1,mix); %connector point x (connects between outer missing points and inner existing points in V/C)
    cpy=vy(1,mix); %connector point y (connects between outer missing points and inner existing points in V/C)
    
    ctr=0;
    mv2=[];
    cpVixt=cell(lmix,1); %connector points, index in V structure
    for ii=1:lmix
        if any(abs(V(:,1)-cpx(ii))<epsx & abs(V(:,2)-cpy(ii))<epsx)
            cpVixt{ii}=find(abs(V(:,1)-cpx(ii))<epsx & abs(V(:,2)-cpy(ii))<epsx);
            lval=length(cpVixt{ii});
            if lval==1
                ctr=ctr+1;
                mv2(ctr,:)=mv(ii,:);
            elseif lval>1
                ctr=ctr+1;
                mv2(ctr:ctr+lval-1,:)=[ones(lval,1).*mv(ii,1) ones(lval,1).*mv(ii,2)];
                ctr=ctr+lval-1;
            end
        end
    end
    cpVixt=cell2mat(cpVixt);
    
    V=[V;mv2]; %add points to V structure
    
    
    %remove spurious double-entries in C/V structure
    epsx=eps(max(abs(crs(:))))*10;
    for ih=1:length(C)
        VC=V(C{ih},:);
        TMAT=true(size(VC,1));
        for ii=1:size(VC,1)
            for ij=1:size(VC,1)
                TMAT(ii,ij)=all(abs(VC(ii,:)-VC(ij,:))<=epsx);
            end
        end
        TMAT=TMAT-eye(size(TMAT));
        if any(TMAT(:)==1)
            if all(abs(V(C{ih}(1),:)-V(C{ih}(end),:))<=epsx)
                C{ih}(end)=[];
            end
            ctr=0;
            while ctr<length(C{ih})-1
                ctr=ctr+1;
                if all(abs(V(C{ih}(ctr),:)-V(C{ih}(ctr+1),:))<=epsx)
                    C{ih}(ctr+1)=[];
                end
            end
        end
    end
    
    
    %Addition-routine: addition of missing points (mvx,mvy) to individual vertice-polygons (C)
    totalbounds=[min([min(V(~isinf(V(:,1)),1)),min(x),min(crs(:,1)),min(mv2(:,1))]) max([max(V(~isinf(V(:,1)),1)),max(x),max(crs(:,1)),max(mv2(:,1))]) min([min(V(~isinf(V(:,1)),2)),min(y),min(crs(:,2)),min(mv2(:,2))]) max([max(V(~isinf(V(:,1)),2)),max(y),max(crs(:,2)),max(mv2(:,2))])];
    tbdx=diff(totalbounds(1:2));
    tbdy=diff(totalbounds(3:4));
    expandX=.2;
    extremebounds=[totalbounds(1)-(tbdx*expandX) totalbounds(2)+(tbdx*expandX) totalbounds(3)-(tbdy*expandX) totalbounds(4)+(tbdy*expandX)];
    exb_vertices=[extremebounds(1) extremebounds(4)
        extremebounds(2) extremebounds(4)
        extremebounds(2) extremebounds(3)
        extremebounds(1) extremebounds(3)];
    for ij=1:length(C)
        if any(C{ij}==1)
            C{ij}(C{ij}==1)=[];
            ixa=find(cpVixt==C{ij}(1));
            ixb=find(cpVixt==C{ij}(end));
            
            if (length(ixa)>=2 || length(ixb)>=2)
                % DO THE PROPOSED POINTS OBEY THE FOLLOWING RULES?
                % 1: The resulting shape must contain the original centroid
                %    (0=does not contain centroid. 1=contains centroid)
                % 2: None of the end-sections may cross any existing section
                %    (0=crossing. 1=no crossing)
                polygon=[V(C{ij},1),V(C{ij},2)];
                if any(isinf(polygon(:)))
                    polygon(isinf(sum(polygon,2)),:)=[];
                end
                ixok=false(length(ixa),length(ixb),5);
                for ic1=1:length(ixa)
                    for ic2=1:length(ixb)
                        for ic3=0:4
                            poly=[[V(lV0+ixa(ic1),1);polygon(:,1);V(lV0+ixb(ic2),1)],[V(lV0+ixa(ic1),2);polygon(:,2);V(lV0+ixb(ic2),2)]];
                            poly=unique(poly,'rows','stable');
                            if size(poly,1)>2
                                if ic3>0 %with external point
                                    poly=[[V(lV0+ixa(ic1),1);polygon(:,1);V(lV0+ixb(ic2),1);exb_vertices(ic3,1)],[V(lV0+ixa(ic1),2);polygon(:,2);V(lV0+ixb(ic2),2);exb_vertices(ic3,2)]];
                                    poly=unique(poly,'rows','stable');
                                end
                                k = convhull(poly(:,1),poly(:,2));
                                A = polyarea(poly(:,1),poly(:,2));
                                B = polyarea(poly(k,1),poly(k,2));
                                if abs(A-B)<epsx %convex hull? 
                                    ixok(ic1,ic2,ic3+1)=inpolygon(x(ij),y(ij),poly(:,1),poly(:,2)); %centroid in polygon?
                                end
%                                 if centroidIN(ic1,ic2,ic3+1)==true
%                                     [xi,~] = polyxpoly(polygon(:,1),polygon(:,2),[V(lV0+ixa(ic1),1);V(lV0+ixb(ic2),1)],[V(lV0+ixa(ic1),2);V(lV0+ixb(ic2),2)]);
%                                     sectionCROSS(ic1,ic2,ic3+1)=isempty(xi);
%                                 end
                            end
                        end
                    end
                end
                selection=any(ixok,3);
                if any(selection(:)==1)
                    [selixa,selixb]=ind2sub(size(selection),find(selection==1));
                    ixa=ixa(unique(selixa));
                    ixb=ixb(unique(selixb));
                end
            end
            
            
            % special case
            if length(C{ij})==1 && isequal(ixa,ixb)
                C{ij}=[lV0+ixa(1),C{ij},lV0+ixa(2)];
            elseif length(ixa)==1 && length(ixb)==1
                C{ij}=[lV0+ixa,C{ij},lV0+ixb];
            elseif length(ixa)==2 && length(ixb)==1
                C{ij}=[C{ij},lV0+ixb];
                [~,minix]=min(sqrt((V(C{ij}(end),1)-V(lV0+ixa,1)).^2+(V(C{ij}(end),2)-V(lV0+ixa,2)).^2));
                C{ij}=[lV0+ixa(minix),C{ij}];
            elseif length(ixa)==1 && length(ixb)==2
                C{ij}=[lV0+ixa,C{ij}];
                [~,minix]=min(sqrt((V(C{ij}(1),1)-V(lV0+ixb,1)).^2+(V(C{ij}(1),2)-V(lV0+ixb,2)).^2));
                C{ij}=[C{ij},lV0+ixb(minix)];
            elseif length(ixa)==2 && length(ixb)==2
                dist1=sqrt((x(ij)-V(lV0+ixa,1)).^2+(y(ij)-V(lV0+ixa,2)).^2);
                dist2=sqrt((x(ij)-V(lV0+ixb,1)).^2+(y(ij)-V(lV0+ixb,2)).^2);
                if diff(dist1)==0 && diff(dist2)==0
                    minix1=1;
                    minix2=2;
                else
                    [~,minix1]=min(dist1);
                    [~,minix2]=min(dist2);
                end
                C{ij}=[lV0+ixa(minix1),C{ij},lV0+ixb(minix2)];
            end
        end
    end
    
    
    % Extend outer connections which do not extend beyond the user-given boundaries
    crsx=range(crs(:,1));
    crsy=range(crs(:,2));
    scale=10;
    for ij=1:length(C)
        LC=length(C{ij});
        RC=[1 2;
            LC LC-1];
        for ii=1:2 %open ends: left/right
            if C{ij}(RC(ii,1))>lV0
                inpol=inpolygon(V(C{ij}(RC(ii,1)),1),V(C{ij}(RC(ii,1)),2),crs(:,1),crs(:,2));
                if inpol
                    if V(C{ij}(RC(ii,1)),1)==V(C{ij}(RC(ii,2)),1) %points aligned vertically (polyfit cannot be used)
                        if V(C{ij}(RC(ii,1)),2)>V(C{ij}(RC(ii,2)),2) %point DIRECTLY above. Extend upward
                            V(C{ij}(RC(ii,1)),2)=max(crs(:,2))+crsy/scale;
                        else %point DIRECTLY below. Extend downward
                            V(C{ij}(RC(ii,1)),2)=min(crs(:,2))-crsy/scale;
                        end
                    else %extend using polyfit
                        plf=polyfit(V(C{ij}(RC(ii,:)),1),V(C{ij}(RC(ii,:)),2),1);
                        if V(C{ij}(RC(ii,1)),1)>V(C{ij}(RC(ii,2)),1) %extend point beyond RIGHT boundary
                            V(C{ij}(RC(ii,1)),1)=max(crs(:,1))+crsx/scale;
                            V(C{ij}(RC(ii,1)),2)=polyval(plf,V(C{ij}(RC(ii,1)),1));
                        else %extend point beyond LEFT boundary
                            V(C{ij}(RC(ii,1)),1)=min(crs(:,1))-crsx/scale;
                            V(C{ij}(RC(ii,1)),2)=polyval(plf,V(C{ij}(RC(ii,1)),1));
                        end
                    end
                end
            end
        end
    end
    
    
    
    %   Polybool for restriction of polygons to domain.
    %   Expand vertices when necessary!
    allVixinp=inpolygon(V(:,1),V(:,2),crs(:,1),crs(:,2)); %determine which points in V that are within the data boundaries.
    totalbounds=[min([min(V(~isinf(V(:,1)),1)),min(x),min(crs(:,1)),min(mv2(:,1))]) max([max(V(~isinf(V(:,1)),1)),max(x),max(crs(:,1)),max(mv2(:,1))]) min([min(V(~isinf(V(:,1)),2)),min(y),min(crs(:,2)),min(mv2(:,2))]) max([max(V(~isinf(V(:,1)),2)),max(y),max(crs(:,2)),max(mv2(:,2))])];
    tbdx=diff(totalbounds(1:2));
    tbdy=diff(totalbounds(3:4));
    expandX=1;
    extremebounds=[totalbounds(1)-(tbdx*expandX) totalbounds(2)+(tbdx*expandX) totalbounds(3)-(tbdy*expandX) totalbounds(4)+(tbdy*expandX)];
    
    
    Nint=4;
    exb_vertices_x=[linspace(extremebounds(1),extremebounds(2),Nint)';linspace(extremebounds(1),extremebounds(2),Nint)';ones(Nint,1)*extremebounds(1);ones(Nint,1)*extremebounds(2)];
    exb_vertices_y=[ones(Nint,1)*extremebounds(3);ones(Nint,1)*extremebounds(4);linspace(extremebounds(3),extremebounds(4),Nint)';linspace(extremebounds(3),extremebounds(4),Nint)'];
    exb_vertices=[exb_vertices_x exb_vertices_y];
    
%     exb_vertices=[extremebounds(1) extremebounds(4)
%         extremebounds(2) extremebounds(4)
%         extremebounds(2) extremebounds(3)
%         extremebounds(1) extremebounds(3)];
    
    
    % STEP 1: categorize and apply polybool on all polygons who contain vertices outside the boundaries, but does not cross the boundaries between the first and last point
    poly_ok=zeros(size(C)); %   0=ok
    %   1=vertices outside boundaries but no crossing of boundary lines (resolve now)
    %   2=vertices outside boundaries AND crossing of boundary lines (resolve later)
    for ij=1:length(C)
        if sum(allVixinp(C{ij}))~=length(C{ij})
            poly_ok(ij)=1;
            % Q: when drawing a line between the open ends of the polygon, does it intersect with the extreme (rectangle) data boundaries?
            % If so, connect the open ends to the extreme boundaries so that this is no longer the case.
            % The goal here is to expand the outer voronoi cells to include all of the domain of the given boundaries
            
            intersect=false(4,1);
            for ii=1:4
                [xip,~]=polyxpoly(crslim_pol(ii:ii+1,1),crslim_pol(ii:ii+1,2),V([C{ij}(1) C{ij}(end)],1),V([C{ij}(1) C{ij}(end)],2)); %intersections between lines
                if ~isempty(xip)
                    intersect(ii)=true;
                end
            end
            if any(intersect) %possibly expand outer points
                poly_ok(ij)=2;
            end
            
            if poly_ok(ij)==1
                poly_ok(ij)=0;
                [xb, yb] = polybool('intersection',crs(:,1),crs(:,2),V(C{ij},1),V(C{ij},2));
                %             [xb, yb] = polybool('intersection',crs(:,1),crs(:,2),V(C1{ij},1),V(C1{ij},2));
                ix=nan(1,length(xb));
                for il=1:length(xb)
                    if any(V(:,1)==xb(il)) && any(V(:,2)==yb(il))
                        ix1=find(V(:,1)==xb(il));
                        ix2=find(V(:,2)==yb(il));
                        for ib=1:length(ix1)
                            if any(ix1(ib)==ix2)
                                ix(il)=ix1(ib);
                            end
                        end
                        if isnan(ix(il))==1
                            lv=length(V);
                            V(lv+1,1)=xb(il);
                            V(lv+1,2)=yb(il);
                            allVixinp(lv+1)=1;
                            ix(il)=lv+1;
                        end
                    else
                        lv=length(V);
                        V(lv+1,1)=xb(il);
                        V(lv+1,2)=yb(il);
                        allVixinp(lv+1)=1;
                        ix(il)=lv+1;
                    end
                end
                C{ij}=ix;
            end
        end
    end
    
    
    % STEP 2: if any polygons remain evaluate whether by expanding them, they encroach on the territory of a neighboring polygon which has been accepted
    if any(poly_ok==2)
        ixpo=cell(2,1);
        for im=1:2  % im=1: run only the first three criteria to accept as many polygons based on this as possible.
            % im=2: run the remaining polygons with the final fourth criteria only
            ixpo{im}=find(poly_ok==2);
            if im==1
                diagnostics=zeros(size(exb_vertices,1)*size(exb_vertices,1)*5,length(ixpo{im}));
            elseif im==2
                diagnostics2=zeros(size(exb_vertices,1)*size(exb_vertices,1)*5,length(ixpo{im}));
                for in=1:length(ixpo{im})
                    diagnostics2(:,in)=diagnostics(:,ixpo{1}==ixpo{im}(in));
                end
                diagnostics=diagnostics2;
            end

            if im==2
                ixpo_new=ixpo{im};
            end
            for ik=1:length(ixpo{im})
                if im==2 
                    % Determine neighboring polygons of all relevant polygons.
                    % Iteratively sort and run these according to the highest ratio of neighboring polygons which have already been accepted.
                    neighbors=cell(size(ixpo_new));
                    neighbors_ok_ratio=nan(length(ixpo_new),3);
                    for ij=1:length(ixpo_new)
                        for ii=1:length(C{ixpo_new(ij)})
                            for il=1:length(C)
                                if any(C{il}==C{ixpo_new(ij)}(ii)) && il~=ixpo_new(ij)
                                    neighbors{ij}=[neighbors{ij};il];
                                end
                            end

                        end
                        neighbors{ij}=unique(neighbors{ij});
                        neighbors_ok_ratio(ij,:)=[sum(poly_ok(neighbors{ij})==0)/numel(neighbors{ij}) ixpo_new(ij) ij];
                    end
                    if length(ixpo_new)>1
                        neighbors_ok_ratio=flipud(sortrows(neighbors_ok_ratio));
                        neighbors1=cell(size(neighbors));
                        for ij=1:length(ixpo_new)
                            neighbors1{ij}=neighbors{neighbors_ok_ratio(ij,3)};
                        end
                        neighbors=neighbors1;
                        ixpo_new=neighbors_ok_ratio(:,2);
                    else
                        neighbors(neighbors_ok_ratio(:,2)~=ixpo_new)=[];
                    end
                end
                
                if im==1
                    ij=ixpo{im}(ik);
                elseif im==2
                    ij=ixpo_new(1);
                end
                
                % Q: when drawing a line between the open ends of the polygon, does it intersect with the extreme (rectangle) data boundaries?
                % If so, connect the open ends to the extreme boundaries so that this is no longer the case.
                % The goal here is to expand the outer voronoi cells to include all of the domain of the given boundaries
                % all combinations of connections between open ends and boundary limits are investigated to find the right one
                poly0=[V(C{ij},1),V(C{ij},2)];
                
                polylog=cell(size(exb_vertices,1)*size(exb_vertices,1)*5,1);
                ctr=0;
                for iv1=1:size(exb_vertices,1)     % extreme boundary vertices
                    for iv2=1:size(exb_vertices,1) % extreme boundary vertices
                        for iv3=0:4 % Optional (iv3=0) additional points (iv3=1:4)
                            ctr=ctr+1;
                            run=1;
                            if im==2 && (diagnostics(ctr,ik)==0 || isnan(diagnostics(ctr,ik)))
                                run=0;
                            end
                            %check all possible variations of connections between open ends and extreme boundary limits for the following traits:
                            % 1) Area of convexhull of points equals area of raw points (i.e. "clean" shape)
                            % 2) Does not contain any of the other centroids
                            % 3) A line drawn between the open points does not intersect with the boundaries (as above)
                            % 4) Does not encroach on the territory of any accepted (poly_ok==0) polygon
                            
                            % Define polygon
                            if run==1
                                if iv3==0
                                    poly=[exb_vertices(iv1,:);poly0;exb_vertices(iv2,:)];
                                else
                                    poly=[exb_vertices(iv1,:);poly0;exb_vertices(iv2,:);exb_vertices(iv3,:)];
                                end
                                poly=unique(poly,'rows','stable');
                                polylog{ctr}=poly;
                            end
                            
                            
                            % if ctr>1 -> check that unique case hasn't been run before
                            if ctr>1 && run==1
                                polytest=nan(ctr-1,1);
                                for ipt=1:length(polytest)
                                    polytest(ipt)=isequal(poly,polylog{ipt});
                                end
                                if any(polytest) %do not run again
                                    run=0;
                                    diagnostics(ctr,ik)=nan;
                                end
                            end
                            
                            
                            if run==1
                                % TEST 1: Area of convex hull
                                if im==1
                                    k = convhull(poly(:,1),poly(:,2));
                                    A = polyarea(poly(:,1),poly(:,2));
                                    B = polyarea(poly(k,1),poly(k,2));
                                    if abs(A-B)<epsx
                                        diagnostics(ctr,ik)=1;
                                    end
                                    
                                    
                                    % TEST 2: contains no other centroids
                                    if diagnostics(ctr,ik)==1
                                        xy=[x y];
                                        xy(ij,:)=[];
                                        IN1=inpolygon(xy(:,1),xy(:,2),poly(:,1),poly(:,2));
                                        IN2=inpolygon(x(ij),y(ij),poly(:,1),poly(:,2));
                                        if all(~IN1) && IN2==1
                                            diagnostics(ctr,ik)=1;
                                        else
                                            diagnostics(ctr,ik)=0;
                                        end
                                    end
                                    
                                    % TEST 3: line between open points does not intersect with boundaries (as above)
                                    if diagnostics(ctr,ik)==1
                                        
                                        %define "links"
                                        lp0=length(poly0);
                                        for il=1:length(poly)-lp0+1
                                            if isequal(poly(il:il+lp0-1,:),poly0)
                                               poly0ix=il;
                                            end
                                        end
                                        links=cell(2,1);
                                        if poly0ix>1
                                            links{1}=poly(1:poly0ix,:);
                                        end
                                        if poly0ix+lp0-1<length(poly)
                                            links{2}=poly(poly0ix+lp0-1:end,:);
                                        end
                                        
                                        
                                        intersect2=false(4,1);
                                        ilix_intersect=false(4,2);
                                        for ii=1:4
                                            %%% "links"
                                            for il=1:2
                                                if ~isempty(links{il})
%                                                     ilix_intersect(ii,il)=false(size(links{il},1)-1,1);
                                                    for ilix=1:size(links{il},1)-1
                                                        [xip,~]=polyxpoly(crslim_pol(ii:ii+1,1),crslim_pol(ii:ii+1,2),links{il}(ilix:ilix+1,1),links{il}(ilix:ilix+1,2)); %intersections between lines
                                                        if ~isempty(xip)
                                                            ilix_intersect(ii,il)=true;
                                                        end
                                                    end
                                                end
                                                
                                            end
                                            
                                            %%% outer points
                                            [xip,~]=polyxpoly(crslim_pol(ii:ii+1,1),crslim_pol(ii:ii+1,2),poly([1 end],1),poly([1 end],2)); %intersections between lines
                                            if ~isempty(xip)
                                                intersect2(ii)=true;
                                            end
                                        end
                                        if any(intersect2) || any(ilix_intersect(:))
                                            diagnostics(ctr,ik)=0;
                                        end
                                    end
                                end
                                
                                if im==2
                                    % TEST 4: Does not encroach on the territory of any accepted (poly_ok==0) polygon
                                    nb=neighbors{1};
%                                     nb=nb(poly_ok(nb)==0);
                                    if ~isempty(nb)
                                        overlap=false(size(nb));
                                        for in=1:length(nb)
                                            [xb,~] = polybool('intersection',V(C{nb(in)},1),V(C{nb(in)},2),poly(:,1),poly(:,2));
                                            if ~isempty(xb)
                                                overlap(in)=1;
                                            end
                                        end
                                        if sum(overlap)~=0
                                            diagnostics(ctr,ik)=0;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                ixok=find(diagnostics(:,ik)==1);
%                 if im==2 && ~isempty(ixok)
                if ~isempty(ixok)
                    polyfinal=polylog{ixok(1)};
                    
                    %add any new points to C/V structure
                    Ct=nan(1,size(polyfinal,1));
                    for ia=1:size(polyfinal,1)
                        vpf=nan(size(V,1),1);
                        for iv=1:size(V,1)
                            vpf(iv)=isequal(V(iv,:),polyfinal(ia,:));
                        end
                        if all(vpf==0) %add point
                            V=[V;polyfinal(ia,:)];
                            Ct(ia)=size(V,1);
                        else
                            Ct(ia)=find(vpf==1,1,'first');
                        end
                    end
                    C{ij}=Ct;
                    ixok=[];
                end
                if (im==1 && isempty(ixok)) || im==2
                    [xb, yb] = polybool('intersection',crs(:,1),crs(:,2),V(C{ij},1),V(C{ij},2));
                    ix=nan(1,length(xb));
                    for il=1:length(xb)
                        if any(V(:,1)==xb(il)) && any(V(:,2)==yb(il))
                            ix1=find(V(:,1)==xb(il));
                            ix2=find(V(:,2)==yb(il));
                            for ib=1:length(ix1)
                                if any(ix1(ib)==ix2)
                                    ix(il)=ix1(ib);
                                end
                            end
                            if isnan(ix(il))==1
                                lv=length(V);
                                V(lv+1,1)=xb(il);
                                V(lv+1,2)=yb(il);
                                allVixinp(lv+1)=1;
                                ix(il)=lv+1;
                            end
                        else
                            lv=length(V);
                            V(lv+1,1)=xb(il);
                            V(lv+1,2)=yb(il);
                            allVixinp(lv+1)=1;
                            ix(il)=lv+1;
                        end
                    end
                    C{ij}=ix;
                    poly_ok(ij)=0;
                end
                if im==2
                    ixpo_new(ixpo_new==ij)=[];
                end
            end
        end
    end
    isemp=false(size(C));
    for ij=1:length(C)
        if isempty(C{ij})
            isemp(ij)=true;
        end
    end
    if any(isemp)
        C(isemp)=[];
        XY(isemp,:)=[];
    end
    
    
    %adjust polygons to the presence of internal boundaries
    if exist('bs_int','var')
        isemp=false(length(C),length(bs_int));
        for ii=1:length(bs_int)
            V2=nan(length(V)*10,2);
            C2=cell(length(C),1);
            ctr=1;
            for ij=1:length(C)
                [pbx,pby]=polybool('subtraction',V(C{ij},1),V(C{ij},2),bs_int{ii}(:,1),bs_int{ii}(:,2));
                if ~isempty(pbx)
                    C2{ij}=(ctr:ctr+length(pbx)-1)';
                    C2{ij}=[C2{ij} ones(size(C2{ij}))*ij];
                    V2(ctr:ctr+length(pbx)-1,:)=[pbx pby];
                    ctr=ctr+length(pbx);
                end
            end
            V=V2(1:ctr-1,:);
            C=C2;
            for ij=1:length(C)
                if isempty(C{ij})
                    isemp(ij,ii)=true;
                else
                    C{ij}=(C{ij}(:,1))';
                end
            end
        end
        if any(any(isemp'))
            C(sum(isemp,2)~=0)=[];
            XY(sum(isemp,2)~=0,:)=[];
        end
    end
    
    
    %remove spurious double-entries in C/V structure
    epsx=eps(max(abs(V(unique(cell2mat(C'))))));
    for ih=1:length(C)
        VC=V(C{ih},:);
        TMAT=true(size(VC,1));
        for ii=1:size(VC,1)
            for ij=1:size(VC,1)
                TMAT(ii,ij)=all(abs(VC(ii,:)-VC(ij,:))<=epsx);
            end
        end
        TMAT=TMAT-eye(size(TMAT));
        if any(TMAT(:)==1)
            if all(abs(V(C{ih}(1),:)-V(C{ih}(end),:))<=epsx)
                C{ih}(end)=[];
            end
            ctr=0;
            while ctr<length(C{ih})-1
                ctr=ctr+1;
                if all(abs(V(C{ih}(ctr),:)-V(C{ih}(ctr+1),:))<=epsx)
                    C{ih}(ctr+1)=[];
                end
            end
        end
        C{ih}=C{ih}';
    end
    
    
    TMAT=cell(length(V)-1,1);
    Vt=V;
    idx1=(1:length(V))';
    idx2=(1:length(V))';
    for ii=1:length(V)-1
        Vt=[Vt(2:end,:);Vt(1,:)];
        idx2=[idx2(2:end);idx2(1)];
        TMATt=find(all(abs(V-Vt)<=epsx,2));
        TMAT{ii}=[idx1(TMATt) idx2(TMATt)];
    end
    TMATf=unique(sort(cell2mat(TMAT),2),'rows');
    if ~isempty(TMATf)
        for ii=1:size(TMATf,1)
            for ij=1:length(C)
                C{ij}(C{ij}==TMATf(ii,2))=TMATf(ii,1);
            end
        end
    end
    
    
    
    %remove V-entries which are now unused by C
    index_rem=true(size(V,1),1);
    Ctot=unique(cell2mat(C));
    Vn=V(Ctot,:);
    Vnix=find(any(isnan(Vn')));
    if ~isempty(Vnix)
        Ctot(Vnix)=[];
    end
    index_rem(Ctot)=false;
    index_rem=find(index_rem);
    while ~isempty(index_rem)
        for ij=1:length(C)
            ixf=find(C{ij}>index_rem(1));
            if ~isempty(ixf)
                C{ij}(ixf)=C{ij}(ixf)-1;
            end
        end
        V(index_rem(1),:)=[];
        index_rem=true(size(V,1),1);
        Ctot=unique(cell2mat(C));
        Vn=V(Ctot,:);
        Vnix=find(any(isnan(Vn')));
        if ~isempty(Vnix)
            Ctot(Vnix)=[];
        end
        index_rem(Ctot)=false;
        index_rem=find(index_rem);
    end
    
    %Check and repair cells that have been split into closed sub-cells by input boundaries
    Csplit=cell(length(C),1);
    XYsplit=cell(length(C),1);
    splitlog=false(length(C),1);
    for ij=1:length(C)
        [xClosed, yClosed] = closePolygonParts(V(C{ij},1),V(C{ij},2));
        if any(isnan(xClosed))
            splitlog(ij)=true;
            ix=find(~isnan(xClosed));
            diffix=diff(ix)>1;
            NUMcell=sum(isnan(xClosed))+1;
            Csplit{ij}=cell(NUMcell,1);
            XYsplit{ij}=nan(NUMcell,2);
            C_temp=C{ij};
            ix_begin=1;
            for ik=1:NUMcell
                cs_diffix=cumsum(diffix);
                if ik>1
                    ix_begin=2;
                end
                ix_end=find(cs_diffix>0,1,'first');
                if isempty(ix_end)
                    ix_end=length(xClosed);
                end
                Csplit{ij}{ik}=C_temp(ix_begin:ix_end);
                inpol=inpolygon(XY(ij,1),XY(ij,2),xClosed(ix_begin:ix_end),yClosed(ix_begin:ix_end));
                if inpol==0
                    XYsplit{ij}(ik,:)=[mean(xClosed(ix_begin:ix_end)) mean(yClosed(ix_begin:ix_end))];
                else
                    XYsplit{ij}(ik,:)=XY(ij,:);
                end
                if ik<NUMcell
                    C_temp(ix_begin:ix_end)=[];
                    diffix(ix_begin:ix_end)=[];
                    xClosed(ix_begin:ix_end)=[];
                    yClosed(ix_begin:ix_end)=[];
                end
            end
        end
    end
    if any(splitlog)
        ix_splitlog=find(splitlog);
        ix_splitlog0=ix_splitlog;
        for ij=1:length(ix_splitlog)
            if ix_splitlog(ij)==1
                C=[Csplit{ix_splitlog(ij)};C(2:end)];
                XY=[XYsplit{ix_splitlog(ij)};XY(2:end,:)];
            elseif ix_splitlog(ij)==length(C)
                C=[C(1:end-1);Csplit{ix_splitlog(ij)}];
                XY=[XY(1:end-1,:);XYsplit{ix_splitlog(ij)}];
            else
                C=[C(1:ix_splitlog(ij)-1);Csplit{ix_splitlog0(ij)};C(ix_splitlog(ij)+1:end)];
                XY=[XY(1:ix_splitlog(ij)-1,:);XYsplit{ix_splitlog0(ij)};XY(ix_splitlog(ij)+1:end,:)];
                if ij<length(ix_splitlog)
                    ix_splitlog(ij+1:end)=ix_splitlog(ij+1:end)+(length(Csplit{ix_splitlog0(ij)})-1);
                end
            end
        end
    end
    
    %ensure that all polygon vertex groups are given in counter-clockwise order
    for ih=1:length(C)
        if ispolycw(V(C{ih},1),V(C{ih},2))
            C{ih}=flipud(C{ih});
        end
    end
    
    
    %% create and output figure
    if exist('fig','var')
        if strcmp(fig,'on')
            
            %close polygons for the purpose of plotting
            C2=C;
            for ih=1:length(C2)
                if C2{ih}(1)~=C2{ih}(end)
                    C2{ih}=[C2{ih};C2{ih}(1)];
                end
            end
            
            figure
            set(gcf,'position',get(0,'screensize'),'color','w')
            set(gca,'box','on')
            hold on
            plot(x,y,'.k')
%             if any(splitlog)
%                 for ij=1:length(ix_splitlog0)
%                     plot(XYsplit{ix_splitlog0(ij)}(:,1),XYsplit{ix_splitlog0(ij)}(:,2),'*r')
%                     plot(XYsplit{ix_splitlog0(ij)}(:,1),XYsplit{ix_splitlog0(ij)}(:,2),'or','markersize',8)
%                 end
%             end
            voronoi(x,y)
            for id=1:length(C2)
                plot(V(C2{id},1),V(C2{id},2),'-r')
            end
            grid on
            axis tight
            axis square
            if nargin==0
                axis equal
            end
            ax=axis;
            dx=(ax(2)-ax(1))/10;
            dy=(ax(4)-ax(3))/10;
            axis([ax(1)-dx ax(2)+dx ax(3)-dy ax(4)+dy])
            title({'Original Voronoi Decomposition ({\color{blue}blue})';'New limited Voronoi Decomposition ({\color{red}red})'},'fontsize',16,'fontweight','bold')
            if exist('bs_int','var')
                for ii=1:length(bs_int)
                    text(mean(unique(bs_int{ii}(:,1))),mean(unique(bs_int{ii}(:,2))),num2str(ii),'fontsize',30,'fontweight','bold','horizontalalignment','center')
                end
            end
        end
    end
%         export_fig([pwd,'\VoronoiLimit_example.jpg'],'-r300');
    
catch me
    disp('stop')
end

end