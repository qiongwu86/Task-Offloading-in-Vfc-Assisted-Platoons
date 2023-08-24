clc;
clear;
tic;

%！！！！ 【注意，将V3_mdp_bellman_operator_calculateValue中的K值，换成对应的】
K_range = 4:8;   % 【车载云】中，车辆总数【车载云】; (4-10)  
d_range = 35:45;
M = 4;  % 车队中车辆总数

lambda_f = 9;     %车辆到达率【秒】
u_f = 8;            %车辆离开率【秒】
lambda_p_range = 15 : 25;
lambda_p = 20;        %任务到达率【秒】 变化15-25

% 任务离开率  u_p = f/d 单位为s
f0 = 350;  %==========530-600

f1 = 600;   %分配给头车
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  40; 

file_handle = fopen("d_delay.txt", "w+");


for lambda_p = lambda_p_range
    %% load data
%     load("K"+K+"\P.mat");
%     load("K"+K+"\discount.mat");
%     load("K"+K+"\R.mat");
%     load("K"+K+"\delay_all.mat");
%     load("K"+K+"\s.mat");
%     load("d/"+d+"s");
%     load("d/"+d+"P.mat");
%     load("d/"+d+"R.mat");
%     load("d/"+d+"discount.mat");
%     load("d/"+d+"delay_all.mat");
%     fprintf(file_handle, "d" + d + " = [");
%     sprintf("-------------------------------------------------")
%     sprintf("d = " + d)    
    load("lambda_p/"+lambda_p+"s.mat");
    load("lambda_p/"+lambda_p+"P.mat");
    load("lambda_p/"+lambda_p+"R.mat");
    load("lambda_p/"+lambda_p+"discount.mat");
    load("lambda_p/"+lambda_p+"delay_all.mat");
    fprintf(file_handle, "lambda_p" + lambda_p + " = [");
    sprintf("-------------------------------------------------")
    sprintf("lambda_p = " + lambda_p) 


    %% our 
    epsilon = 10;
    max_iter = 300;
    % get policy
    [Q, V, policy, ~, ~] = mdp_value_iteration(P, R, discount, epsilon, max_iter); 
        
    delay_average = 0;
    delay_nozero = 0;
    for i = 1:length(s)
        if delay_all(i, policy(i, 1)) == 0
            continue
        end
        delay_nozero = delay_nozero + 1;
        delay_average = delay_average + delay_all(i, policy(i, 1));
    end
    delay_average = delay_average / delay_nozero;
    sprintf("our average delay:" + delay_average)
    fprintf(file_handle, delay_average+", ");
    


    %% GREEDY
    epsilon = 10;
    max_iter = 300;
    [Q, V, policy, iter, cpu_time] = mdp_value_iteration_GA(P, R, discount, epsilon, max_iter); 

    delay_average = 0;
    delay_nozero = 0;
    for i = 1:length(s)
        if delay_all(i, policy(i, 1)) == 0
            continue
        end
        delay_nozero = delay_nozero + 1;
        delay_average = delay_average + delay_all(i, policy(i, 1));
    end
    delay_average = delay_average / delay_nozero;
    sprintf("greedy average delay:" + delay_average)
    fprintf(file_handle, delay_average+", ");

    %% EQUAL
    epsilon = 10;
    max_iter = 300;
    [Q, V, policy, iter, cpu_time] = mdp_value_iteration_equal(P, R, discount, epsilon, max_iter); 

    delay_average = 0;
    delay_nozero = 0;
    for i = 1:length(s)
        if delay_all(i, policy(i, 1)) == 0
            continue
        end
        delay_nozero = delay_nozero + 1;
        delay_average = delay_average + delay_all(i, policy(i, 1));
    end
    delay_average = delay_average / delay_nozero;
    sprintf("equal average delay:" + delay_average)
    fprintf(file_handle, delay_average+" ");

fprintf(file_handle, "];\n");
end
