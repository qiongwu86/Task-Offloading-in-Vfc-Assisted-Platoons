%============================K变化，图形好看
K = 4   % 【车载云】中，车辆总数【车载云】 (4-10)  
M = 4;  % 车队中车辆总数

lambda_f =9;     %车辆到达率【秒】
u_f = 8;            %车辆离开率【秒】
lambda_p = 13;        %任务到达率【秒】

% 任务离开率  u_p = f/d 单位为s
f0 = 560;  %===============================550不行

f1 = 600;   %分配给头车
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  40;  
%-------------------------------------------------------------------
A1 = [0.6111, 0.4490, 0.3469, 0.2722, 0.2918, 0.3194, 0.3130, ];  % 车载云
A2 = [0.2778, 0.1224, 0.1020, 0.0944, 0.1159, 0.1389, 0.2029, ];
A3 = [0.1111, 0.4286, 0.5510, 0.6333, 0.5923, 0.5417, 0.4841, ];

Case0 = [0.9271, 0.9000, 0.8810, 0.8604, 0.8736, 0.8870, 0.8993, ];  
Case1 = [0.0469, 0.0766, 0.0972, 0.1197, 0.1079, 0.0957, 0.0846, ];
Case2 = [0.0260, 0.0234, 0.0218, 0.0199, 0.0185, 0.0173, 0.0162, ];

% reward of system
rewardSMDP_part = [8.8641e+05, 1.7805e+06, 3.1650e+06, 5.0015e+06, 7.2119e+06, 9.7568e+06, 1.2463e+07, ];
GA_bian =         [3.7781e+04, 6.0087e+04, 8.9930e+04, 1.2619e+05, 1.6967e+05, 2.2322e+05, 2.8751e+05, ];
Equa =            [7.9761e+03, 1.3627e+04, 2.2319e+04, 2.6594e+04, 3.4966e+04, 4.4057e+04, 4.9256e+04, ]; 
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
hold on 
plot(y,Equa,"-r^",'linewidth',2);
set(gca,'xtick',begin:1:endNum);
legend('our scheme','greedy scheme',"equal probability scheme");
xlabel('Maximum number of vehicles');
ylabel('Long-term reward');

geshu=endNum - begin + 1;      %归一化
for i=1:geshu
     discounted_SMDP(i)=log10(rewardSMDP_part(i));
     GA_unif(i)=log10(GA_bian(i));
     Equa_unif(i)=log10(Equa(i))
end

figure(5);
t=begin:1:endNum;
plot(t,  discounted_SMDP, '-r^','linewidth',2);
hold on
plot(t,  GA_unif, '-bd','linewidth',2);
hold on
plot(t,  Equa_unif, '-g>','linewidth',2);
legend('our strategy','greedy strategy',"equal probability strategy");
xlabel('Maximum number of vehicles');
ylabel('Long-term reward');