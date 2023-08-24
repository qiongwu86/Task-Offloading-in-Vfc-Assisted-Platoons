% �ù�����ʵ��̰���㷨
clear all;
tic;
%�������� ��ע�⣬��mdp_bellman_operator_GA�е�Kֵ�����ɶ�Ӧ�ġ�
K = 4;   % �������ơ��У����������������ơ� (4-10)  
M = 4;  % �����г�������

lambda_f =9;     %���������ʡ��롿
u_f = 8;            %�����뿪�ʡ��롿
lambda_p = 20;        %���񵽴��ʡ��롿

% �����뿪��  u_p = f/d ��λΪs
f0 = 350;  %==========530-600

f1 = 600;   %�����ͷ��
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  40;  
%% ������ȡ 
[s, P, R, discount, delay_all] = data_input_platoon(K,M,lambda_p,lambda_f,u_f,f0,f1,f2,f3,f4,d);

%% ֵ����
epsilon = 10;
max_iter = 200;
[Q, V, policy, iter, cpu_time] = mdp_value_iteration_GA(P, R, discount, epsilon, max_iter); 

%��¼���Ŷ���
action = [-1,0,10,20,30,40,1,2,3]; 
for i =1:length(s)
    index = policy(i,1);      % policy:�����Ѷ���������
    optimal = action(1,index); 
    s{i,6} = optimal;%����Ϊ���Ŷ������Ǳ��
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

%% ͳ�ơ����ӡ���������
% count_1 = zeros(1,4);   % ��������������Ӹ������ĸ���
% count_prob_1 = zeros(1,4);
% flag_platoon = 0;
% 
% % ͳ�Ƴ��ض������
% flag_vehicle = 0;
% count_2 = zeros(1,3);   % �������������
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
%         % �������
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
%         % �������    
%         elseif s{i,6}== 0  % ��Ӱ����������Ȿ����0�ģ���Ϊ����ԭ��
%             drop = drop + 1; % û�г�ȥ�����ͱ��붪�������            
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
% flag_sum = flag_vehicle + flag_platoon + drop;  % ����A��״̬��
% platoon_prob = flag_platoon/flag_sum
% vehicle_prob = flag_vehicle/flag_sum
% drop_prob    = drop/flag_sum % a = 0, �������
% 
% %���㽱�������������������  A��
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
