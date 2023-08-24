%% Platoon
%%------------ע�⣬��Щ�ط�d/fҪ����1000
%% ����ÿ��״̬������һ�鶯��
function [s, P, R, discount, delay_all] = data_input_platoon(K,M,lambda_p,lambda_f,u_f,f0,f1,f2,f3,f4,d)
 
%% ����
price = 5;
El = 100; % ��λ���롾ms��
punish = 28;


%% ��ʼ����
alpha = 0.1;       %ʱ���ۿ�����
iter_max = 1;       %����������1
delta = 10;             %  �������������йأ���ȷ��

% ����״̬��ʼ��
[s] = initial_state_platoon(K);

%������
action = [-1,0,10,20,30,40,1,2,3];    
%--10��������ͷ��������ע�⡿�ܲ�ȡ�ö�����ǰ����s{row,2}(1) = s1=0���������ڲ��Ϸ�״̬
% �������ò�ͬ������ֻ��Ϊ�����ֲ�ͬ�Ķ������ѣ��൱�ڸ���ͬ�ı��
%-1Ϊ�����뿪�� 0Ϊ�ܽӴ�������

% ��ʼ��P��R����
N = length(s);   % ״̬������

La = length(action);       
R = zeros(N,La);
P = cell(1,La);
for j = 1 : La
    P{1,j} = zeros(N,N); % ÿ�������£�����״̬���ת�Ƹ���
end

%% ��������
reward = zeros(N,1);% ������N�У�1�� 
reward_unif = zeros(N,1); % ��һ������
k = zeros(N,1);
V = zeros(N,1);
V_old = zeros(N,1);     %�ɵļ�ֵ����
sumpp = zeros(N,1);

delay_all = zeros(N, length(action));

%% ֵ��������
for iter_num = 1 : iter_max
    for i =1: N  % N��ʾ״̬����   k=4ʱ�ܹ�2096��
        %sprintf('********************** i Ϊ %d *****************************', i)
        Vss = [-1000;-1000;-1000;-1000;-1000;-1000;-1000;-1000;-1000];     %�洢10�������µ�ֵ�����ڱȽ�ѡ�����ֵ������a
        for x = 1 : length(action)     %�������ж���  �ܹ�9��
            a = action(x);    % a��Ŀǰ��ȡ�Ķ�����-1,0,10,20,30,40,1,2,3��
            %�����ǰ����a
            %sprintf('aΪ %d',a)
            % *****************************************
            % �޳�������״̬
            % *****************************************
            
            % strcmp(str1,str2)�Ƚ��ַ��� str1 �� str2 ������ȫ����򷵻� 1 ������ȷ��� 0
            % %  �¼�ΪAʱ������a���롾����0��
            if strcmp(s{i,4},'A') && a<0    %�¼�ΪAʱ������a������ڵ���0����������Ϊ-1
                continue;
            end
            
            % % %�¼�ΪD1/2/3/F+1/F-1������a�������-1
            if ~(strcmp(s{i,4},'A')) && a>=0  
                continue; 
            end
            
            if (a>s{i,5})&&(a<10)     %�����i������i���ܴ��ڿ���RU����
                continue;   
            end
            
            % ���s{i,2}(1)������0�����ʾͷ��æµ�����Բ����ٲ�ȡ10�Ķ�����10��ʾ�����ͷ������
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
                              
            T_vehicular = satu_delay_fog(s(i,:),a);  % ������Ľ���ʱ�� ms  ����������Ĵ���ʱ��
%             assert(T_vehicular >= 0)
           
            
            T_platoon = satu_delay_platoon(M);  % �����ӡ��Ľ���ʱ�䣨ֻM�йأ�  ms  Ϊ�����ڴ����ʱ�䣨Tp��
