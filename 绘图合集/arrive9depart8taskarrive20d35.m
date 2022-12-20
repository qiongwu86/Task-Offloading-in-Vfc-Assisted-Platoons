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
d =  35;  
%-------------------------------------------------------------------
A1 = [0.5217, 0.4000, 0.3434, 0.2890, 0.2917, 0.3287, 0.3709, ];  % 车载云
A2 = [0.2609, 0.1455, 0.1313, 0.1156, 0.1292, 0.1522, 0.1958, ];
A3 = [0.2174, 0.4545, 0.5253, 0.5954, 0.5792, 0.5190, 0.4332, ];

Case0 = [0.9141, 0.8906, 0.8800, 0.8650, 0.8704, 0.8866, 0.9012, ];  
Case1 = [0.0599, 0.0859, 0.0982, 0.1150, 0.1111, 0.0961, 0.0826, ];
Case2 = [0.0260, 0.0234, 0.0218, 0.0199, 0.0185, 0.0173, 0.0162, ];

% reward of system
rewardSMDP_part = [4.6965e+05, 9.5452e+05, 1.8183e+06, 3.1712e+06, 5.0450e+06, 7.3409e+06, 9.7793e+06, ];
GA_bian =         [4.1103e+04, 6.5547e+04, 9.8244e+04, 1.3796e+05, 1.8576e+05, 2.4455e+05, 3.1506e+05, ];
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
xlabel('Maximum number of vehicles');
ylabel('Action probability'); 


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
xlabel('Maximum number of vehicles');
ylabel('Action probability'); 


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