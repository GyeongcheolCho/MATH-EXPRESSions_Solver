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

% How to arrange operators substantially affect the computational efficiency 
if N_CardType==16;     order_bk_operator=[16,15,14,12,13];
elseif N_CardType==15; order_bk_operator=[14,15,12,13];
elseif N_CardType==14; order_bk_operator=[14,13,12];
elseif N_CardType==13; order_bk_operator=[12,13];
else; order_bk_operator=12;
end
order_search=[1,order_bk_operator,[2,9,3,8,4,7,5,6,1,0]+2];

%% Try 1
% Initialize
    Col=1;
        Boxes_Index(loc_Equality,Col)=false;
        Boxes_Index(Vec_Cards=="0",Col)=false; 
        Boxes_Index(loc_Oper,Col)=false;
    Col=1:(ceil(N_info/2)-1);
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
    else
        flag_try=true;
        while flag_try            
            Max_try=input('How many equations are you going to attempt? ');
            N_equ_gen=0;
            N_equ_try=0;
            List_equ=strings(0,N_info);
            List_score=zeros(0,0);
            [List_equ,List_score,N_equ_try]=genEqu(x,Vec_Answer,ind_search,Boxes_Index,Mat_Nrange,Vec_Cards,N_CardType,N_info,Max_try,List_equ,List_score,N_equ_try,order_search);    
           if size(List_equ,1)>0
                max_val=max(List_score);
                List_final_equ=List_equ(List_score==max_val,:);
                N_equ_tp=min([5;size(List_final_equ,1)]);
                for i = 1:N_equ_tp
                    fprintf('\n %s',squeeze(char(List_final_equ(i,:)))')
                end
                fprintf('\n')
                flag_try=false;
            else
                fprintf('\nWe could not find any valid equation given %d. Please try again after increasing the maximum number of trials\n',Max_try)
            end
        end
    end
    Mat_Nrange(2:end,3)=N_info-1; 
%% Next Steps

%order_search=[order_search(1,[1,3:end]),order_search(2)]
step=1;
while step<7
    step=step+1;
    if size(List_final_equ,1)>1; loc_choose=input('Which equation are you gonna choose? ');
    else; loc_choose=1; end
    Vec_Answer_tp1=List_final_equ(loc_choose,:);
    flag_input_again=true;
    while flag_input_again
        result_vec=input(sprintf(['\nEnter a character vector of the results below (r = red, l = lime, g= green) \n', ...
                          'Equation:  %s   \n',...
                          '        : '],char(List_final_equ(loc_choose,:)))); % 
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
    [Vec_Answer,ind_search,Boxes_Index,Mat_Nrange] = updateInfo(result,Vec_Answer,ind_search,Boxes_Index,Mat_Nrange,Vec_Answer_tp1,Vec_Cards,N_CardType);
    Boxes_Cards(~Boxes_Index)="";
    %Boxes_Index(13,[2,3])=false;
    fprintf('\n Remaining Cards')
    for i=1:N_CardType; fprintf('\n %s',squeeze(char(Boxes_Cards(i,:)))')
    end
    fprintf('\n');
        
    flag_insert=(input('Do you want to input the equation by yourself? (Y/N) ')=='Y');
    if flag_insert
        List_final_equ=input('Insert your equation.\n   ');
    else
        flag_try=true;
        while flag_try
            Max_try=input('How many equations are you going to attempt? ');
            N_equ_try=0;
            List_equ=strings(0,N_info);
            List_score=zeros(0,0);
            [List_equ,List_score,N_equ_try]=genEqu(x,Vec_Answer,ind_search,Boxes_Index,Mat_Nrange,Vec_Cards,N_CardType,N_info,Max_try,List_equ,List_score,N_equ_try,order_search);  
            if size(List_equ,1)>0
                max_val=max(List_score);
                List_final_equ=List_equ(List_score==max_val,:);
                N_equ_tp=min([5;size(List_final_equ,1)]);
                for i = 1:N_equ_tp
                    fprintf('\n %s',squeeze(char(List_final_equ(i,:)))')
                end
                fprintf('\n')
                flag_try=false;
            else
                fprintf('\nWe could not find any equation given %d. Please try again aftv er increasing the maximum number of trials\n',Max_try)
            end
        end
    end
end
