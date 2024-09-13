function [List_equ,List_score,N_equ_gen] = gen_equ_right(x,Vec_Answer_c,N_Sides,Boxes_Index,Mat_Nrange,List_equ,List_score,N_equ_gen)
    Mat_Nrange(1,1)=1;
    value_ch=eval(char(Vec_Answer_c(1,1:x))); % solve the equation and save it to value_ch in the char format
    if (value_ch>=1) && (value_ch<inf); value_ch=num2str(value_ch);
    else; value_ch=''; end
    leng_value=length(value_ch); % count the digits of the result
    if (leng_value==N_Sides(1,2)) &&... % the number of digits equals to the number of blank on the right side 
        sum(value_ch=='.',2)==0 % value_ch does not include point
        for i=1:leng_value
            Card_at_hand = value_ch(1,i);
            loc_Card_at_hand = 2+str2double(Card_at_hand);
            loc_blank_considered=(x+1+i);
            if Boxes_Index(loc_Card_at_hand,loc_blank_considered)
                Vec_Answer_c(1,loc_blank_considered)=Card_at_hand;
                Mat_Nrange(loc_Card_at_hand,1)=Mat_Nrange(loc_Card_at_hand,1)+1;
                % to avoid considering the card at hand any longer for the remaining blanks.
                if Mat_Nrange(loc_Card_at_hand,1)==Mat_Nrange(loc_Card_at_hand,3) 
                    Boxes_Index(loc_Card_at_hand,:)=false;
                end
            elseif Vec_Answer_c(1,loc_blank_considered) ~= Card_at_hand
                return;
            end
        end
        %Vec_Answer_c(1)=="8"&&Vec_Answer_c(2)=="-"&&Vec_Answer_c(3)=="9"&&Vec_Answer_c(4)=="+"&&Vec_Answer_c(5)=="6"&&Vec_Answer_c(6)=="+"&&Vec_Answer_c(7)=="4"&&Vec_Answer_c(8)=="2"
        %Vec_Answer_c(1)=="8"&&Vec_Answer_c(2)=="9"&&Vec_Answer_c(3)=="+"&&Vec_Answer_c(4)=="2"&&Vec_Answer_c(5)=="0"&&Vec_Answer_c(6)=="-"&&Vec_Answer_c(7)=="4"&&Vec_Answer_c(8)=="7"
        if sum((Mat_Nrange(:,1)<Mat_Nrange(:,2))+(Mat_Nrange(:,1)>Mat_Nrange(:,3)),1)==0
            %Horray & Save
            %Vec_Answer_c
            List_equ=[List_equ; Vec_Answer_c];
            ind_uncertainty=Mat_Nrange(:,2)<Mat_Nrange(:,3);
            ind_score=zeros(length(Vec_Answer_c),1);
            vec_dif=Mat_Nrange(ind_uncertainty,1)-Mat_Nrange(ind_uncertainty,2);
            ind_score(ind_uncertainty,1)=double(vec_dif>0);
            vec_dif(vec_dif==0,1)=1;
            ind_score(ind_uncertainty,1)=ind_score(ind_uncertainty,1)./vec_dif;% give a penalty to duplicated values
            ind_score(12:end)=ind_score(12:end)*1.5; % impose heavier weight on operators
            List_score=[List_score;sum(ind_score,1)];
            N_equ_gen=N_equ_gen+1;
        end
    end
end