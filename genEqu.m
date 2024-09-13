function [List_equ,List_score,N_equ_gen,N_equ_try]= genEqu_v1(x,Vec_Answer_xm1,ind_search,Boxes_Index,Mat_Nrange,Vec_Cards,N_CardType,N_Sides,Max_equ,Max_try,List_equ,List_score,N_equ_gen,N_equ_try)
% Vec_Answer_c = The combination of cards that is currently considered     
    if x==1
        order_search=[12:N_CardType,11:-1:2];
    else
        Previous_value=Vec_Answer_xm1(1,x-1);
        num_value=str2double(Previous_value);
        if ~isnan(num_value)
            loc_in_Vec_Cards=num_value+2;
            if     loc_in_Vec_Cards==11; order_bk_number=[10:-1:2,11];
            elseif loc_in_Vec_Cards==2;  order_bk_number=11:-1:2;
            else;  order_bk_number=[(loc_in_Vec_Cards-1):-1:2,11:-1:(loc_in_Vec_Cards+1),loc_in_Vec_Cards];
            end
            order_search=[12:N_CardType,order_bk_number];
        else
            order_search=[12:N_CardType,11:-1:2];
        end
    end
    if ind_search(x)
        for yy=1:(N_CardType-1)       
            y=order_search(1,yy);
            Vec_Answer_c=Vec_Answer_xm1;
            flag_double_oper=false;                   
            if Boxes_Index(y,x) % if the card at (y,x) is not on the red line/blacked out
                Card_at_hand = Vec_Cards(y); % Pick up a card at (y,x)
                Vec_Answer_c(1,x)=Card_at_hand; % Put the card at (1,x) of vec_Answer_c.
                loc_Card_at_hand=y; % identify the location of the card in Vec_Cards
                Mat_Nrange_given_y=Mat_Nrange;
                Boxes_Index_given_y=Boxes_Index;
                Mat_Nrange_given_y(loc_Card_at_hand,1)=Mat_Nrange_given_y(loc_Card_at_hand,1)+1; % the current number of the card in Vec_Answer_c if I put it in.
                % to avoid putting operator cards consecutively
                %          putting the 0 card right next to the operator card.            
                if loc_Card_at_hand>11 
                    Boxes_Index_given_y([2,12:end],x+1)=false;
                    if Vec_Answer_c(1,x+1)~=""
                        if sum(contains(Vec_Cards([[1,2],12:N_CardType],1),Vec_Answer_c(1,x+1)),1)>0
                            flag_double_oper=true;
                        end
                    end
                    if sum(contains(Vec_Cards([[1,2],12:N_CardType],1),Vec_Answer_c(1,x-1)),1)>0
                         flag_double_oper=true;
                    end
                elseif loc_Card_at_hand==2 
                    if sum(contains(Vec_Cards([1,12:N_CardType],1),Vec_Answer_c(1,x-1)),1)>0
                         flag_double_oper=true;
                    end
                end
                if ~flag_double_oper
                    % to avoid putting in the card more than its upper limit
                    if Mat_Nrange_given_y(loc_Card_at_hand,1)==Mat_Nrange_given_y(loc_Card_at_hand,3)
                        Boxes_Index_given_y(loc_Card_at_hand,(x+1:end))=false; 
                    end
                    if N_Sides(1,1)>x % move forward if the blanks on the left side of "=" is not complete 
                        [List_equ,List_score,N_equ_gen,N_equ_try]= genEqu_v1(x+1,Vec_Answer_c,ind_search,Boxes_Index_given_y,Mat_Nrange_given_y,Vec_Cards,N_CardType,N_Sides,Max_equ,Max_try,List_equ,List_score,N_equ_gen,N_equ_try);          
                    else
                        [List_equ,List_score,N_equ_gen]= gen_equ_right(x,Vec_Answer_c,N_Sides,Boxes_Index_given_y,Mat_Nrange_given_y,List_equ,List_score,N_equ_gen);
                        N_equ_try=N_equ_try+1;
                    end
                end
            end
            if N_equ_try > Max_try; return; end
            if N_equ_gen>=Max_equ; return; end
        end
    else
        if N_Sides(1,1)>x % move forward if the blanks on the left side of "=" is not complete 
            % to avoid putting operator cards consecutively
            %          putting the 0 card right next to the operator coard.            
            Card_at_hand = Vec_Answer_xm1(1,x); % Pick up a card at (y,x)
            loc_Card_at_hand=contains(Vec_Cards,Card_at_hand); % identify the location of the card in Vec_Cards
            if loc_Card_at_hand>11 
                Boxes_Index([2,12:end],x+1)=false; 
            end
            [List_equ,List_score,N_equ_gen,N_equ_try]= genEqu_v1(x+1,Vec_Answer_xm1,ind_search,Boxes_Index,Mat_Nrange,Vec_Cards,N_CardType,N_Sides,Max_equ,Max_try,List_equ,List_score,N_equ_gen,N_equ_try);
        else
            [List_equ,List_score,N_equ_gen]= gen_equ_right(x,Vec_Answer_xm1,N_Sides,Boxes_Index,Mat_Nrange,List_equ,List_score,N_equ_gen);
            N_equ_try=N_equ_try+1;
        end
        if N_equ_try > Max_try; return; end
        if N_equ_gen>=Max_equ; return; end
    end
end