%             assert(T_platoon >= 0)

            % ״̬ת�ƣ����ݵ�ǰ״̬s_current�͵�ǰ����a�����һ״̬��ת�Ƹ��ʺ��¼�������
            % s_next0�У���s_next0{i��6}�����δ��һ����ת�Ƹ���
            [s_next0,pp,sigma] = trans_state_platoon_s(K,M,s(i,:),a,lambda_f,u_f,lambda_p,f0,f1,f2,f3,f4,d);
     
            % ת�Ƹ��ʹ�һ��
            % s_next1�п��ܡ����ˡ���ӵ������״̬
            [pp_unif,s_next1,sigma,flag1] = uniform_state_platoon(s(i,1:5),s_next0,pp,K,M,lambda_p,f0,f1,f2,f3,f4,d,lambda_f,u_f,sigma);
            
            % Ϊ����һ��״̬�£���ȡһ�������������ֵ��������̵� 
%            V_8next = ת�Ƹ���  *  ��һ״̬��״̬��ֵ����
            [V_8next,s_next] = find_index_platoon(s,i,s_next1,N,pp,pp_unif,V_old,flag1);
            
             %�õ�P����
            if flag1 == 1
                len = length(s_next)-1;
            else
                len = length(s_next);
            end
            for m = 1:len
                if (s_next{m,7}>0)    % s_next{i,7}�������һ��״̬������
                    next_state_index = s_next{m,7};
                    P{1,x}(i,next_state_index) = pp_unif(m,1);
                end
            end
            
            %--------------------------------------------------------------
            %�����s��a�µ����ս���
            
            % ��һ����������������k
              %   ����A����ȡ������õ���������
            if strcmp(s{i,4}, 'A')    
                if a == 10        %  �����ͷ��
                    %sprintf('ִ��a Ϊ10ʱ�ļ���**************************************************************************')
                    T_save = (El-T_platoon - (d/f1)*1000 ); %% ���ﵥλ����:���루ms��
                    %sprintf('T_platoon + (d/f1)*1000Ϊ %d',T_platoon + (d/f1)*1000)
%                     delay_all(i, x) = T_platoon + (d/f1)*1000;
                    delay_all(i, x) = T_save;
                    
                    k(i) = price*T_save; %     
                elseif a == 20
                    T_save = (El-T_platoon - (d/f2)*1000 );
                    %sprintf('T_platoon + (d/f2)*1000Ϊ %d',T_platoon + (d/f2)*1000)
%                     delay_all(i, x) = T_platoon + (d/f2)*1000;
                    delay_all(i, x) = T_save;
                    k(i) = price*T_save;
                elseif a == 30
                    T_save = (El-T_platoon-(d/f3)*1000 );
                    %sprintf('T_platoon + (d/f3)*1000Ϊ %d',T_platoon + (d/f3)*1000)
%                     delay_all(i, x) = T_platoon+(d/f3)*1000;
                    delay_all(i, x) = T_save;
                    k(i) = price*T_save;         
               elseif a == 40
                    T_save = (El-T_platoon-(d/f4)*1000 );
                    %sprintf('T_platoon + (d/f4)*1000Ϊ %d',T_platoon + (d/f4)*1000)
%                     delay_all(i, x) = T_platoon+(d/f4)*1000;
                    delay_all(i, x) = T_save;
                    k(i) = price*T_save;                                       
                elseif a == 1
                    T_save = (El- T_platoon-T_vehicular - (d/f0)*1000 );
%                     sprintf('T_platoon + T_vehicular + (d/f0)*1000 Ϊ %d',T_platoon + T_vehicular + (d/f0)*1000)
%                     delay_all(i, x) = T_platoon + T_vehicular + (d/f0)*1000;
                    delay_all(i, x) = T_save;
                    k(i) = price*T_save;
                elseif a == 2
                    T_save = (El- T_platoon-T_vehicular - (d/(2*f0))*1000 );
%                     sprintf('T_platoon+T_vehicular + (d/(2*f0))*1000 Ϊ %d',T_platoon+T_vehicular + (d/(2*f0))*1000)
%                     delay_all(i, x) = T_platoon+T_vehicular + (d/(2*f0))*1000;
                    delay_all(i, x) = T_save;
                    k(i) = price*T_save;
                elseif a == 3
                    T_save = (El- T_platoon-T_vehicular - (d/(3*f0))*1000 );
