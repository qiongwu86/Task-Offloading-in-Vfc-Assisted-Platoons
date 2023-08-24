%% Platoon
% 每一次：V3_mdp_bellman_operator_calculateValue函数中的K也要相应变化；其实是为了，纠正数据先后产生的问题，结
% 果是对的
clear all;clc;clear;
tic;

%！！！！ 【注意，将V3_mdp_bellman_operator_calculateValue中的K值，换成对应的】
K = 10;   % 【车载云】中，车辆总数【车载云】 (4-10)  
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
%% 参数获取 
[s, P, R, discount, delay_all] = data_input_platoon(K,M,lambda_p,lambda_f,u_f,f0,f1,f2,f3,f4,d);
sprintf('这里参数获取结束')


%% our
epsilon = 10;
max_iter = 200;

[Q, V, policy, iter, cpu_time] = mdp_value_iteration(P, R, discount, epsilon, max_iter); 

%记录最优动作
action = [-1,0,10,20,30,40,1,2,3]; % 10代表分配给车队头车，20分配给车队第二辆车
for i =1:length(s)

    index = policy(i,1);      % policy:存放最佳动作的索引
    
    optimal = action(1,index); 
    s{i,6} = optimal;%——为最优动作，非编号
end


%%%%%%%%%%%%%%%%%%%%%%delay%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delay_average = 0;
delay_nozero = 0;
for i = 1:length(s)
    if delay_all(i, policy(i, 1)) == 0
        continue
    end
    delay_nozero = delay_nozero + 1;
    delay_average = delay_average + delay_all(i, policy(i, 1));
end
delay_average = delay_average / delay_nozero


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% GREEDY
epsilon = 10;
max_iter = 200;
[Q, V, policy, iter, cpu_time] = mdp_value_iteration_GA(P, R, discount, epsilon, max_iter); 

%记录最优动作
action = [-1,0,10,20,30,40,1,2,3]; 
for i =1:length(s)
    index = policy(i,1);      % policy:存放最佳动作的索引
    optimal = action(1,index); 
    s{i,6} = optimal;%——为最优动作，非编号
end

%%%%%%%%%%%%%%%%%%%%%%delay%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delay_average = 0;
delay_nozero = 0;
for i = 1:length(s)
    if delay_all(i, policy(i, 1)) == 0
        continue
    end
    delay_nozero = delay_nozero + 1;
    delay_average = delay_average + delay_all(i, policy(i, 1));
end
delay_average = delay_average / delay_nozero


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% EQUAL
epsilon = 10;
max_iter = 200;

[Q, V, policy, iter, cpu_time] = mdp_value_iteration_equal(P, R, discount, epsilon, max_iter); 

%记录最优动作
action = [-1,0,10,20,30,40,1,2,3]; % 10代表分配给车队头车，20分配给车队第二辆车
for i =1:length(s)

    index = policy(i,1);      % policy:存放最佳动作的索引
    
    optimal = action(1,index); 
    s{i,6} = optimal;%——为最优动作，非编号
end


%%%%%%%%%%%%%%%%%%%%%%delay%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delay_average = 0;
delay_nozero = 0;
for i = 1:length(s)
    if delay_all(i, policy(i, 1)) == 0
        continue
    end
    delay_nozero = delay_nozero + 1;
    delay_average = delay_average + delay_all(i, policy(i, 1));
end
delay_average = delay_average / delay_nozero


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%