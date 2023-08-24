% ״̬ת�ƣ����ݵ�ǰ״̬s_current�͵�ǰ����a�����һ״̬��ת�Ƹ��ʺ��¼�������
% ���ʲ�Ϊ1
function [s_next,pp,sigma] = trans_state_platoon_s(K,M, s_current,a,lambda_f,u_f,lambda_p,f0,f1,f2,f3,f4,d)
     %----------ע�⣺��K���ǳ����Ƶĳ�����-------------%
%���Բ���

%��ӿհ�״̬������һ��λ�ã������һ��ת�Ƹ���ʱҪ�õ�
%  s_next  ������s{i,6}��                event, remianer, s_next{i,6}δ��һ������   
s_add={0,[0,0,0,0],[0,0,0],' ',0,0};

%% ���󵽴�A
%RUȫռ��ʱ���󵽴�ͷ�����������ֹ״̬********************************************************************
% % ���ʡ���������˵a == 0,��ʾ�ܾ�ж����������ô�о����ǰ��������������һ��״̬�ĸ��ʶ���0��
if strcmp(s_current{4} , 'A') && (s_current{1,2}(1)==0) && (a == 10)  %������񵽴��ͷ��״̬Ϊ0������Է����ͷ������a==10��
    if s_current{1} == 1     %��鳵����RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��
    end
   
    if s_current{1} == K     %��鳵����RU�����Ƿ�ΪK,�ǵĻ�����û�е����������Ϊ1
        lambda_f = 0;    %   
    end
    
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
    sigma=M*(lambda_p) + ( (s_current{1,2}(1)+1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f;
    %   ��ע�⡿��s{4}�������Ƿ��¼��ˣ�   ��������ȡa==10����һ��״̬��s{1,2}(1)==1��
    s_next1 = s_current; s_next1{1,2}(1)=s_next1{1,2}(1)+1;s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;    %��һ��A����
    s_next2 = s_current; s_next2{1,2}(1)=s_next2{1,2}(1)+1;s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;    %��һ��D1����
    s_next3 = s_current; s_next3{1,2}(1)=s_next3{1,2}(1)+1;s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;   %��һ��D2����
    s_next4 = s_current; s_next4{1,2}(1)=s_next4{1,2}(1)+1;s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;  %��һ��D3���� 
    s_next5 = s_current; s_next5{1,2}(1)=s_next5{1,2}(1)+1;s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;   %��һ��D4����   
    
    %  ��ע�⡿ s{1,3}(1)�����������ơ������һ����
    s_next6 = s_current; s_next6{1,2}(1)=s_next6{1,2}(1)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %��һ��L1����
    s_next7 = s_current; s_next7{1,2}(1)=s_next7{1,2}(1)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %��һ��L2����
    s_next8 = s_current; s_next8{1,2}(1)=s_next8{1,2}(1)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %��һ��L3���� 
    
    s_next9 = s_current; s_next9{1,2}(1)=s_next9{1,2}(1)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % ��Kʱ���������ܵ���
    end
    
    s_next10 = s_current; s_next10{1,2}(1)=s_next10{1,2}(1)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %���RU�����Ƿ�С��2
        pp10 = 0;    % ����С��2ʱ���������ᷢ���뿪
    end
    
    %   ��һ��״̬���� �Լ�ת�Ƶ���Ӧ״̬�ĸ���
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];
    
   %**********************************************************************
   %%**********************************************************************
elseif strcmp(s_current{4} , 'A') && (s_current{1,2}(2)==0) && (a == 20) %������񵽴��2��״̬Ϊ0������Է����2������a==20��
    if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<2ʱ��
    end
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end
    
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+(s_current{1,2}(2)+1)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f; %��Ϊ��ĵ�λ
    %   ��ע�⡿��s{4}�������Ƿ��¼��ˣ�   ��������ȡa==20����һ��״̬��s{1,2}(2)==1��
    s_next1 = s_current; s_next1{1,2}(2)=s_next1{1,2}(2)+1;s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;    %��һ��A����
    s_next2 = s_current; s_next2{1,2}(2)=s_next2{1,2}(2)+1;s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;    %��һ��D1����
    s_next3 = s_current; s_next3{1,2}(2)=s_next3{1,2}(2)+1;s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;   %��һ��D2����
    s_next4 = s_current; s_next4{1,2}(2)=s_next4{1,2}(2)+1;s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;  %��һ��D3���� 
    s_next5 = s_current; s_next5{1,2}(2)=s_next5{1,2}(2)+1;s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;   %��һ��D4����   
    
    %  ��ע�⡿ s{1,3}(1)�����������ơ������һ����
    s_next6 = s_current; s_next6{1,2}(2)=s_next6{1,2}(2)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %��һ��L1����
    s_next7 = s_current; s_next7{1,2}(2)=s_next7{1,2}(2)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %��һ��L2����
    s_next8 = s_current; s_next8{1,2}(2)=s_next8{1,2}(2)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %��һ��L3���� 
    
    s_next9 = s_current; s_next9{1,2}(2)=s_next9{1,2}(2)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % ��Kʱ���������ܵ���
    end
    
    s_next10 = s_current; s_next10{1,2}(2)=s_next10{1,2}(2)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %���RU�����Ƿ�С��2
        pp10 = 0;    % ����С��2ʱ���������ᷢ���뿪
    end
    
    %   ��һ��״̬���� �Լ�ת�Ƶ���Ӧ״̬�ĸ���
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];    
   
   %% �����������������������������������3����
   %**********************************************************************
   %%**********************************************************************
