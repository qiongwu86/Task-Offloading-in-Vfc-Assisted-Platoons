% 求解车队中接入时延
function T_platoon = satu_delay_platoon(N)
% N--车队中车辆数目（M）
W = 3; %Wmin————
m = 1; % 重传次数

[p,Tslot] = satu_iteration_platoon(N,W,m);%p——碰撞概率；Tslot——平均时隙时间

%% 文中公式
EN1=(1-(m+2)*p^(m+1)+(m+1)*p^(m+2))/(2*(1-p)) + ((1-p)*(1-(2*p)^(m+1))*W)/(1-2*p) - (1-p^(m+1))*W/2;
EN2=0.5*(p^(m+1))*( m+1 + ( (2^(m+1)) - 1 )*W + ( (((2^m)*W) + 1)*(2-p) )/(1-p) );
EN = (EN1 + EN2);
ED = EN*Tslot/1000000;    %单位s------传输一个子任务消耗的时延

% 求到达率和传输时间
   D_access = ED;  %单位s

T_platoon = D_access*1000;  %ms



