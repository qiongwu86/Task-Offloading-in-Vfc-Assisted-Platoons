clc;
clear;
tic;

K_range = 4:10;   % 【车载云】中，车辆总数【车载云】 (4-10)  
K = 6;
M = 4;  % 车队中车辆总数

lambda_f = 9;     %车辆到达率【秒】
u_f = 8;            %车辆离开率【秒】
lambda_p = 20;        %任务到达率【秒】 变化15-25

% 任务离开率  u_p = f/d 单位为s
f0 = 350;  %==========530-600

f1 = 600;   %分配给头车
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  40; 

file_handle = fopen("v2c_delay.txt", "w+");

for K = K_range
    [s, P, R, discount, delay_all] = data_input_platoon(K,M,lambda_p,lambda_f,u_f,f0,f1,f2,f3,f4,d);

    sprintf("data generate for K = " + K)
    fprintf(file_handle, "K" + K + " = [");
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