elseif strcmp(s_current{4} , 'A') && (s_current{1,2}(3)==0) && (a == 30) %������񵽴��2��״̬Ϊ0������Է����2������a==20��
    if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<2ʱ��
    end
   
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+(s_current{1,2}(3)+1)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f;
   
    %   ��ע�⡿��s{4}�������Ƿ��¼��ˣ�   ��������ȡa==30����һ��״̬��s{1,2}(3)==1��
    s_next1 = s_current; s_next1{1,2}(3)=s_next1{1,2}(3)+1;s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;    %��һ��A����
    s_next2 = s_current; s_next2{1,2}(3)=s_next2{1,2}(3)+1;s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;    %��һ��D1����
    s_next3 = s_current; s_next3{1,2}(3)=s_next3{1,2}(3)+1;s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;   %��һ��D2����
    s_next4 = s_current; s_next4{1,2}(3)=s_next4{1,2}(3)+1;s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;  %��һ��D3���� 
    s_next5 = s_current; s_next5{1,2}(3)=s_next5{1,2}(3)+1;s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;   %��һ��D4����    
    
    %  ��ע�⡿ s{1,3}(1)�����������ơ������һ����
    s_next6 = s_current; s_next6{1,2}(3)=s_next6{1,2}(3)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %��һ��L1����
    s_next7 = s_current; s_next7{1,2}(3)=s_next7{1,2}(3)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %��һ��L2����
    s_next8 = s_current; s_next8{1,2}(3)=s_next8{1,2}(3)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %��һ��L3���� 
    
    s_next9 = s_current; s_next9{1,2}(3)=s_next9{1,2}(3)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % ��Kʱ���������ܵ���
    end
    
    s_next10 = s_current; s_next10{1,2}(3)=s_next10{1,2}(3)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %���RU�����Ƿ�С��2
        pp10 = 0;    % ����С��2ʱ���������ᷢ���뿪
    end
    
    %   ��һ��״̬���� �Լ�ת�Ƶ���Ӧ״̬�ĸ���
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];    
    
   %% �����������������������������������4����
   %**********************************************************************
   %%**********************************************************************
