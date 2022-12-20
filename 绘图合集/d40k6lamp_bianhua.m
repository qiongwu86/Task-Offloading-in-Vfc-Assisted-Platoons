%============================K�仯��ͼ�κÿ�
K = 6   % �������ơ��У����������������ơ� (4-10)  
M = 4;  % �����г�������

lambda_f =9;     %���������ʡ��롿
u_f = 8;            %�����뿪�ʡ��롿
lambda_p = 20;        %���񵽴��ʡ��롿15-25

% �����뿪��  u_p = f/d ��λΪs
f0 = 560;  %===============================550����

f1 = 600;   %�����ͷ��
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  40;  
%-------------------------------------------------------------------
A1 = [0.2857, 0.2479, 0.2283, 0.2015, 0.1773, 0.1667, 0.1575, 0.1409, 0.1267, 0.1097, 0.1046, ];  % ������
A2 = [0.1071, 0.1322, 0.1496, 0.1791, 0.1773, 0.1736, 0.1712, 0.1812, 0.1933, 0.2194, 0.2484, ];
A3 = [0.6071, 0.6198, 0.6220, 0.6194, 0.6454, 0.6597, 0.6712, 0.6779, 0.6800, 0.6710, 0.6471, ];

Case0 = [0.8671, 0.8581, 0.8522, 0.8452, 0.8383, 0.8353, 0.8333, 0.8304, 0.8294, 0.8244, 0.8264, ];  
Case1 = [0.1111, 0.1200, 0.1260, 0.1392, 0.1399, 0.1429, 0.1448, 0.1478, 0.1488, 0.1538, 0.1518, ];
Case2 = [0.0218, 0.0218, 0.0218, 0.0218, 0.0218, 0.0218, 0.0218, 0.0218, 0.0218, 0.0218, 0.0218, ];

% reward of system
rewardSMDP_part = [2.7769e+06, 2.5664e+06, 2.3591e+06, 2.1628e+06, 1.9821e+06, 1.8183e+06, 1.6726e+06, 1.5461e+06, 1.4378e+06, 1.3447e+06, 1.2673e+06, ];
GA_bian =         [9.2465e+04, 9.3682e+04, 9.4867e+04, 9.6022e+04, 9.7147e+04, 9.8244e+04, 9.9313e+04, 1.0036e+05, 1.0137e+05, 1.0237e+05, 1.0334e+05, ];
gap=1;
begin = 15; endNum = 25;

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
xlabel('Task arriving rate');
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
xlabel('Task arriving rate');
ylabel('Action probability'); 


% reward--------Ҫ����һ��������Ȼͼ�β��ÿ�,ͼ4û����һ������ͼ5����
figure(4);
y=begin:1:endNum;
plot(y, rewardSMDP_part, '-bp','linewidth',2);
hold on
plot(y, GA_bian, '-cd','linewidth',2);
set(gca,'xtick',begin:1:endNum);
legend('our strategy','greedy strategy');
xlabel('Task arriving rate');  %��ͬ���񵽴���lamp�µĸ�������ָ��
ylabel('Long-term reward');  %���ڽ���

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
legend('our strategy','greedy strategy');
xlabel('Task arriving rate');
ylabel('Long-term reward');