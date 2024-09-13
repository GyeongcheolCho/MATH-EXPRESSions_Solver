 function [Vec_Answer,ind_search,Boxes_Index,Mat_Nrange] = updateInfo(result,Vec_Answer,ind_search,Boxes_Index,Mat_Nrange,Vec_Answer_xm1,Vec_Cards,N_CardType)
    loc_red = find(result==0);
    loc_lime = find(result==1);
    loc_green = find(result==2);    
    ind_colors=zeros(N_CardType,3);
    Mat_Nrange(:,[1,2])=0;
    % Need to update (Vec_Answer,ind_search,Boxes_Index,Mat_Nrange) given objects above

% For example, [89+20-47=62]
%     Step1:    9+6*124=753
%              [11100121100]
%     Step2:    8-9+6+42=47
%              [21111021201]
    % For green
    ind_search(1,loc_green)=false;
    Boxes_Index(:,loc_green)=false;
    loc_final_equ=0;
    for i=1:length(loc_green)
        ind_Card_considered=contains(Vec_Cards,Vec_Answer_xm1(1,loc_green(i)));   
        ind_colors(ind_Card_considered,3)=ind_colors(ind_Card_considered,3)+1;
        %Boxes_Index(loc_Card_considered,loc_green(i))=true;
        Mat_Nrange(ind_Card_considered,[1,2])=Mat_Nrange(ind_Card_considered,[1,2])+[1,1];
        Vec_Answer(1,loc_green(i))=Vec_Answer_xm1(1,loc_green(i));
        if ind_Card_considered(1)==1
            loc_final_equ=loc_green(i);
        end
    end
    % For lime
    for i=1:length(loc_lime)
        ind_Card_considered=contains(Vec_Cards,Vec_Answer_xm1(1,loc_lime(i)));  
        ind_colors(ind_Card_considered,2)=ind_colors(ind_Card_considered,2)+1;
        Boxes_Index(ind_Card_considered,loc_lime(i))=false;
        Mat_Nrange(ind_Card_considered,2)=Mat_Nrange(ind_Card_considered,2)+1;
    end
    % For red
    for i=1:length(loc_red)
        ind_Card_considered=contains(Vec_Cards,Vec_Answer_xm1(1,loc_red(i)));   
        ind_colors(ind_Card_considered,1)=ind_colors(ind_Card_considered,1)+1;
        N_dupl=sum(ind_colors(ind_Card_considered,2:3),2);
        if N_dupl==0
            Boxes_Index(ind_Card_considered,:)=false;
            Mat_Nrange(ind_Card_considered,3)=0;
        else
            Boxes_Index(ind_Card_considered,loc_red(i))=false;
            Mat_Nrange(ind_Card_considered,3)=N_dupl;
        end
    end
    %
    for i=1:N_CardType
        if (Mat_Nrange(i,1)==Mat_Nrange(i,2))&&(Mat_Nrange(i,1)==Mat_Nrange(i,3))
            Boxes_Index(i,:)=false;
        end
    end
    % For equality
    if Mat_Nrange(1,1)==1
        Boxes_Index(1,:)=false;
        Boxes_Index(1,loc_final_equ)=true;
        Mat_Nrange(1,[1,2,3])=1;
    end