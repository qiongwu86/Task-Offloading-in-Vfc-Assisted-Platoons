function[p,Tslot] = satu_iteration_platoon(N,W,m)

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
Rate=11;
slot=20;
DIFS=50;
SIFS=10;
delta=2;
Header=(272+128)/Rate;   %������������272 + 128 = MACh + PHYh  ??ΪʲôҪ����rate
L=64*30/Rate;   %----- ?? ΪʲôҪ����rate

EP=L;

ACK=(112+128)/Rate;%128--192
Ts=Header+EP+SIFS+ACK+DIFS+2*delta;
Tc=Ts;

Tslot = Pidle*slot+Pc*Tc+Ps*Ts;      %-----Tslotƽ��ʱ϶ʱ�䣻slotΪһ��ʱ϶��ʱ�䣻
