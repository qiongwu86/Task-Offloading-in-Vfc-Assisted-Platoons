%============================K�仯��ͼ�κÿ�,f0 = 560
K = 4   % �������ơ��У����������������ơ� (4-10)  
M = 4;  % �����г�������

lambda_f =9;     %���������ʡ��롿
u_f = 8;            %�����뿪�ʡ��롿
lambda_p = 10;        %���񵽴��ʡ��롿

% �����뿪��  u_p = f/d ��λΪs
f0 = 350;  %===============================550����

f1 = 600;   %�����ͷ��
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  40;  
%-------------------------------------------------------------------
A1 = [0.9286, 0.5500, 0.3953, 0.2941, 0.2609, 0.2813, 0.0000, ];  % ������
A2 = [0.0714, 0.0750, 0.0698, 0.0765, 0.1787, 0.2109, 0.0000, ];
A3 = [0.0000, 0.3750, 0.5349, 0.6294, 0.5604, 0.5078, 0.0000, ];

Case0 = [0.9375, 0.9141, 0.8929, 0.8670, 0.8856, 0.8976, 0.0000, ];  
Case1 = [0.0365, 0.0625, 0.0853, 0.1130, 0.0958, 0.0851, 0.0000, ];
Case2 = [0.0260, 0.0234, 0.0218, 0.0199, 0.0185, 0.0173, 0.0000, ];

% reward of system
rewardSMDP_part = [1.4811e+06, 2.3123e+06, 3.3643e+06, 4.5658e+06, 5.8656e+06, 7.3451e+06, 9.0372e+06];
GA_bian = [4.3644e+04, 6.8879e+04, 1.0278e+05, 1.4435e+05, 1.9301e+05, 2.5002e+05, 3.1974e+05, ];

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
ylim([0.08,0.6])
legend('A1','A2','A3');
xlabel('�������Ŀ');
ylabel('�������ж�������'); 


figure(3);
y=begin:1:endNum;
plot(y, Case0, '-bp','linewidth',2);
hold on
plot(y, Case1, '-rd','linewidth',2);   %��ɫ
hold on 
plot(y, Case2, '-cs','linewidth',2);
set(gca,'xtick',begin:1:endNum);
% ylim([0.1,0.85])
% set(gca,'xtick',9:1:13);
legend('Case 0','Case 1','Case 2');
xlabel('�������Ŀ');
ylabel('��������'); 


% reward--------Ҫ����һ��������Ȼͼ�β��ÿ�,ͼ4û����һ������ͼ5����
figure(4);
y=begin:1:endNum;
plot(y, rewardSMDP_part, '-bp','linewidth',2);
hold on
plot(y, GA_bian, '-cd','linewidth',2);
set(gca,'xtick',begin:1:endNum);
legend('SMDP����','̰������');
xlabel('�������Ŀ');
ylabel('ϵͳ��������');

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
legend('SMDP����','̰������');
xlabel('�������Ŀ');
ylabel('ϵͳ��������');
%}

