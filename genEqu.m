function [List_equ,List_score,N_equ_try,order_search]= genEqu(x,Vec_Answer,ind_search,Boxes_Index,Mat_Nrange,Vec_Cards,N_CardType,N_info,Max_try,List_equ,List_score,N_equ_try,order_search)
% Vec_Answer_c = The combination of cards that is currently considered     
    if x==N_info
        return;    
        %{
        else
        Previous_value=Vec_Answer(1,x-1);
        num_value=str2double(Previous_value);
        if ~isnan(num_value)
            loc_in_Vec_Cards=num_value+2;
            if     loc_in_Vec_Cards==11; order_bk_number=[10:-1:2,11];
            elseif loc_in_Vec_Cards==2;  order_bk_number=11:-1:2;
            else;  order_bk_number=[(loc_in_Vec_Cards-1):-1:2,11:-1:(loc_in_Vec_Cards+1),loc_in_Vec_Cards];
            end
            order_search=[1,12:N_CardType,order_bk_number];
        else
            order_search=[1,12:N_CardType,11:-1:2];
        end
        %}
    elseif ind_search(x)
        for yy=1:N_CardType   
            y=order_search(1,yy);
            Vec_Answer_c=Vec_Answer;
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
                if loc_Card_at_hand>11 || loc_Card_at_hand==1
                    Boxes_Index_given_y([[1,2],12:end],x+1)=false;
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
                if N_CardType==16 
                    if x>3 && y<12
                        if (Vec_Answer_c(1,x-2)=="^") && (Vec_Answer_c(1,x-3)~="1") 
                            Boxes_Index_given_y(2:11,x+1)=false;
                        end
                    end
                end
                if ~flag_double_oper
                    % to avoid putting in the card more than its upper limit
                    if Mat_Nrange_given_y(loc_Card_at_hand,1)==Mat_Nrange_given_y(loc_Card_at_hand,3)
                        Boxes_Index_given_y(loc_Card_at_hand,(x+1:end))=false; 
                    end
%                     if N_Sides(1,1)>x % move forward if the blanks on the left side of "=" is not complete 
%                         [List_equ,List_score,N_equ_gen,N_equ_try]= genEqu(x+1,Vec_Answer_c,ind_search,Boxes_Index_given_y,Mat_Nrange_given_y,Vec_Cards,N_CardType,N_Sides,Max_equ,Max_try,List_equ,List_score,N_equ_gen,N_equ_try);          
%                     else
%                         [List_equ,List_score,N_equ_gen]= gen_equ_right(x,Vec_Answer_c,N_Sides,Boxes_Index_given_y,Mat_Nrange_given_y,List_equ,List_score,N_equ_gen);
%                         N_equ_try=N_equ_try+1;
%                     end
                    if y>1 % move forward if the current card is not equality 
                        order_search_t1=order_search;
                        order_search_t1(yy)=[];
                        order_search_t1=[order_search_t1,y];
                        [List_equ,List_score,N_equ_try,~]= genEqu(x+1,Vec_Answer_c,ind_search,Boxes_Index_given_y,Mat_Nrange_given_y,Vec_Cards,N_CardType,N_info,Max_try,List_equ,List_score,N_equ_try,order_search_t1);          
                    else
                        N_Sides=[x-1,N_info-x];
                        [List_equ,List_score]= gen_equ_right(x,Vec_Answer_c,N_Sides,Boxes_Index_given_y,Mat_Nrange_given_y,List_equ,List_score);
                        N_equ_try=N_equ_try+1;
                        if rem(N_equ_try,100)==0
                            fprintf('\n%d: %s',N_equ_try,squeeze(char(Vec_Answer_c)))
                        end                        
                    end
                end
            end
            if N_equ_try>=Max_try; return; end
        end
    else
        if Vec_Answer(1,x)~="="
            if ind_search(x+1)
                % to avoid putting operator cards consecutively
                %          putting the 0 card right next to the operator coard.            
                Card_at_hand = Vec_Answer(1,x); % Pick up a card at (y,x)
                loc_Card_at_hand=find(contains(Vec_Cards,Card_at_hand)); % identify the location of the card in Vec_Cards
                if loc_Card_at_hand>11 
                    Boxes_Index([2,12:end],x+1)=false; 
                end
            end
            [List_equ,List_score,N_equ_try,~]= genEqu(x+1,Vec_Answer,ind_search,Boxes_Index,Mat_Nrange,Vec_Cards,N_CardType,N_info,Max_try,List_equ,List_score,N_equ_try,order_search);
        else
            N_Sides=[x-1,N_info-x];
            [List_equ,List_score]= gen_equ_right(x,Vec_Answer,N_Sides,Boxes_Index,Mat_Nrange,List_equ,List_score);
            % fprintf('\n%s',squeeze(char(Vec_Answer_c)))
            N_equ_try=N_equ_try+1;
            if rem(N_equ_try,100)==0
                 fprintf('\n%d: %s',N_equ_try,squeeze(char(Vec_Answer)))
            end                        
        end           
        if N_equ_try>=Max_try; return; end
    end
end