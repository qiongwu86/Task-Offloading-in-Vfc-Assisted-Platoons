%============================K变化，图形好看
K = 4   % 【车载云】中，车辆总数【车载云】 (4-10)  
M = 4;  % 车队中车辆总数

lambda_f =9;     %车辆到达率【秒】
u_f = 8;            %车辆离开率【秒】
lambda_p = 25;        %任务到达率【秒】

% 任务离开率  u_p = f/d 单位为s
f0 = 560;  %===============================550不行

f1 = 600;   %分配给头车
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  30;  
%-------------------------------------------------------------------
A1 = [0.2121, 0.1429, 0.1046, 0.1041, 0.1002, 0.1187, 0.1369, ];  % 车载云
A2 = [0.4545, 0.2987, 0.2484, 0.1710, 0.1614, 0.1854, 0.2190, ];
A3 = [0.3333, 0.5584, 0.6471, 0.7249, 0.7384, 0.6958, 0.6442, ];

Case0 = [0.8880, 0.8562, 0.8264, 0.8012, 0.7921, 0.8231, 0.8495, ];  
Case1 = [0.0859, 0.1203, 0.1518, 0.1789, 0.1894, 0.1596, 0.1343, ];
Case2 = [0.0260, 0.0234, 0.0218, 0.0199, 0.0185, 0.0173, 0.0162, ];

% reward of system
rewardSMDP_part = [3.5843e+05, 6.9554e+05, 1.2673e+06, 2.1631e+06, 3.4594e+06, 5.1150e+06, 6.9083e+06, ];
GA_bian =         [3.9172e+04, 6.2151e+04, 9.3251e+04, 1.3159e+05, 1.7668e+05, 2.2923e+05, 2.9378e+05, ];
gap=1;
begin = 4; endNum = 10;

figure(2);
y=begin:1:endNum;
plot(y, A1, '-bo','linewidth',2);
hold on
plot(y, A2, '-cd','linewidth',2);   %蓝色
hold on 
plot(y, A3, '-rs','linewidth',2);
set(gca,'xtick',begin:1:endNum);
%ylim([0.08,0.6])
legend('A1','A2','A3');
xlabel('最大车辆数目');
ylabel('车载雾中动作概率'); 


figure(3);
y=begin:1:endNum;
plot(y, Case0, '-bp','linewidth',2);
hold on
plot(y, Case1, '-rd','linewidth',2);   %蓝色
hold on 
plot(y, Case2, '-cs','linewidth',2);
% ylim([0.2,0.85])
% set(gca,'xtick',9:1:13);
set(gca,'xtick',begin:1:endNum);
legend('Case 0','Case 1','Case 2');
xlabel('最大车辆数目');
ylabel('动作概率'); 


% reward--------要做归一化处理，不然图形不好看,图4没做归一化处理，图5做了
figure(4);
y=begin:1:endNum;
plot(y, rewardSMDP_part, '-bp','linewidth',2);
hold on
plot(y, GA_bian, '-cd','linewidth',2);
set(gca,'xtick',begin:1:endNum);
legend('SMDP策略','贪婪策略');
xlabel('最大车辆数目');
ylabel('系统长期收益');

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
legend('SMDP策略','贪婪策略');
xlabel('最大车辆数目');
ylabel('系统长期收益');