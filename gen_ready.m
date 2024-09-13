function [Vec_Answer_xm1,N_Sides,List_equ,List_score,N_equ_gen,ind_search_given_i,Boxes_Index_given_i]=gen_ready(Vec_Answer,Boxes_Index_given_i,loc_equal,ind_search,N_Info)
    Vec_Answer_xm1=Vec_Answer;
    Vec_Answer_xm1(loc_equal)="=";
    N_Sides=[loc_equal-1,N_Info-loc_equal];
    ind_search_given_i=ind_search;
    ind_search_given_i(1,loc_equal)=false;
    Boxes_Index_given_i(1,:)=false;
    Boxes_Index_given_i(1,loc_equal)=true;    
    Boxes_Index_given_i(12:end,(loc_equal-1:end))=false;
    List_equ=strings(0,N_Info);
    List_score=zeros(0,0);
    N_equ_gen=0;
end