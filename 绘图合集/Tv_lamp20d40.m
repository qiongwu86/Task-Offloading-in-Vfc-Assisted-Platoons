%============================K变化，图形好看
K = 4   % 【车载云】中，车辆总数【车载云】 (4-10)  
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
d =  30;  
%-------------------------------------------------------------------
Tv1 = [4.2261, 6.0729, 8.5465, 11.9027, 16.5003, 22.8414, 31.6280, ];  % 一个RU传输到VFC时间
Tv2 = [5.9956, 8.6034, 12.0956, 16.8338, 23.3245, 32.2765, 44.6811, ];
Tv3 = [7.7651,11.1338, 15.6448, 21.7649, 30.1486, 41.7116, 57.7341, ];

D_Tv1 = [1.2133e+02, 1.2318e+02, 1.2565e+02, 1.2901e+02, 1.3361e+02, 1.3995e+02, 1.4873e+02, ];  %总时延（传输+处理）
D_Tv2 = [6.5963e+01, 6.8571e+01, 7.2063e+01, 7.6801e+01, 8.3292e+01, 9.2244e+01, 1.0464e+02, ];
D_Tv3 = [4.8685e+01, 5.2054e+01, 5.6565e+01, 6.2685e+01, 7.1069e+01, 8.2632e+01, 9.8654e+01, ];

% reward of system
rewardSMDP_part = [4.6965e+05, 9.5452e+05, 1.8183e+06, 3.1712e+06, 5.0450e+06, 7.3409e+06, 9.7793e+06, ];
GA_bian =         [4.1103e+04, 6.5547e+04, 9.8244e+04, 1.3796e+05, 1.8576e+05, 2.4455e+05, 3.1506e+05, ];
gap=1;
begin = 4; endNum = 10;

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
xlabel('Maximum number of vehicles');
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
xlabel('Maximum number of vehicles');
ylabel('Delay of offloading a task (ms)'); 


% reward--------要做归一化处理，不然图形不好看,图4没做归一化处理，图5做了
figure(4);
y=begin:1:endNum;
plot(y, rewardSMDP_part, '-bp','linewidth',2);
hold on
plot(y, GA_bian, '-cd','linewidth',2);
set(gca,'xtick',begin:1:endNum);
legend('our scheme','greedy scheme');
xlabel('Maximum number of vehicles');
ylabel('Long-term reward');

geshu=endNum - begin + 1;      %归一化
for i=1:geshu
     discounted_SMDP(i)=log10(rewardSMDP_part(i));
     GA_unif(i)=log10(GA_bian(i));
end

figure(5);
t=begin:1:endNum;
plot(t,  discounted_SMDP, '-r^','linewidth',2);
hold on
plot(t,  GA_unif, '-bd','linewidth',2);
legend('our scheme','greedy scheme');
xlabel('Maximum number of vehicles');
ylabel('Long-term reward');