elseif strcmp(s_current{4} , 'A') && (s_current{1,2}(4)==0) && (a == 40) %������񵽴��2��״̬Ϊ0������Է����2������a==20��
    if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<2ʱ��
    end
   
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+(s_current{1,2}(4)+1)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f;
   
    %   ��ע�⡿��s{4}�������Ƿ��¼��ˣ�   ��������ȡa==40����һ��״̬��s{1,2}(4)==1��
    s_next1 = s_current; s_next1{1,2}(4)=s_next1{1,2}(4)+1;s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;    %��һ��A����
    s_next2 = s_current; s_next2{1,2}(4)=s_next2{1,2}(4)+1;s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;    %��һ��D1����
    s_next3 = s_current; s_next3{1,2}(4)=s_next3{1,2}(4)+1;s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;   %��һ��D2����
    s_next4 = s_current; s_next4{1,2}(4)=s_next4{1,2}(4)+1;s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;  %��һ��D3���� 
    s_next5 = s_current; s_next5{1,2}(4)=s_next5{1,2}(4)+1;s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;   %��һ��D4����   
    
    %  ��ע�⡿ s{1,3}(1)�����������ơ������һ����
    s_next6 = s_current; s_next6{1,2}(4)=s_next6{1,2}(4)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %��һ��L1����
    s_next7 = s_current; s_next7{1,2}(4)=s_next7{1,2}(4)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %��һ��L2����
    s_next8 = s_current; s_next8{1,2}(4)=s_next8{1,2}(4)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %��һ��L3���� 
    
    s_next9 = s_current; s_next9{1,2}(4)=s_next9{1,2}(4)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % ��Kʱ���������ܵ���
    end
    
    s_next10 = s_current; s_next10{1,2}(4)=s_next10{1,2}(4)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %���RU�����Ƿ�С��2
        pp10 = 0;    % ����С��2ʱ���������ᷢ���뿪
    end
    
    %   ��һ��״̬���� �Լ�ת�Ƶ���Ӧ״̬�ĸ���
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];   
    %���������������������������ơ�����*****************����������������������������%
    %A���񵽴�����VFC��1������************************************************************************************
elseif strcmp(s_current{4} , 'A') && a == 1       
    if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<2ʱ��
    end
   
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 + a )*(f0/d)+lambda_f+u_f;
    %   s{4}�����Ƿ��¼�����    
    s_next1 = s_current; s_next1{1,3}(1)=s_next1{1,3}(1)+1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;  % A����
    s_next2 = s_current; s_next2{1,3}(1)=s_next2{1,3}(1)+1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;  % D1����  
    s_next3 = s_current; s_next3{1,3}(1)=s_next3{1,3}(1)+1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma; %D2
    s_next4 = s_current; s_next4{1,3}(1)=s_next4{1,3}(1)+1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma; %D3
    s_next5 = s_current; s_next5{1,3}(1)=s_next5{1,3}(1)+1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma; %D4
    
    %  ��ע�⡿ s{1,3}(1)�����������ơ������һ����
    s_next6 = s_current; s_next6{1,3}(1)=s_next6{1,3}(1)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %��һ��L1����
    s_next7 = s_current; s_next7{1,3}(1)=s_next7{1,3}(1)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %��һ��L2����
    s_next8 = s_current; s_next8{1,3}(1)=s_next8{1,3}(1)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %��һ��L3���� 
    
    s_next9 = s_current; s_next9{1,3}(1)=s_next9{1,3}(1)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % ��Kʱ���������ܵ���
    end
    
    s_next10 = s_current; s_next10{1,3}(1)=s_next10{1,3}(1)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %���RU�����Ƿ�С��2
        pp10 = 0;    % ����С��2ʱ���������ᷢ���뿪
    end
    
    %   ��һ��״̬���� �Լ�ת�Ƶ���Ӧ״̬�ĸ���
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i=1: length(s_next)
        s_next{i,5} = s_next{i,5}-1;    %����״̬������RU����1��
    end     
    
    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];    
  
    %A���񵽴�����VFC��2������************************************************************************************
elseif strcmp(s_current{4} , 'A') && a == 2       
    if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<2ʱ��
    end
   
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 + a )*(f0/d)+lambda_f+u_f;
    %   s{4}�����Ƿ��¼����� 
    s_next1 = s_current; s_next1{1,3}(2)=s_next1{1,3}(2)+1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;  % A����
    s_next2 = s_current; s_next2{1,3}(2)=s_next2{1,3}(2)+1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;  % D1����  
    s_next3 = s_current; s_next3{1,3}(2)=s_next3{1,3}(2)+1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma; %D2
    s_next4 = s_current; s_next4{1,3}(2)=s_next4{1,3}(2)+1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma; %D3
    s_next5 = s_current; s_next5{1,3}(2)=s_next5{1,3}(2)+1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma; %D4
    
    %  ��ע�⡿ s{1,3}(1)�����������ơ������2����
    s_next6 = s_current; s_next6{1,3}(2)=s_next6{1,3}(2)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %��һ��L1����
    s_next7 = s_current; s_next7{1,3}(2)=s_next7{1,3}(2)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %��һ��L2����
    s_next8 = s_current; s_next8{1,3}(2)=s_next8{1,3}(2)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %��һ��L3���� 
    
    s_next9 = s_current; s_next9{1,3}(2)=s_next9{1,3}(2)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % ��Kʱ���������ܵ���
    end
    
    s_next10 = s_current; s_next10{1,3}(2)=s_next10{1,3}(2)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %���RU�����Ƿ�С��2
        pp10 = 0;    % ����С��2ʱ���������ᷢ���뿪
    end
    
    %   ��һ��״̬���� �Լ�ת�Ƶ���Ӧ״̬�ĸ���
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i=1: length(s_next)
        s_next{i,5} = s_next{i,5}-2;    %����״̬������RU����2��
    end     
    
    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];  
    
    
