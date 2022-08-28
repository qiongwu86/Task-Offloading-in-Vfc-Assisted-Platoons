%% Platoon
%%------------注意，那些地方d/f要乘以1000
%% 对于每个状态，都走一遍动作
function [s, P, R, discount] = data_input_platoon(K,M,lambda_p,lambda_f,u_f,f0,f1,f2,f3,f4,d)
 
%% 参数
price = 5;
El = 100; % 单位毫秒【ms】
punish = 28;


%% 初始参数
alpha = 0.1;       %时间折扣因子
iter_max = 1;       %最大迭代次数1
delta = 10;             %  与计算收敛误差有关，精确度

% 所有状态初始化
[s] = initial_state_platoon(K);

%动作集
action = [-1,0,10,20,30,40,1,2,3];    %--10代表分配给头车处理，【注意】能采取该动作的前提是s{row,2}(1) = s1=0，否则，属于不合法状态

% 初始化P，R矩阵
N = length(s);   % 状态的总数
La = length(action);       
R = zeros(N,La);
P = cell(1,La);
for j = 1 : La
    P{1,j} = zeros(N,N); % 每个动作下，各个状态间的转移概率
end

%% 其他设置
reward = zeros(N,1);% 奖励，N行，1列 
reward_unif = zeros(N,1); % 归一化奖励
k = zeros(N,1);
V = zeros(N,1);
V_old = zeros(N,1);     %旧的价值函数
sumpp = zeros(N,1);


%% 值迭代过程
for iter_num = 1 : iter_max
    for i =1: N  % N表示状态总数
        Vss = [-1000;-1000;-1000;-1000;-1000;-1000;-1000;-1000;-1000];     %存储10个动作下的值，用于比较选出最大值函数的a
        for x = 1 : length(action);      %遍历所有动作
            a = action(x);    % a是目前采取的动作（-1,0,10,20,30,40,1,2,3）
            
            % *****************************************
            % 剔除不合理状态
            % *****************************************
            % %  事件为A时，动作a必须【大于0】
            if strcmp(s{i,4},'A') && a<0    %事件为A时，动作a必须大于等于0，即，不能为-1
                continue;
            end
            
            % % %事件为D1/2/3/F+1/F-1，动作a必须大于-1
            if ~(strcmp(s{i,4},'A')) && a>=0  
                continue; 
            end
            
            if (a>s{i,5})&&(a<10)     %分配给i个车，i不能大于空闲RU总数
                continue;   
            end
            
            % 如果s{i,2}(1)不等于0，则表示头车忙碌，所以不能再采取10的动作，10表示分配给头车处理
            if (s{i,2}(1)~=0) &&(a == 10)
                continue;
            end

            if (s{i,2}(2)~=0) &&(a == 20)
                continue;
            end
            
            if (s{i,2}(3)~=0) &&(a == 30)
                continue;
            end                           
            
            if (s{i,2}(4)~=0) &&(a == 40)
                continue;
            end
                              
            T_vehicular = satu_delay_fog(s(i,:),a);  % 车载雾的接入时间 ms
            
            T_platoon = satu_delay_platoon(M);  % 【车队】的接入时间（只M有关）   ms
             
            % 状态转移：根据当前状态s_current和当前动作a求出下一状态、转移概率和事件总速率
            % s_next0中，【s_next0{i，6}】存放未归一化的转移概率
            [s_next0,pp,sigma] = trans_state_platoon_s(K,M,s(i,:),a,lambda_f,u_f,lambda_p,f0,f1,f2,f3,f4,d);
     
            % 转移概率归一化
            % s_next1有可能【补了】添加到自身的状态
            [pp_unif,s_next1,sigma,flag1] = uniform_state_platoon(s(i,1:5),s_next0,pp,K,M,lambda_p,f0,f1,f2,f3,f4,d,lambda_f,u_f,sigma);
            
            % 为求：在一个状态下，采取一个动作，所获得值函数求解铺垫 
