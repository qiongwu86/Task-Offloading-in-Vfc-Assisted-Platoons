function T_vehicular = satu_delay_fog(s_current,a)

W = 3; %Wmin��������
m = 1; % �ش�����
N =s_current{1,1} + 1; %��ǰ״̬�������� + ͷ������

[p,Tslot] = satu_iteration_fog(N,W,m,a);%p������ײ���ʣ�Tslot����ƽ��ʱ϶ʱ��

%% ���й�ʽ
EN1=(1-(m+2)*p^(m+1)+(m+1)*p^(m+2))/(2*(1-p)) + ((1-p)*(1-(2*p)^(m+1))*W)/(1-2*p) - (1-p^(m+1))*W/2;
EN2=0.5*(p^(m+1))*( m+1 + ( (2^(m+1)) - 1 )*W + ( (((2^m)*W) + 1)*(2-p) )/(1-p) );
EN = (EN1 + EN2);
ED = EN*Tslot/1000000;    %��λs------����һ�����������ĵ�ʱ��

% �󵽴��ʺʹ���ʱ��
   D_access = a*ED;  %��λs

T_vehicular = D_access*1000;  %ms
if (s_current{1,1} == 6)&& (a==1)
    sprintf('K=6,a=1')
    T_vehicular
  
end
if (s_current{1,1} == 6)&& (a==2)
    sprintf('K=6,a=2')
    T_vehicular
  
end
if (s_current{1,1} == 6)&& (a==3)
    sprintf('K=6,a=3')
    T_vehicular
  
end