%A���񵽴�����VFC��3������************************************************************************************
elseif strcmp(s_current{4} , 'A') && a == 3       
    if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<2ʱ��
    end
   
    
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 + a )*(f0/d)+lambda_f+u_f;
    %   s{4}�����Ƿ��¼����� 
    s_next1 = s_current; s_next1{1,3}(3)=s_next1{1,3}(3)+1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;  % A����
    s_next2 = s_current; s_next2{1,3}(3)=s_next2{1,3}(3)+1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;  % D1����  
    s_next3 = s_current; s_next3{1,3}(3)=s_next3{1,3}(3)+1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma; %D2
    s_next4 = s_current; s_next4{1,3}(3)=s_next4{1,3}(3)+1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma; %D3
    s_next5 = s_current; s_next5{1,3}(3)=s_next5{1,3}(3)+1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma; %D4
    
    %  ��ע�⡿ s{1,3}(1)�����������ơ������3����
    s_next6 = s_current; s_next6{1,3}(3)=s_next6{1,3}(3)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %��һ��L1����
    s_next7 = s_current; s_next7{1,3}(3)=s_next7{1,3}(3)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %��һ��L2����
    s_next8 = s_current; s_next8{1,3}(3)=s_next8{1,3}(3)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %��һ��L3���� 
    
    s_next9 = s_current; s_next9{1,3}(3)=s_next9{1,3}(3)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % ��Kʱ���������ܵ���
    end
    
    s_next10 = s_current; s_next10{1,3}(3)=s_next10{1,3}(3)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %���RU�����Ƿ�С��2
        pp10 = 0;    % ����С��2ʱ���������ᷢ���뿪
    end
    
    %   ��һ��״̬���� �Լ�ת�Ƶ���Ӧ״̬�ĸ���
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i=1: length(s_next)
        s_next{i,5} = s_next{i,5}-3;    %����״̬������RU����3��
    end     
    
    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];  
    
 %----A���񵽴������-==========+++++++++++++++++++++++++++++++++++++++
elseif strcmp(s_current{4} , 'A') && a == 0       
    if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<2ʱ��
    end
   
    
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 + a )*(f0/d)+lambda_f+u_f;
    %   s{4}�����Ƿ��¼����� 
    s_next1 = s_current;  s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;  % A����
    s_next2 = s_current;  s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;  % D1����  
    s_next3 = s_current;  s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma; %D2
    s_next4 = s_current;  s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma; %D3
    s_next5 = s_current;  s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma; %D4
    
    %  ��ע�⡿ s{1,3}(1)�����������ơ������3����
    s_next6 = s_current; s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %��һ��L1����
    s_next7 = s_current; s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %��һ��L2����
    s_next8 = s_current; s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %��һ��L3���� 
    
    s_next9 = s_current; s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % ��Kʱ���������ܵ���
    end
    
    s_next10 = s_current; s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %���RU�����Ƿ�С��2
        pp10 = 0;    % ����С��2ʱ���������ᷢ���뿪
    end
    
    %   ��һ��״̬���� �Լ�ת�Ƶ���Ӧ״̬�ĸ���
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

%     for i=1: length(s_next)
%         s_next{i,5} = s_next{i,5};    %����״̬������RU����3��
%     end     
    % ������������һ��״̬
    for i = 1 : length(s_next)   %����������һ��״̬����ֹ���������и���Ϊ0
        pp(i,1) = 0;
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];  
    sigma = 0;
end  %����

%% �����뿪
% �����ͷ����D1�����뿪************************************************************************************
if strcmp(s_current{4} , 'D1') && a == -1
    
    if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ�𣨲�һ���ģ�ǰ��˵������0,��ô�Ͳ���������¼������������0�����뿪����¼���ʵ�����˷����¼���
    end    
    
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    if s_current{1,2}(1)==1     %���״̬�Ƿ�����D1���󣨼�����Ϊ0��
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-s_current{1,2}(1)*(f1/d)+lambda_f+u_f;
        
        %   ��ע�⡿s{1,2}(1)Ҫ��1����������һʱ��û��D1��,����Ӧ��Ϊ0��
        s_next1 = s_current; s_next1{1,2}(1)=s_next1{1,2}(1)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,2}(1)=s_next2{1,2}(1)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,2}(1)=s_next3{1,2}(1)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,2}(1)=s_next4{1,2}(1)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,2}(1)=s_next5{1,2}(1)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4    
        
        %   ��ע�⡿�������У������뿪
        s_next6 = s_current; s_next6{1,2}(1)=s_next6{1,2}(1)-1; s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;%L1
        s_next7 = s_current; s_next7{1,2}(1)=s_next7{1,2}(1)-1; s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;%L2
        s_next8 = s_current; s_next8{1,2}(1)=s_next8{1,2}(1)-1; s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;%L3
        
        s_next9 = s_current; s_next9{1,2}(1)=s_next9{1,2}(1)-1; s_next9{4} = 'F+1'; pp9 = lambda_f/sigma;
        if s_next9{1}==K
            pp9 = 0;
        end
        s_next10 = s_current; s_next10{1,2}(1)=s_next10{1,2}(1)-1; s_next10{4} = 'F-1'; pp10 = u_f/sigma;
        if s_next10{1}<2
            pp10 = 0;
        end
        s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
        pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];
        
       for i = 1 : length(s_next)
            s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
        
    end
    
    %% _________________��2��������������뿪ϵͳ
elseif strcmp(s_current{4} , 'D2') && a == -1
    
     if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
     end   
    
     if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
     end    
     
    if s_current{1,2}(2)==1     %���״̬�Ƿ�����D2���󣨼�����Ϊ0��
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-s_current{1,2}(2)*(f2/d)+lambda_f+u_f;
        
        %   ��ע�⡿s{1,2}(2)Ҫ��1�����0,��ʾ���С�������һʱ��û��D2��,����Ӧ��Ϊ0��
        s_next1 = s_current; s_next1{1,2}(2)=s_next1{1,2}(2)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,2}(2)=s_next2{1,2}(2)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,2}(2)=s_next3{1,2}(2)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,2}(2)=s_next4{1,2}(2)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,2}(2)=s_next5{1,2}(2)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4    
        
        %   ��ע�⡿�������У������뿪
        s_next6 = s_current; s_next6{1,2}(2)=s_next6{1,2}(2)-1; s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;%L1
        s_next7 = s_current; s_next7{1,2}(2)=s_next7{1,2}(2)-1; s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;%L2
        s_next8 = s_current; s_next8{1,2}(2)=s_next8{1,2}(2)-1; s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;%L3
        
        s_next9 = s_current; s_next9{1,2}(2)=s_next9{1,2}(2)-1; s_next9{4} = 'F+1'; pp9 = lambda_f/sigma;
        if s_next9{1}==K
            pp9 = 0;
        end
        s_next10 = s_current; s_next10{1,2}(2)=s_next10{1,2}(2)-1; s_next10{4} = 'F-1'; pp10 = u_f/sigma;
        if s_next10{1}<2
            pp10 = 0;
        end
        s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
        pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];
        
       for i = 1 : length(s_next)
            s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
        
    end    
    
    %% _________________��3��������������뿪ϵͳ
elseif strcmp(s_current{4} , 'D3') && a == -1
    
    if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    if s_current{1,2}(3)==1     %���״̬�Ƿ�����D2���󣨼�����Ϊ0��
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-s_current{1,2}(3)*(f3/d)+lambda_f+u_f;
        
        %   ��ע�⡿s{1,2}(3)Ҫ��1�����0,��ʾ���С�������һʱ��û��D3��,����Ӧ��Ϊ0��
        s_next1 = s_current; s_next1{1,2}(3)=s_next1{1,2}(3)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,2}(3)=s_next2{1,2}(3)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,2}(3)=s_next3{1,2}(3)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,2}(3)=s_next4{1,2}(3)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,2}(3)=s_next5{1,2}(3)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4      
             
        %   ��ע�⡿�������У������뿪
        s_next6 = s_current; s_next6{1,2}(3)=s_next6{1,2}(3)-1; s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;%L1
        s_next7 = s_current; s_next7{1,2}(3)=s_next7{1,2}(3)-1; s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;%L2
        s_next8 = s_current; s_next8{1,2}(3)=s_next8{1,2}(3)-1; s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;%L3
        
        s_next9 = s_current; s_next9{1,2}(3)=s_next9{1,2}(3)-1; s_next9{4} = 'F+1'; pp9 = lambda_f/sigma;
        if s_next9{1}==K
            pp9 = 0;
        end
        s_next10 = s_current; s_next10{1,2}(3)=s_next10{1,2}(3)-1; s_next10{4} = 'F-1'; pp10 = u_f/sigma;
        if s_next10{1}<2
            pp10 = 0;
        end
        s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
        pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];
        
       for i = 1 : length(s_next)
            s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
        
    end        

     %% _________________��4��������������뿪ϵͳ
