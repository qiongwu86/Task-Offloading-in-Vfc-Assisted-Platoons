% 用工具箱实现贪婪算法
clear all;
tic;
%！！！！ 【注意，将mdp_bellman_operator_GA中的K值，换成对应的】
K = 4;   % 【车载云】中，车辆总数【车载云】 (4-10)  
M = 4;  % 车队中车辆总数

lambda_f =9;     %车辆到达率【秒】
u_f = 8;            %车辆离开率【秒】
lambda_p = 20;        %任务到达率【秒】

% 任务离开率  u_p = f/d 单位为s
f0 = 350;  %==========530-600

f1 = 600;   %分配给头车
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  40;  
%% 参数获取 
[s, P, R, discount, delay_all] = data_input_platoon(K,M,lambda_p,lambda_f,u_f,f0,f1,f2,f3,f4,d);

%% 值迭代
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

%% 统计【车队】动作概率
% count_1 = zeros(1,4);   % 分析，分配给车队各个车的概率
% count_prob_1 = zeros(1,4);
% flag_platoon = 0;
% 
% % 统计车载动作情况
% flag_vehicle = 0;
% count_2 = zeros(1,3);   % 分析车载云情况
% count_prob_2 = zeros(1,3);
% drop = 0;
% 
% for i=1:length(s)
%     if strcmp(s{i,4},'A')
%         if s{i,6}==10
%             count_1(1) = count_1(1)+1;
%             flag_platoon = flag_platoon + 1;
%         elseif s{i,6}==20
%             count_1(2) = count_1(2)+1;
%             flag_platoon = flag_platoon + 1;
%         elseif s{i,6}==30
%             count_1(3) = count_1(3)+1;
%             flag_platoon = flag_platoon + 1; 
%         elseif s{i,6}==40
%             count_1(4) = count_1(4)+1;
%             flag_platoon = flag_platoon + 1;          
%                   
%         % 车载情况
%         elseif s{i,6}==1
%             count_2(1) = count_2(1)+1;
%             flag_vehicle = flag_vehicle + 1;
%         elseif s{i,6}==2
%             count_2(2) = count_2(2)+1; 
%             flag_vehicle = flag_vehicle + 1;
%         elseif s{i,6}==3
%             count_2(3) = count_2(3)+1;  
%             flag_vehicle = flag_vehicle + 1;
%             
%         % 丢包情况    
%         elseif s{i,6}== 0  % 不影响最后结果，这本来是0的，因为矩阵原因
%             drop = drop + 1; % 没有除去本来就必须丢弃的情况            
%             
%         end          
%     end
% end
% 
% count_prob_2(1)=count_2(1)/sum(count_2); % a = 1
% count_prob_2(2)=count_2(2)/sum(count_2);
% count_prob_2(3)=count_2(3)/sum(count_2);
% count_prob_2
% 
% flag_sum = flag_vehicle + flag_platoon + drop;  % 所有A的状态数
% platoon_prob = flag_platoon/flag_sum
% vehicle_prob = flag_vehicle/flag_sum
% drop_prob    = drop/flag_sum % a = 0, 丢包情况
% 
% %计算奖励（除开丢弃包的情况  A）
% rewardSMDP_part = 0;
% chezai_part = 0;
% for i =1:length(s)
%     if strcmp(s{i,4}, 'A') && s{i,6} > 0
%         rewardSMDP_part = rewardSMDP_part + V(i,1);
%         chezai_part = chezai_part + 1;
%     end
% end
% % rewardSMDP; 
% average_part = rewardSMDP_part / chezai_part;
% rewardSMDP_part
% %}
% toc;
