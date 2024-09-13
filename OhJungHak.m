%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solver for the STEAM game, MATH EXPRESSions
% For example
%    Rank = 33
%    Max_equ=50;
%    choose=1;
% For example, [89+20-47=62]
%     Step1:    9+6*124=753
%              [11100121100]
%              [1,1,1,0,0,1,2,1,1,0,0];
%     Step2:    8-9+6+42=47
%              [21111021201]
%              [2,1,1,1,1,0,2,1,2,0,1];
%     Step3:    89+29-46=72
%              [22220221212]
%              [2,2,2,2,0,2,2,1,2,1,2];
%     Step4:    89+20-47=62
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set-up
% Define 
    %Vec_Answer
    %Best_Answer,
    %Best_Score,
    %Boxes_Cards,
    %Boxes_Index,
    %Mat_Nrange = N_CardType by 3 mat = [current number in equ, min number, max number]
    %loc_Equal
    %loc_Oper
% Vec_Answer & Best_Answer, Best_Score
clear; clc;
Rank = input('Rank?');
%Max_equ=50;

Cards_Operator=["+","-","*","/","^"]';
Total_N_Oper=length(Cards_Operator);
N_info = 5 + floor((Rank-1)/Total_N_Oper);
    Vec_Answer=strings(1,N_info);   
    Best_Answer=Vec_Answer;
    Best_Score=0;
    
% Boxes, loc_Equal, loc_Oper
Card_Equal="=";
Cards_Number=string(0:1:9)';
N_Oper=rem(Rank,Total_N_Oper);
if N_Oper==0; N_Oper=5; end
Cards_Oper_c=Cards_Operator(1:N_Oper);
Vec_Cards=[Card_Equal;Cards_Number;Cards_Oper_c];
N_CardType=length(Vec_Cards);
    loc_Equality=1;
    %loc_Numbers=2:11;
    loc_Oper=12:(11+N_Oper);
    Boxes_Cards = repmat(Vec_Cards,1,N_info);
    Boxes_Index = true(size(Boxes_Cards));

% Mat_Nrange
Vec_cN_for_each_Card   = zeros(N_CardType,1);
Vec_minN_for_each_Card   = zeros(N_CardType,1);
%Vec_maxN_for_each_Card   = ones(N_CardType,1)*ceil(N_info/N_CardType)+4;
flag_ini=(input('Do you want to input the initial equation by yourself? (Y/N)')=='Y');
if flag_ini; N_duplicate=1;
else; N_duplicate=input('How many times do you allow numbers to be duplicated?');
end
    Vec_maxN_for_each_Card   = ones(N_CardType,1)*N_duplicate;
    Mat_Nrange = [Vec_cN_for_each_Card,Vec_minN_for_each_Card,Vec_maxN_for_each_Card];
    Mat_Nrange(1,[1,2,3])=1; % only one equality  
     clear Vec_cN_for_each_Card Vec_minN_for_each_Card Vec_maxN_for_each_Card

%% Try 1
% Initialize
    Col=1;
        Boxes_Index(loc_Equality,Col)=false;
        Boxes_Index(Vec_Cards=="0",Col)=false; 
        Boxes_Index(loc_Oper,Col)=false;
    Col=1:(ceil(N_info/2));
        Boxes_Index(loc_Equality,Col)=false;
    Col=N_info;
        Boxes_Index([loc_Equality,loc_Oper],Col)=false;
    Col=(N_info-2):(N_info-1);
        Boxes_Index(loc_Oper,Col)=false;
    Boxes_Cards(~Boxes_Index)="";
    
% Search
    % Vec_Answer
    % Boxes_Cards
    % Boxes_Index
    % Set_Nrange_for_each_Card
    loc_Equal=find(Boxes_Index(1,:));
    %loc_Equal=loc_Equal(1,end:(-1):1);
    x=1; 
    ind_search=true(1,N_info);
    if flag_ini
        List_final_equ=input('Please insert the equation you want to try.\n');    
        Max_equ=0;
        Max_try=0;
    else
        Max_equ=input('How many candidate equations do you want to obtain at maximum? ');
        Max_try=input('How many combinations do you want me to try given the location of "="? ');
    %for i=1:length(loc_Equal)
        candidate_message=sprintf(['I am considering {', ...
            repmat(' %d',[1,length(loc_Equal)])...
            '} as candidates for the location of "=" at priority\n',...
            'Choose the location of "=" you wanna use: '],loc_Equal);
        loc_equal=input(candidate_message);
        %loc_equal=loc_Equal(i);
        % fprintf('location of "=": %d\n',loc_equal)
        %loc_equal=round(N_info*3/4);
        [Vec_Answer_xm1,N_Sides,List_equ,List_score,N_equ_gen,ind_search_given_i,Boxes_Index_given_i]=gen_ready(Vec_Answer,Boxes_Index,loc_equal,ind_search,N_info);
        [List_equ,List_score,~]=genEqu(x,Vec_Answer_xm1,ind_search_given_i,Boxes_Index_given_i,Mat_Nrange,Vec_Cards,N_CardType,N_Sides,Max_equ,Max_try,List_equ,List_score,N_equ_gen,0);    
        max_val=max(List_score);
        List_final_equ=List_equ(List_score==max_val,:);
    %end
    end
    List_final_equ(1:min([5;size(List_final_equ,1)]),:)
    %Max_equ=ceil(Max_equ/sum(Boxes_Index(1,:),2));
    Mat_Nrange(2:end,3)=N_info-1; 
    Mat_Nrange0=Mat_Nrange;
    Vec_Answer0=Vec_Answer;
    Boxes_Index0=Boxes_Index;
    ind_search0=ind_search;
    List_final_equ0=List_final_equ;
    %{
    Mat_Nrange=Mat_Nrange0;
    Vec_Answer=Vec_Answer0;
    Boxes_Index=Boxes_Index0;
    ind_search=ind_search0;
    %}