elseif strcmp(s_current{4} , 'D4') && a == -1
    
    if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    if s_current{1,2}(4)==1     %���״̬�Ƿ�����D2���󣨼�����Ϊ0��
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d) - s_current{1,2}(4)*(f4/d)+lambda_f+u_f;
        
        %   ��ע�⡿s{1,2}(3)Ҫ��1�����0,��ʾ���С�������һʱ��û��D4��,����Ӧ��Ϊ0��
        s_next1 = s_current; s_next1{1,2}(4)=s_next1{1,2}(4)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,2}(4)=s_next2{1,2}(4)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,2}(4)=s_next3{1,2}(4)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,2}(4)=s_next4{1,2}(4)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,2}(4)=s_next5{1,2}(4)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4        
        
        %   ��ע�⡿�������У������뿪
        s_next6 = s_current; s_next6{1,2}(4)=s_next6{1,2}(4)-1; s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;%L1
        s_next7 = s_current; s_next7{1,2}(4)=s_next7{1,2}(4)-1; s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;%L2
        s_next8 = s_current; s_next8{1,2}(4)=s_next8{1,2}(4)-1; s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;%L3
        
        s_next9 = s_current; s_next9{1,2}(4)=s_next9{1,2}(4)-1; s_next9{4} = 'F+1'; pp9 = lambda_f/sigma;
        if s_next9{1}==K
            pp9 = 0;
        end
        s_next10 = s_current; s_next10{1,2}(4)=s_next10{1,2}(4)-1; s_next10{4} = 'F-1'; pp10 = u_f/sigma;
        if s_next10{1}<2
            pp10 = 0;
        end
        s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
        pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];
        
       for i = 1 : length(s_next)
            s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
        
    end        
              
%%
 %%�����������������������������������������������������뿪 
 %**************1�����㵥Ԫ����������뿪
elseif strcmp(s_current{4} , 'L1') && a == -1
     if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
     end   
    
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
     
    if s_current{1,3}(1)>=1     %���״̬�Ƿ�����D2���󣨼�����Ϊ0��
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-(f0/d)+lambda_f+u_f;
        
        s_next1 = s_current; s_next1{1,3}(1)=s_next1{1,3}(1)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,3}(1)=s_next2{1,3}(1)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,3}(1)=s_next3{1,3}(1)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,3}(1)=s_next4{1,3}(1)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,3}(1)=s_next5{1,3}(1)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4      
        
        %   ��ע�⡿�������У�������
        s_next6 = s_current; s_next6{1,3}(1)=s_next6{1,3}(1)-1; s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;%L1
        s_next7 = s_current; s_next7{1,3}(1)=s_next7{1,3}(1)-1; s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;%L2
        s_next8 = s_current; s_next8{1,3}(1)=s_next8{1,3}(1)-1; s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;%L3
        
        s_next9 = s_current; s_next9{1,3}(1)=s_next9{1,3}(1)-1; s_next9{4} = 'F+1'; pp9 = lambda_f/sigma;
        if s_next9{1}==K
            pp9 = 0;
        end
        s_next10 = s_current; s_next10{1,3}(1)=s_next10{1,3}(1)-1; s_next10{4} = 'F-1'; pp10 = u_f/sigma;
        if s_next10{1}<2
            pp10 = 0;
        end
        s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
        pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];
        
        for i=1: length(s_next)
            s_next{i,5} = s_next{i,5}+1;    %����״̬������RU������1��
        end        
        
       for i = 1 : length(s_next)
            s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
        
    end         
    
  %**************2�����㵥Ԫ����������뿪
