%============================K�仯��ͼ�κÿ�
K = 4   % �������ơ��У����������������ơ� (4-10)  
M = 4;  % �����г�������

lambda_f =9;     %���������ʡ��롿
u_f = 8;            %�����뿪�ʡ��롿
lambda_p = 20;        %���񵽴��ʡ��롿

% �����뿪��  u_p = f/d ��λΪs
f0 = 560;  %===============================550����

f1 = 600;   %�����ͷ��
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  30;  
%-------------------------------------------------------------------
A1 = [1, 0.6316, 0.5067, 0.4351, 0.4850, 0.5236, 0.5526, ];  % ������
A2 = [0, 0.0789, 0.0667, 0.0687, 0.0898, 0.1226, 0.1504, ];
A3 = [0, 0.2895, 0.4267, 0.4962, 0.4251, 0.3538, 0.2970, ];

Case0 = [0.9375, 0.9172, 0.9038, 0.8930, 0.9042, 0.9122, 0.9186, ];  
Case1 = [0.0365, 0.0594, 0.0744, 0.0871, 0.0773, 0.0705, 0.0652, ];
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
plot(y, A2, '-cd','linewidth',2);   %��ɫ
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
plot(y, Case1, '-rd','linewidth',2);   %��ɫ
hold on 
plot(y, Case2, '-cs','linewidth',2);
% ylim([0.2,0.85])
% set(gca,'xtick',9:1:13);
set(gca,'xtick',begin:1:endNum);
legend('Case 0','Case 1','Case 2');
xlabel('Maximum number of vehicles');
ylabel('Action probability'); 


% reward--------Ҫ����һ��������Ȼͼ�β��ÿ�,ͼ4û����һ������ͼ5����
figure(4);
y=begin:1:endNum;
plot(y, rewardSMDP_part, '-bp','linewidth',2);
hold on
plot(y, GA_bian, '-cd','linewidth',2);
set(gca,'xtick',begin:1:endNum);
legend('our scheme','greedy scheme');
xlabel('Maximum number of vehicles');
ylabel('Long-term reward');

geshu=endNum - begin + 1;      %��һ��
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