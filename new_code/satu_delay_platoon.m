% ��⳵���н���ʱ��
function T_platoon = satu_delay_platoon(N)
% N--�����г�����Ŀ��M��
W = 3; %Wmin��������
m = 1; % �ش�����

[p,Tslot] = satu_iteration_platoon(N,W,m);%p������ײ���ʣ�Tslot����ƽ��ʱ϶ʱ��

%% ���й�ʽ
EN1=(1-(m+2)*p^(m+1)+(m+1)*p^(m+2))/(2*(1-p)) + ((1-p)*(1-(2*p)^(m+1))*W)/(1-2*p) - (1-p^(m+1))*W/2;
EN2=0.5*(p^(m+1))*( m+1 + ( (2^(m+1)) - 1 )*W + ( (((2^m)*W) + 1)*(2-p) )/(1-p) );
EN = (EN1 + EN2);
ED = EN*Tslot/1000000;    %��λs------����һ�����������ĵ�ʱ��

% �󵽴��ʺʹ���ʱ��
   D_access = ED;  %��λs

T_platoon = D_access*1000;  %ms



