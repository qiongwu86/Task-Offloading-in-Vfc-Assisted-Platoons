function[p,Tslot] = satu_iteration_fog(N,W,m,a)

% %���Բ���
% clear;
% N=4;
% a = 1;
% W = 3;
% m = 1;

%*****************����*****************
tao=0.0001;
for i =1:10000
    p = 1-(1-tao)^(N-1);%�����ⲿ��ײ����
    tao1 = 2*(1-2*p)/((1-2*p)*(W+1)+p*W*(1-(2*p)^m)); %���䷢�͸���
    conv = abs(tao1-tao);
    if conv<10^(-12)
        break;
    else
        tao=tao1;
    end
end
%**************************************

Pidle = (1-tao)^N;  %���и���
Ps =  N*tao*(1-tao)^(N-1);   %�ɹ�����
Pc = 1-Ps-Pidle;    %��ͻ����

%DCF����
Rate=11;  %����������λMbps
slot=20;  %----- һ��ʱ϶��ʱ��
DIFS=50;
SIFS=10;  %����������λus
delta=2;
Header=(272+128)/Rate;   %������������272 + 128 = MACh + PHYh  bytes/Mbps  =  us
L=64*30/Rate;   %----- ?? ΪʲôҪ����rate���ŵ������ʣ�
if a<=0
    EP=L;
else
    EP=L/a;
end
ACK=(112+128)/Rate;   %������������us
Ts=Header+EP+SIFS+ACK+DIFS+2*delta;
Tc=Ts;

Tslot = Pidle*slot+Pc*Tc+Ps*Ts;      %-----Tslotƽ��ʱ϶ʱ�䣻slotΪһ��ʱ϶��ʱ�䣻



