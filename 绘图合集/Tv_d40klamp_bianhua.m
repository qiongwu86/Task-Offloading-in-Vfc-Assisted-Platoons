%============================K变化，图形好看
K =6    % 【车载云】中，车辆总数【车载云】 (4-10)  
M = 4;  % 车队中车辆总数

lambda_f =9;     %车辆到达率【秒】
u_f = 8;            %车辆离开率【秒】
lambda_p = 20;        %任务到达率【秒】

% 任务离开率  u_p = f/d 单位为s
f0 = 560;  %===============================550不行

f1 = 600;   %分配给头车
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  40; 
%-------------------------------------------------------------------
Tv1 = [8.5465, 8.5465, 8.5465, 8.5465, 8.5465, 8.5465, 8.5465, 8.5465, 8.5465, 8.5465, 8.5465,];  % 一个RU传输到VFC时间
Tv2 = [12.0956, 12.0956, 12.0956, 12.0956, 12.0956, 12.0956, 12.0956, 12.0956, 12.0956, 12.0956, 12.0956,];
Tv3 = [15.6448, 15.6448, 15.6448, 15.6448, 15.6448, 15.6448, 15.6448, 15.6448, 15.6448, 15.6448, 15.6448,];

D_Tv1 = [1.1137e+02, 1.1422e+02, 1.1708e+02, 1.1994e+02, 1.2280e+02, 1.2565e+02, 1.2851e+02, 1.3137e+02, 1.3422e+02, 1.3708e+02, 1.3994e+02,];  %总时延（传输+处理）
D_Tv2 = [6.4920e+01, 6.6349e+01, 6.7778e+01, 6.9206e+01, 7.0635e+01, 7.2063e+01, 7.3492e+01, 7.4920e+01, 7.6349e+01, 7.7778e+01, 7.9206e+01,];
D_Tv3 = [5.1803e+01, 5.2755e+01, 5.3708e+01, 5.4660e+01, 5.5612e+01, 5.6565e+01, 5.7517e+01, 5.8470e+01, 5.9422e+01, 6.0374e+01, 6.1327e+01,];

% reward of system
%rewardSMDP_part = [4.6965e+05, 9.5452e+05, 1.8183e+06, 3.1712e+06, 5.0450e+06, 7.3409e+06, 9.7793e+06, ];
%GA_bian =         [4.1103e+04, 6.5547e+04, 9.8244e+04, 1.3796e+05, 1.8576e+05, 2.4455e+05, 3.1506e+05, ];
gap=1;
begin = 35; endNum = 45;

figure(2);
y=begin:1:endNum;
plot(y, Tv1, '-bo','linewidth',2);
hold on
plot(y, Tv2, '-cd','linewidth',2);   %蓝色
hold on 
plot(y, Tv3, '-rs','linewidth',2);
set(gca,'xtick',begin:1:endNum);
%ylim([0.08,0.6])
legend('A1','A2','A3');
xlabel('Required CPU cycles to process each task');
ylabel('Delay of transmitting a task (ms)'); 


figure(3);
y=begin:1:endNum;
plot(y, D_Tv1, '-bp','linewidth',2);
hold on
plot(y, D_Tv2, '-rd','linewidth',2);   %蓝色
hold on 
plot(y, D_Tv3, '-cs','linewidth',2);
% ylim([0.2,0.85])
% set(gca,'xtick',9:1:13);
set(gca,'xtick',begin:1:endNum);
legend('A1','A2','A3');
xlabel('Required CPU cycles to process each task');
ylabel('Delay of offloading a task (ms)'); 


% % reward--------要做归一化处理，不然图形不好看,图4没做归一化处理，图5做了
% figure(4);
% y=begin:1:endNum;
% plot(y, rewardSMDP_part, '-bp','linewidth',2);
% hold on
% plot(y, GA_bian, '-cd','linewidth',2);
% set(gca,'xtick',begin:1:endNum);
% legend('our scheme','greedy scheme');
% xlabel('Maximum number of vehicles');
% ylabel('Long-term reward');
% 
% geshu=endNum - begin + 1;      %归一化
% for i=1:geshu
%      discounted_SMDP(i)=log10(rewardSMDP_part(i));
%      GA_unif(i)=log10(GA_bian(i));
% end
% 
% figure(5);
% t=begin:1:endNum;
% plot(t,  discounted_SMDP, '-r^','linewidth',2);
% hold on
% plot(t,  GA_unif, '-bd','linewidth',2);
% legend('our scheme','greedy scheme');
% xlabel('Maximum number of vehicles');
% ylabel('Long-term reward');