%                     sprintf('T_platoon + T_vehicular + (d/(3*f0))*1000 Ϊ %d', T_platoon + T_vehicular + (d/(3*f0))*1000)
%                     delay_all(i, x) = T_platoon + T_vehicular + (d/(3*f0))*1000;
                    delay_all(i, x) = T_save;
                    k(i) = price*T_save;
                    % ������
                elseif a == 0
                    k(i) = -punish;   
                end
            end

            %%%%%%%%%%%%%delay
%             delay_all(i, x) = T_platoon + T_vehicular + (d/(3*f0))*1000;

            %%%%%%%%%%%%%%%%%%
            
            if a == -1&&(strcmp(s{i,4}, 'D1')||strcmp(s{i,4}, 'D2')||strcmp(s{i,4}, 'D3')||strcmp(s{i,4}, 'D4')||strcmp(s{i,4}, 'L1')||strcmp(s{i,4}, 'L2')||strcmp(s{i,4}, 'L3')||strcmp(s{i,4}, 'F+1')) %�����뿪+������
                k(i) = 0;
            elseif a == -1&&strcmp(s{i,4}, 'F-1')
                if s{i,5}==0 %RUȫռ��ʱ�������뿪,ϵͳ�ͷ�
                    k(i) = -punish;
                else
                    k(i) = 0;
                end
            end
               

            % �ڶ����������ۿ�����
            b = s{i,2}(1)+s{i,2}(2)+s{i,2}(3)+s{i,2}(4) + s{i,3}(1)*1+s{i,3}(2)*2+ s{i,3}(3)*3;    %æµRU����
            reward(i) = k(i)-b/(alpha+sigma);   %����=��������-�ۿ�����   Rewards:N��4��  N*4
            
            %    �������Ȼ�   Rewards:N��4��  N*4
            [reward_unif1] = uniform_reward_platoon(K,M,lambda_p,f0,f1,f2,f3,f4,d,lambda_f,u_f,reward(i),alpha,sigma);
            reward_unif(i) = reward_unif1;
            
            % �õ�R����
            R(i,x) = reward_unif(i);
            
            %    �ۿ��ʾ��Ȼ�
%            [discount_unif] = uniform_discount_new(K,lambda_1,lambda_2,u_t,lambda_f,u_f,alpha);
            [discount_unif] = uniform_discount_platoon(K,M,lambda_p,f0,f1,f2,f3,f4,d,lambda_f,u_f,alpha);
            discount = discount_unif;
            
            Vss(x) = reward_unif(i)+discount_unif*sum(V_8next);   % ÿ�������£���״̬��ֵ����

 %*************************************************************************
 %  �������ϣ����е�״̬�����ܶ�����������һ�飬�������ˡ���ͬ��������ֵ����
 %*************************************************************************
        end     %���ж���ѭ������
       
        %����bellman���ŷ��̣�ѡһ������������V
        %    �������ж�����ֵ�����У�����ֵ����  +  ���Ӧ��������
        [max_value,max_index] = max(Vss);
        s{i,6} = action(max_index);  %  s{i��6}�������Ѷ���
        V(i) = max_value;   %   ���ÿһ��״̬����Ѷ����£�״̬��ֵ����  N*1
        
        sumpp(i)=sum(pp);

 %*************************************************************************
 %  �������ϣ����е�״̬�����ܶ�����������һ�飬���õ�����Ѷ�����s{i,6}�Լ��䡾ֵ������N*1
 %*************************************************************************
    end   %����״̬ѭ������
    
    conv1 = delta*(1-discount_unif)/(2*discount_unif);  %   ֵ������������
    if iter_num>1
        delta_iter = sum(abs(V-V_old))/N;
    end
    V_old = V;    %ֵ��������
    
    if (iter_num>1)
        if (delta_iter < conv1)
            break;
        end
    end
end     %���е�������ѭ������
%}