%List_final_equ=['9','+','8','+','7','+','6','+','1','2','+','3','=','4','5'];
%List_final_equ=['7','9','8','1','2','+','2','1','0','=','8','0','0','2','2'];
%List_final_equ=['9','8','-','7','6','-','5','4','+','3','2','+','1','=','1'];
%% Next Steps
step=1;
while step<6
    step=step+1;
    if size(List_final_equ,1)>1; loc_choose=input('Which equation are you gonna choose? ');
    else; loc_choose=1; end
    Vec_Answer_xm1=List_final_equ(loc_choose,:);
    flag_input_again=true;
    while flag_input_again
        result_vec=input('Insert a character vector of the results (r = red, l = lime, g= green): \n   '); % 
        result=zeros(1,N_info);
        if length(result_vec) == N_info
            for i=1:N_info
                if result_vec(i)=='r'; result(1,i)=0;
                elseif result_vec(i)=='l'; result(1,i)=1;
                elseif result_vec(i)=='g'; result(1,i)=2;
                else; break;
                end
            end
            flag_input_again=false;
        end
    end
%{
Mat_Nrange_tp=Mat_Nrange;
Vec_Answer_tp=Vec_Answer;
Boxes_Index_tp=Boxes_Index;
ind_search_tp=ind_search;
Mat_Nrange=Mat_Nrange_tp;
Vec_Answer=Vec_Answer_tp;
Boxes_Index=Boxes_Index_tp;
ind_search=ind_search_tp;
%}
% Update info   
    [Vec_Answer,ind_search,Boxes_Index,Mat_Nrange] = updateInfo(result,Vec_Answer,ind_search,Boxes_Index,Mat_Nrange,Vec_Answer_xm1,Vec_Cards,N_CardType);
    Boxes_Cards(~Boxes_Index)="";
    %Boxes_Index(13,[2,3])=false;
    Vec_Answer
    Boxes_Cards
    loc_Equal=find(Boxes_Index(1,:));

    flag_insert=(input('Do you want to input the equation by yourself? (Y/N) ')=='Y');
    if flag_insert
        List_final_equ=input('Insert your equation.\n   ');
    else
        List_equ=strings(0,N_info);
        List_score=zeros(0,0);
        flag_try_given_equality=true;   
        while flag_try_given_equality
    %   for i=length(loc_Equal):-1:1 
            if length(loc_Equal)>1 
                candidate_message=sprintf(['\nI am considering {', ...
                                            repmat(' %d',[1,length(loc_Equal)])...
                                            '} as candidates for the location of "=" at priority',...
                                            '\nChoose the location of "=" you wanna use: '],loc_Equal);
                loc_equal=input(candidate_message);
            else
                loc_equal=loc_Equal;
            end
            Max_equ=input('How many candidate equations do you want to obtain at maximum?');
            Max_try=input('How many combinations do you want me to try given the location of "="?');
            %fprintf('location of "=": %d\n',loc_Equal(i))
            %loc_equal=loc_Equal(i);
            if Vec_Answer_xm1(loc_equal+1)~="0"
                [Vec_Answer_xm1,N_Sides,List_equ_given_i,List_score_given_i,N_equ_gen,ind_search_given_i,Boxes_Index_given_i]=gen_ready(Vec_Answer,Boxes_Index,loc_equal,ind_search,N_info);
                Boxes_Cards_given_i=Boxes_Cards;
                Boxes_Cards_given_i(~Boxes_Index_given_i)="";
                [List_equ_given_i,List_score_given_i,~]=genEqu(x,Vec_Answer_xm1,ind_search_given_i,Boxes_Index_given_i,Mat_Nrange,Vec_Cards,N_CardType,N_Sides,Max_equ,Max_try,List_equ_given_i,List_score_given_i,N_equ_gen,0);
                if size(List_equ_given_i,1)>0
                    max_val=max(List_score_given_i);
                    loc=List_score_given_i==max_val;
                    List_equ=[List_equ;List_equ_given_i(loc,:)];
                    List_equ
                    List_score=[List_score;List_score_given_i(loc,:)];
                end
            end
        end
        max_val=max(List_score);
        List_final_equ=List_equ(List_score==max_val,:);
        List_final_equ(1:min([5;size(List_final_equ,1)]),:)
    end
end