elseif strcmp(s_current{4} , 'L2') && a == -1
    
    if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
    
    
    if s_current{1,3}(2)>=1     %���״̬�Ƿ�����D2���󣨼�����Ϊ0��
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-2*(f0/d)+lambda_f+u_f;
        
        s_next1 = s_current; s_next1{1,3}(2)=s_next1{1,3}(2)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,3}(2)=s_next2{1,3}(2)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,3}(2)=s_next3{1,3}(2)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,3}(2)=s_next4{1,3}(2)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,3}(2)=s_next5{1,3}(2)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4
        
        %   ��ע�⡿�������У�������
        s_next6 = s_current; s_next6{1,3}(2)=s_next6{1,3}(2)-1; s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;%L1
        s_next7 = s_current; s_next7{1,3}(2)=s_next7{1,3}(2)-1; s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;%L2
        s_next8 = s_current; s_next8{1,3}(2)=s_next8{1,3}(2)-1; s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;%L3
        
        s_next9 = s_current; s_next9{1,3}(2)=s_next9{1,3}(2)-1; s_next9{4} = 'F+1'; pp9 = lambda_f/sigma;
        if s_next9{1}==K
            pp9 = 0;
        end
        s_next10 = s_current; s_next10{1,3}(2)=s_next10{1,3}(2)-1; s_next10{4} = 'F-1'; pp10 = u_f/sigma;
        if s_next10{1}<2
            pp10 = 0;
        end
        s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
        pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];
        
        for i=1: length(s_next)
            s_next{i,5} = s_next{i,5}+2;    %����״̬������RU������2��
        end        
        
       for i = 1 : length(s_next)
            s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
        
    end     
    
  %**************2�����㵥Ԫ����������뿪
elseif strcmp(s_current{4} , 'L3') && a == -1
    
     if s_current{1} == 1     %���RU�����Ƿ�Ϊ1
        u_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
     end
    
     if s_current{1} == K     %��鳵����RU�����Ƿ�Ϊ1
        lambda_f = 0;    %   K=1ʱ�������뿪�� == 0��ΪʲôҪ����֮ǰ�����Ҳ���<=2ʱ��
    end    
     
    if s_current{1,3}(3)>=1     %���״̬�Ƿ�����D2���󣨼�����Ϊ0��
    %   sigma��ʾ�ڵ�ǰ״̬�£���ȡ�������󡿣������¼��ķ�������֮�͡�
    %   �������񵽴���   +  ���ӳ�Ա����������뿪�ʣ��������еĶ��ڴ�������  + �����������뿪�� + ����������  +�����뿪��
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-3*(f0/d)+lambda_f+u_f;
        
        s_next1 = s_current; s_next1{1,3}(3)=s_next1{1,3}(3)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,3}(3)=s_next2{1,3}(3)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,3}(3)=s_next3{1,3}(3)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,3}(3)=s_next4{1,3}(3)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,3}(3)=s_next5{1,3}(3)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4   
        
        %   ��ע�⡿�������У�������
        s_next6 = s_current; s_next6{1,3}(3)=s_next6{1,3}(3)-1; s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;%L1
        s_next7 = s_current; s_next7{1,3}(3)=s_next7{1,3}(3)-1; s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;%L2
        s_next8 = s_current; s_next8{1,3}(3)=s_next8{1,3}(3)-1; s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;%L3
        
        s_next9 = s_current; s_next9{1,3}(3)=s_next9{1,3}(3)-1; s_next9{4} = 'F+1'; pp9 = lambda_f/sigma;
        if s_next9{1}==K
            pp9 = 0;
        end
        s_next10 = s_current; s_next10{1,3}(3)=s_next10{1,3}(3)-1; s_next10{4} = 'F-1'; pp10 = u_f/sigma;
        if s_next10{1}<2
            pp10 = 0;
        end
        s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
        pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];
        
        for i=1: length(s_next)
            s_next{i,5} = s_next{i,5}+3;    %����״̬������RU������2��
        end        
        
       for i = 1 : length(s_next)
            s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
        
    end     
end