%            V_8next = 转移概率  *  下一状态的状态价值函数
            [V_8next,s_next] = find_index_platoon(s,i,s_next1,N,pp,pp_unif,V_old,flag1);
            
             %得到P矩阵
            if flag1 == 1
                len = length(s_next)-1;
            else
                len = length(s_next);
            end
            for m = 1:len
                if (s_next{m,7}>0)    % s_next{i,7}存放了下一个状态的索引
                    next_state_index = s_next{m,7};
                    P{1,x}(i,next_state_index) = pp_unif(m,1);
                end
            end
            
            %--------------------------------------------------------------
            %计算该s和a下的最终奖励
            
            % 第一步：计算立即收益k
              %   到达A，采取动作获得的立即奖励
            if strcmp(s{i,4}, 'A')    
                if a == 10        %  分配给头车
                    T_save = (El-T_platoon - (d/f1)*1000 ); %% 这里单位都是:毫秒（ms）
                    k(i) = price*T_save; %     
                elseif a == 20
                    T_save = (El-T_platoon - (d/f2)*1000 );
                    k(i) = price*T_save;
                elseif a == 30
                    T_save = (El-T_platoon-(d/f3)*1000 );
                    k(i) = price*T_save;         
               elseif a == 40
                    T_save = (El-T_platoon-(d/f4)*1000 );
                    k(i) = price*T_save;                                       
                elseif a == 1
                    T_save = (El- T_platoon-T_vehicular - (d/f0)*1000 );
                    k(i) = price*T_save;
                elseif a == 2
                    T_save = (El- T_platoon-T_vehicular - (d/(2*f0))*1000 );
                    k(i) = price*T_save;
                elseif a == 3
                    T_save = (El- T_platoon-T_vehicular - (d/(3*f0))*1000 );
                    k(i) = price*T_save;
                    % 丢弃包
                elseif a == 0
                    k(i) = -punish;   
                end
            end
            
            if a == -1&&(strcmp(s{i,4}, 'D1')||strcmp(s{i,4}, 'D2')||strcmp(s{i,4}, 'D3')||strcmp(s{i,4}, 'D4')||strcmp(s{i,4}, 'L1')||strcmp(s{i,4}, 'L2')||strcmp(s{i,4}, 'L3')||strcmp(s{i,4}, 'F+1')) %请求离开+车到达
                k(i) = 0;
            elseif a == -1&&strcmp(s{i,4}, 'F-1')
                if s{i,5}==0 %RU全占满时，车辆离开,系统惩罚
                    k(i) = -punish;
                else
                    k(i) = 0;
                end
            end
               

            % 第二步：计算折扣消耗
            b = s{i,2}(1)+s{i,2}(2)+s{i,2}(3)+s{i,2}(4) + s{i,3}(1)*1+s{i,3}(2)*2+ s{i,3}(3)*3;    %忙碌RU个数
            reward(i) = k(i)-b/(alpha+sigma);   %奖励=立即收益-折扣消耗   Rewards:N行4列  N*4
            
            %    奖励均匀化   Rewards:N行4列  N*4
            [reward_unif1] = uniform_reward_platoon(K,M,lambda_p,f0,f1,f2,f3,f4,d,lambda_f,u_f,reward(i),alpha,sigma);
            reward_unif(i) = reward_unif1;
            
            % 得到R矩阵
            R(i,x) = reward_unif(i);
            
            %    折扣率均匀化
%            [discount_unif] = uniform_discount_new(K,lambda_1,lambda_2,u_t,lambda_f,u_f,alpha);
            [discount_unif] = uniform_discount_platoon(K,M,lambda_p,f0,f1,f2,f3,f4,d,lambda_f,u_f,alpha);
            discount = discount_unif;
            
            Vss(x) = reward_unif(i)+discount_unif*sum(V_8next);   % 每个动作下，的状态价值函数

 %*************************************************************************
 %  至此以上，所有的状态，可能动作都遍历了一遍，并计算了【不同动作】的值函数
 %*************************************************************************
        end     %所有动作循环结束
       
        %根据bellman最优方程，选一个最大的来更新V
        %    返回所有动作的值函数中，最大的值函数  +  相对应动作索引
        [max_value,max_index] = max(Vss);
        s{i,6} = action(max_index);  %  s{i，6}，存放最佳动作
        V(i) = max_value;   %   存放每一个状态，最佳动作下，状态价值函数  N*1
        
        sumpp(i)=sum(pp);

 %*************************************************************************
 %  至此以上，所有的状态，可能动作都遍历了一遍，并得到【最佳动作】s{i,6}以及其【值函数】N*1
 %*************************************************************************
    end   %所有状态循环结束
    
    conv1 = delta*(1-discount_unif)/(2*discount_unif);  %   值迭代结束条件
    if iter_num>1
        delta_iter = sum(abs(V-V_old))/N;
    end
    V_old = V;    %值函数更新
    
    if (iter_num>1)
        if (delta_iter < conv1)
            break;
        end
    end
end     %所有迭代次数循环计算
%}