%% ��������************************************************************************************
if strcmp(s_current{4} , 'F+1') && a == -1   %��ע�⣬k����3ʱ�����������˰ɣ���s�п�����û��ȥ������������������  
    %% �������Ǹ������ô��һʱ������2���������ԣ�һ�������г����뿪
    
   if s_current{1} == K-1 
       lambda_f = 0;    % sigma����ǣ���ȡ������ģ��ܵ��¼������ʣ�a=-1 ��K=3��û�е�����ԣ�����sigmaǰ����ȥ
   end
   
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f;
    
    s_next1 = s_current; s_next1{1} = s_next1{1} + 1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A1
    s_next2 = s_current; s_next2{1} = s_next2{1} + 1; s_next2{4} = 'D1'; pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
    s_next3 = s_current; s_next3{1} = s_next3{1} + 1; s_next3{4} = 'D2'; pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
    s_next4 = s_current; s_next4{1} = s_next4{1} + 1; s_next4{4} = 'D3'; pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
    s_next5 = s_current; s_next5{1} = s_next5{1} + 1; s_next5{4} = 'D4'; pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4   
    
     %   ��ע�⡿�������У�������
    s_next6 = s_current; s_next6{1} = s_next6{1} + 1;s_next6{4} = 'L1'; pp6 = s_next6{1,3}(1)*(f0/d)/sigma;%L1
    s_next7 = s_current; s_next7{1} = s_next7{1} + 1;s_next7{4} = 'L2'; pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;%L2
    s_next8 = s_current; s_next8{1} = s_next8{1} + 1;s_next8{4} = 'L3'; pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;%L3
        
     s_next9 = s_current;s_next9{1} = s_next9{1} + 1;s_next9{4} = 'F+1'; pp9 = lambda_f/sigma;
     if s_next9{1}==K
         pp9 = 0;
     end
     s_next10 = s_current;s_next10{1} = s_next10{1} + 1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
     if s_next10{1}<2
         pp10 = 0;
     end
     s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
     pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i=1: length(s_next)
        s_next{i,5}=s_next{i,5}+1;  %����״̬������RU������1��
    end
    
    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];   
    
end

%% �����뿪************************************************************************************
if strcmp(s_current{4} , 'F-1') && a == -1
   if s_current{1} == 2 
       u_f = 0;    % sigma����ǣ���ȡ������ģ��ܵ��¼������ʣ�a=-1 ��K=1��û���뿪�����ԣ�����sigmaǰ����ȥ;F-1������ֻʣ1������������һʱ�̣������뿪��==0��sigma�������һʱ�̸���
   end

    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f;
        
    s_next1 = s_current; s_next1{1} = s_next1{1} - 1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A1
    s_next2 = s_current; s_next2{1} = s_next2{1} - 1; s_next2{4} = 'D1'; pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
    s_next3 = s_current; s_next3{1} = s_next3{1} - 1; s_next3{4} = 'D2'; pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
    s_next4 = s_current; s_next4{1} = s_next4{1} - 1; s_next4{4} = 'D3'; pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
    s_next5 = s_current; s_next5{1} = s_next5{1} - 1; s_next5{4} = 'D4'; pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4       
    
     %   ��ע�⡿�������У�������
    s_next6 = s_current; s_next6{1} = s_next6{1} - 1; s_next6{4} = 'L1'; pp6 = s_next6{1,3}(1)*(f0/d)/sigma;%L1
    s_next7 = s_current; s_next7{1} = s_next7{1} - 1; s_next7{4} = 'L2'; pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;%L2
    s_next8 = s_current; s_next8{1} = s_next8{1} - 1; s_next8{4} = 'L3'; pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;%L3
        
     s_next9 = s_current;s_next9{1} = s_next9{1} - 1; s_next9{4} = 'F+1'; pp9 = lambda_f/sigma;
     if s_next9{1}==K
         pp9 = 0;
     end
     s_next10 = s_current;s_next10{1} = s_next10{1} - 1; s_next10{4} = 'F-1'; pp10 = u_f/sigma;
     if s_next10{1}<2
         pp10 = 0;
     end
     s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
        
        
        for i=1: length(s_next)
            s_next{i,5}=s_next{i,5}-1;  %����״̬������RU������1��
        end
        pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];
        

        if s_current{5}==0      %  �����ǰû�п��г������򲻿��ܷ��������뿪������������һ��״̬�ĸ���Ϊ0��״ֹ̬ͣ     
            for i = 1 : length(s_next)
                pp(i,1) = 0;
            end
        end
  
       for i = 1 : length(s_next)
          s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
       
end
