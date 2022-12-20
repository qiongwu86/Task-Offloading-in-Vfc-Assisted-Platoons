% 状态转移：根据当前状态s_current和当前动作a求出下一状态、转移概率和事件总速率
% 概率不为1
function [s_next,pp,sigma] = trans_state_platoon_s(K,M, s_current,a,lambda_f,u_f,lambda_p,f0,f1,f2,f3,f4,d)
     %----------注意：【K】是车载云的车辆数-------------%
%测试参数

%添加空白状态，增加一个位置，后面归一化转移概率时要用到
%  s_next  【不是s{i,6}】                event, remianer, s_next{i,6}未归一化概率   
s_add={0,[0,0,0,0],[0,0,0],' ',0,0};

%% 请求到达A
%RU全占满时请求到达，惩罚，丢包，终止状态********************************************************************
% % 【问】——不是说a == 0,表示拒绝卸载任务吗，怎么感觉不是啊——最后他把下一个状态的改率都清0了
if strcmp(s_current{4} , 'A') && (s_current{1,2}(1)==0) && (a == 10)  %如果任务到达，且头车状态为0，则可以分配给头车处理（a==10）
    if s_current{1} == 1     %检查车载云RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；
    end
   
    if s_current{1} == K     %检查车载云RU总数是否为K,是的话，就没有到达，所以先置为1
        lambda_f = 0;    %   
    end
    
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
    sigma=M*(lambda_p) + ( (s_current{1,2}(1)+1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f;
    %   【注意】：s{4}——才是放事件了；   【！！采取a==10后，下一个状态，s{1,2}(1)==1】
    s_next1 = s_current; s_next1{1,2}(1)=s_next1{1,2}(1)+1;s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;    %下一刻A到达
    s_next2 = s_current; s_next2{1,2}(1)=s_next2{1,2}(1)+1;s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;    %下一刻D1到达
    s_next3 = s_current; s_next3{1,2}(1)=s_next3{1,2}(1)+1;s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;   %下一刻D2到达
    s_next4 = s_current; s_next4{1,2}(1)=s_next4{1,2}(1)+1;s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;  %下一刻D3到达 
    s_next5 = s_current; s_next5{1,2}(1)=s_next5{1,2}(1)+1;s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;   %下一刻D4到达   
    
    %  【注意】 s{1,3}(1)——【车载云】分配给一个车
    s_next6 = s_current; s_next6{1,2}(1)=s_next6{1,2}(1)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %下一刻L1到达
    s_next7 = s_current; s_next7{1,2}(1)=s_next7{1,2}(1)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %下一刻L2到达
    s_next8 = s_current; s_next8{1,2}(1)=s_next8{1,2}(1)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %下一刻L3到达 
    
    s_next9 = s_current; s_next9{1,2}(1)=s_next9{1,2}(1)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % 满K时，车辆不能到达
    end
    
    s_next10 = s_current; s_next10{1,2}(1)=s_next10{1,2}(1)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %检查RU总数是否小于2
        pp10 = 0;    % 总数小于2时，车辆不会发生离开
    end
    
    %   下一个状态集， 以及转移到相应状态的概率
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];
    
   %**********************************************************************
   %%**********************************************************************
elseif strcmp(s_current{4} , 'A') && (s_current{1,2}(2)==0) && (a == 20) %如果任务到达，且2车状态为0，则可以分配给2车处理（a==20）
    if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<2时吗
    end
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end
    
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+(s_current{1,2}(2)+1)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f; %都为秒的单位
    %   【注意】：s{4}——才是放事件了；   【！！采取a==20后，下一个状态，s{1,2}(2)==1】
    s_next1 = s_current; s_next1{1,2}(2)=s_next1{1,2}(2)+1;s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;    %下一刻A到达
    s_next2 = s_current; s_next2{1,2}(2)=s_next2{1,2}(2)+1;s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;    %下一刻D1到达
    s_next3 = s_current; s_next3{1,2}(2)=s_next3{1,2}(2)+1;s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;   %下一刻D2到达
    s_next4 = s_current; s_next4{1,2}(2)=s_next4{1,2}(2)+1;s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;  %下一刻D3到达 
    s_next5 = s_current; s_next5{1,2}(2)=s_next5{1,2}(2)+1;s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;   %下一刻D4到达   
    
    %  【注意】 s{1,3}(1)——【车载云】分配给一个车
    s_next6 = s_current; s_next6{1,2}(2)=s_next6{1,2}(2)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %下一刻L1到达
    s_next7 = s_current; s_next7{1,2}(2)=s_next7{1,2}(2)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %下一刻L2到达
    s_next8 = s_current; s_next8{1,2}(2)=s_next8{1,2}(2)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %下一刻L3到达 
    
    s_next9 = s_current; s_next9{1,2}(2)=s_next9{1,2}(2)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % 满K时，车辆不能到达
    end
    
    s_next10 = s_current; s_next10{1,2}(2)=s_next10{1,2}(2)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %检查RU总数是否小于2
        pp10 = 0;    % 总数小于2时，车辆不会发生离开
    end
    
    %   下一个状态集， 以及转移到相应状态的概率
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];    
   
   %% ——————————————分配给第3辆车
   %**********************************************************************
   %%**********************************************************************
elseif strcmp(s_current{4} , 'A') && (s_current{1,2}(3)==0) && (a == 30) %如果任务到达，且2车状态为0，则可以分配给2车处理（a==20）
    if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<2时吗
    end
   
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+(s_current{1,2}(3)+1)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f;
   
    %   【注意】：s{4}——才是放事件了；   【！！采取a==30后，下一个状态，s{1,2}(3)==1】
    s_next1 = s_current; s_next1{1,2}(3)=s_next1{1,2}(3)+1;s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;    %下一刻A到达
    s_next2 = s_current; s_next2{1,2}(3)=s_next2{1,2}(3)+1;s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;    %下一刻D1到达
    s_next3 = s_current; s_next3{1,2}(3)=s_next3{1,2}(3)+1;s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;   %下一刻D2到达
    s_next4 = s_current; s_next4{1,2}(3)=s_next4{1,2}(3)+1;s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;  %下一刻D3到达 
    s_next5 = s_current; s_next5{1,2}(3)=s_next5{1,2}(3)+1;s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;   %下一刻D4到达    
    
    %  【注意】 s{1,3}(1)——【车载云】分配给一个车
    s_next6 = s_current; s_next6{1,2}(3)=s_next6{1,2}(3)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %下一刻L1到达
    s_next7 = s_current; s_next7{1,2}(3)=s_next7{1,2}(3)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %下一刻L2到达
    s_next8 = s_current; s_next8{1,2}(3)=s_next8{1,2}(3)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %下一刻L3到达 
    
    s_next9 = s_current; s_next9{1,2}(3)=s_next9{1,2}(3)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % 满K时，车辆不能到达
    end
    
    s_next10 = s_current; s_next10{1,2}(3)=s_next10{1,2}(3)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %检查RU总数是否小于2
        pp10 = 0;    % 总数小于2时，车辆不会发生离开
    end
    
    %   下一个状态集， 以及转移到相应状态的概率
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];    
    
   %% ——————————————分配给第4辆车
   %**********************************************************************
   %%**********************************************************************
elseif strcmp(s_current{4} , 'A') && (s_current{1,2}(4)==0) && (a == 40) %如果任务到达，且2车状态为0，则可以分配给2车处理（a==20）
    if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<2时吗
    end
   
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+(s_current{1,2}(4)+1)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f;
   
    %   【注意】：s{4}——才是放事件了；   【！！采取a==40后，下一个状态，s{1,2}(4)==1】
    s_next1 = s_current; s_next1{1,2}(4)=s_next1{1,2}(4)+1;s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;    %下一刻A到达
    s_next2 = s_current; s_next2{1,2}(4)=s_next2{1,2}(4)+1;s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;    %下一刻D1到达
    s_next3 = s_current; s_next3{1,2}(4)=s_next3{1,2}(4)+1;s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;   %下一刻D2到达
    s_next4 = s_current; s_next4{1,2}(4)=s_next4{1,2}(4)+1;s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;  %下一刻D3到达 
    s_next5 = s_current; s_next5{1,2}(4)=s_next5{1,2}(4)+1;s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;   %下一刻D4到达   
    
    %  【注意】 s{1,3}(1)——【车载云】分配给一个车
    s_next6 = s_current; s_next6{1,2}(4)=s_next6{1,2}(4)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %下一刻L1到达
    s_next7 = s_current; s_next7{1,2}(4)=s_next7{1,2}(4)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %下一刻L2到达
    s_next8 = s_current; s_next8{1,2}(4)=s_next8{1,2}(4)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %下一刻L3到达 
    
    s_next9 = s_current; s_next9{1,2}(4)=s_next9{1,2}(4)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % 满K时，车辆不能到达
    end
    
    s_next10 = s_current; s_next10{1,2}(4)=s_next10{1,2}(4)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %检查RU总数是否小于2
        pp10 = 0;    % 总数小于2时，车辆不会发生离开
    end
    
    %   下一个状态集， 以及转移到相应状态的概率
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];   
    %———————————车载云———*****************——————————————%
    %A任务到达，分配给VFC中1个车辆************************************************************************************
elseif strcmp(s_current{4} , 'A') && a == 1       
    if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<2时吗
    end
   
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 + a )*(f0/d)+lambda_f+u_f;
    %   s{4}【才是放事件】；    
    s_next1 = s_current; s_next1{1,3}(1)=s_next1{1,3}(1)+1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;  % A到达
    s_next2 = s_current; s_next2{1,3}(1)=s_next2{1,3}(1)+1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;  % D1到达  
    s_next3 = s_current; s_next3{1,3}(1)=s_next3{1,3}(1)+1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma; %D2
    s_next4 = s_current; s_next4{1,3}(1)=s_next4{1,3}(1)+1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma; %D3
    s_next5 = s_current; s_next5{1,3}(1)=s_next5{1,3}(1)+1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma; %D4
    
    %  【注意】 s{1,3}(1)——【车载云】分配给一个车
    s_next6 = s_current; s_next6{1,3}(1)=s_next6{1,3}(1)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %下一刻L1到达
    s_next7 = s_current; s_next7{1,3}(1)=s_next7{1,3}(1)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %下一刻L2到达
    s_next8 = s_current; s_next8{1,3}(1)=s_next8{1,3}(1)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %下一刻L3到达 
    
    s_next9 = s_current; s_next9{1,3}(1)=s_next9{1,3}(1)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % 满K时，车辆不能到达
    end
    
    s_next10 = s_current; s_next10{1,3}(1)=s_next10{1,3}(1)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %检查RU总数是否小于2
        pp10 = 0;    % 总数小于2时，车辆不会发生离开
    end
    
    %   下一个状态集， 以及转移到相应状态的概率
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i=1: length(s_next)
        s_next{i,5} = s_next{i,5}-1;    %更新状态，空闲RU数减1个
    end     
    
    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];    
  
    %A任务到达，分配给VFC中2个车辆************************************************************************************
elseif strcmp(s_current{4} , 'A') && a == 2       
    if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<2时吗
    end
   
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 + a )*(f0/d)+lambda_f+u_f;
    %   s{4}【才是放事件】； 
    s_next1 = s_current; s_next1{1,3}(2)=s_next1{1,3}(2)+1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;  % A到达
    s_next2 = s_current; s_next2{1,3}(2)=s_next2{1,3}(2)+1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;  % D1到达  
    s_next3 = s_current; s_next3{1,3}(2)=s_next3{1,3}(2)+1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma; %D2
    s_next4 = s_current; s_next4{1,3}(2)=s_next4{1,3}(2)+1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma; %D3
    s_next5 = s_current; s_next5{1,3}(2)=s_next5{1,3}(2)+1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma; %D4
    
    %  【注意】 s{1,3}(1)——【车载云】分配给2个车
    s_next6 = s_current; s_next6{1,3}(2)=s_next6{1,3}(2)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %下一刻L1到达
    s_next7 = s_current; s_next7{1,3}(2)=s_next7{1,3}(2)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %下一刻L2到达
    s_next8 = s_current; s_next8{1,3}(2)=s_next8{1,3}(2)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %下一刻L3到达 
    
    s_next9 = s_current; s_next9{1,3}(2)=s_next9{1,3}(2)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % 满K时，车辆不能到达
    end
    
    s_next10 = s_current; s_next10{1,3}(2)=s_next10{1,3}(2)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %检查RU总数是否小于2
        pp10 = 0;    % 总数小于2时，车辆不会发生离开
    end
    
    %   下一个状态集， 以及转移到相应状态的概率
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i=1: length(s_next)
        s_next{i,5} = s_next{i,5}-2;    %更新状态，空闲RU数减2个
    end     
    
    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];  
    
    
%A任务到达，分配给VFC中3个车辆************************************************************************************
elseif strcmp(s_current{4} , 'A') && a == 3       
    if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<2时吗
    end
   
    
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 + a )*(f0/d)+lambda_f+u_f;
    %   s{4}【才是放事件】； 
    s_next1 = s_current; s_next1{1,3}(3)=s_next1{1,3}(3)+1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;  % A到达
    s_next2 = s_current; s_next2{1,3}(3)=s_next2{1,3}(3)+1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;  % D1到达  
    s_next3 = s_current; s_next3{1,3}(3)=s_next3{1,3}(3)+1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma; %D2
    s_next4 = s_current; s_next4{1,3}(3)=s_next4{1,3}(3)+1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma; %D3
    s_next5 = s_current; s_next5{1,3}(3)=s_next5{1,3}(3)+1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma; %D4
    
    %  【注意】 s{1,3}(1)——【车载云】分配给3个车
    s_next6 = s_current; s_next6{1,3}(3)=s_next6{1,3}(3)+1;s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %下一刻L1到达
    s_next7 = s_current; s_next7{1,3}(3)=s_next7{1,3}(3)+1;s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %下一刻L2到达
    s_next8 = s_current; s_next8{1,3}(3)=s_next8{1,3}(3)+1;s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %下一刻L3到达 
    
    s_next9 = s_current; s_next9{1,3}(3)=s_next9{1,3}(3)+1;s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % 满K时，车辆不能到达
    end
    
    s_next10 = s_current; s_next10{1,3}(3)=s_next10{1,3}(3)+1;s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %检查RU总数是否小于2
        pp10 = 0;    % 总数小于2时，车辆不会发生离开
    end
    
    %   下一个状态集， 以及转移到相应状态的概率
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

    for i=1: length(s_next)
        s_next{i,5} = s_next{i,5}-3;    %更新状态，空闲RU数减3个
    end     
    
    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];  
    
 %----A任务到达：丢弃包-==========+++++++++++++++++++++++++++++++++++++++
elseif strcmp(s_current{4} , 'A') && a == 0       
    if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<2时吗
    end
   
    
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 + a )*(f0/d)+lambda_f+u_f;
    %   s{4}【才是放事件】； 
    s_next1 = s_current;  s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;  % A到达
    s_next2 = s_current;  s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;  % D1到达  
    s_next3 = s_current;  s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma; %D2
    s_next4 = s_current;  s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma; %D3
    s_next5 = s_current;  s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma; %D4
    
    %  【注意】 s{1,3}(1)——【车载云】分配给3个车
    s_next6 = s_current; s_next6{4} = 'L1';pp6 = s_next6{1,3}(1)*(f0/d)/sigma;   %下一刻L1到达
    s_next7 = s_current; s_next7{4} = 'L2';pp7 = s_next7{1,3}(2)*2*(f0/d)/sigma;  %下一刻L2到达
    s_next8 = s_current; s_next8{4} = 'L3';pp8 = s_next8{1,3}(3)*3*(f0/d)/sigma;  %下一刻L3到达 
    
    s_next9 = s_current; s_next9{4} = 'F+1';pp9 = lambda_f/sigma;
    if s_next9{1}==K
        pp9 = 0;   % 满K时，车辆不能到达
    end
    
    s_next10 = s_current; s_next10{4} = 'F-1'; pp10 = u_f/sigma;
    if s_next10{1}<2   %检查RU总数是否小于2
        pp10 = 0;    % 总数小于2时，车辆不会发生离开
    end
    
    %   下一个状态集， 以及转移到相应状态的概率
    s_next = [s_next1;s_next2;s_next3;s_next4;s_next5;s_next6;s_next7;s_next8;s_next9;s_next10];
    pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];

%     for i=1: length(s_next)
%         s_next{i,5} = s_next{i,5};    %更新状态，空闲RU数减3个
%     end     
    % 丢弃包，无下一个状态
    for i = 1 : length(s_next)   %丢包后，五下一个状态，终止，所以所有概率为0
        pp(i,1) = 0;
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];  
    sigma = 0;
end  %结束

%% 任务离开
% 分配给头车的D1任务离开************************************************************************************
if strcmp(s_current{4} , 'D1') && a == -1
    
    if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗（不一样的，前面说明等于0,那么就不会有这个事件；而后面等于0，则离开这个事件其实参与了发生事件）
    end    
    
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    if s_current{1,2}(1)==1     %检查状态是否满足D1请求（即不能为0）
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-s_current{1,2}(1)*(f1/d)+lambda_f+u_f;
        
        %   【注意】s{1,2}(1)要减1。【！！下一时刻没有D1了,概率应该为0】
        s_next1 = s_current; s_next1{1,2}(1)=s_next1{1,2}(1)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,2}(1)=s_next2{1,2}(1)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,2}(1)=s_next3{1,2}(1)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,2}(1)=s_next4{1,2}(1)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,2}(1)=s_next5{1,2}(1)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4    
        
        %   【注意】车载云中，任务离开
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
    
    %% _________________第2辆车处理的任务离开系统
elseif strcmp(s_current{4} , 'D2') && a == -1
    
     if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
     end   
    
     if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
     end    
     
    if s_current{1,2}(2)==1     %检查状态是否满足D2请求（即不能为0）
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-s_current{1,2}(2)*(f2/d)+lambda_f+u_f;
        
        %   【注意】s{1,2}(2)要减1，变成0,表示空闲【！！下一时刻没有D2了,概率应该为0】
        s_next1 = s_current; s_next1{1,2}(2)=s_next1{1,2}(2)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,2}(2)=s_next2{1,2}(2)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,2}(2)=s_next3{1,2}(2)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,2}(2)=s_next4{1,2}(2)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,2}(2)=s_next5{1,2}(2)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4    
        
        %   【注意】车载云中，任务离开
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
    
    %% _________________第3辆车处理的任务离开系统
elseif strcmp(s_current{4} , 'D3') && a == -1
    
    if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    if s_current{1,2}(3)==1     %检查状态是否满足D2请求（即不能为0）
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-s_current{1,2}(3)*(f3/d)+lambda_f+u_f;
        
        %   【注意】s{1,2}(3)要减1，变成0,表示空闲【！！下一时刻没有D3了,概率应该为0】
        s_next1 = s_current; s_next1{1,2}(3)=s_next1{1,2}(3)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,2}(3)=s_next2{1,2}(3)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,2}(3)=s_next3{1,2}(3)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,2}(3)=s_next4{1,2}(3)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,2}(3)=s_next5{1,2}(3)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4      
             
        %   【注意】车载云中，任务离开
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

     %% _________________第4辆车处理的任务离开系统
elseif strcmp(s_current{4} , 'D4') && a == -1
    
    if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    if s_current{1,2}(4)==1     %检查状态是否满足D2请求（即不能为0）
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d) - s_current{1,2}(4)*(f4/d)+lambda_f+u_f;
        
        %   【注意】s{1,2}(3)要减1，变成0,表示空闲【！！下一时刻没有D4了,概率应该为0】
        s_next1 = s_current; s_next1{1,2}(4)=s_next1{1,2}(4)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,2}(4)=s_next2{1,2}(4)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,2}(4)=s_next3{1,2}(4)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,2}(4)=s_next4{1,2}(4)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,2}(4)=s_next5{1,2}(4)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4        
        
        %   【注意】车载云中，任务离开
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
 %%————————————————————车载云中任务离开 
 %**************1个计算单元处理的任务离开
elseif strcmp(s_current{4} , 'L1') && a == -1
     if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
     end   
    
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
     
    if s_current{1,3}(1)>=1     %检查状态是否满足D2请求（即不能为0）
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-(f0/d)+lambda_f+u_f;
        
        s_next1 = s_current; s_next1{1,3}(1)=s_next1{1,3}(1)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,3}(1)=s_next2{1,3}(1)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,3}(1)=s_next3{1,3}(1)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,3}(1)=s_next4{1,3}(1)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,3}(1)=s_next5{1,3}(1)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4      
        
        %   【注意】车载云中，任务离
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
            s_next{i,5} = s_next{i,5}+1;    %更新状态，空闲RU数增加1个
        end        
        
       for i = 1 : length(s_next)
            s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
        
    end         
    
  %**************2个计算单元处理的任务离开
elseif strcmp(s_current{4} , 'L2') && a == -1
    
    if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
    
    
    if s_current{1,3}(2)>=1     %检查状态是否满足D2请求（即不能为0）
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-2*(f0/d)+lambda_f+u_f;
        
        s_next1 = s_current; s_next1{1,3}(2)=s_next1{1,3}(2)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,3}(2)=s_next2{1,3}(2)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,3}(2)=s_next3{1,3}(2)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,3}(2)=s_next4{1,3}(2)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,3}(2)=s_next5{1,3}(2)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4
        
        %   【注意】车载云中，任务离
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
            s_next{i,5} = s_next{i,5}+2;    %更新状态，空闲RU数增加2个
        end        
        
       for i = 1 : length(s_next)
            s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
        
    end     
    
  %**************2个计算单元处理的任务离开
elseif strcmp(s_current{4} , 'L3') && a == -1
    
     if s_current{1} == 1     %检查RU总数是否为1
        u_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
     end
    
     if s_current{1} == K     %检查车载云RU总数是否为1
        lambda_f = 0;    %   K=1时，车辆离开率 == 0；为什么要在这之前，而且不是<=2时吗
    end    
     
    if s_current{1,3}(3)>=1     %检查状态是否满足D2请求（即不能为0）
    %   sigma表示在当前状态下，采取动作【后】，所有事件的发生速率之和。
    %   【】任务到达率   +  车队成员处理任务的离开率（不是所有的堵在处理任务）  + 车载中任务离开率 + 车辆到达率  +车辆离开率
        sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)-3*(f0/d)+lambda_f+u_f;
        
        s_next1 = s_current; s_next1{1,3}(3)=s_next1{1,3}(3)-1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A
        s_next2 = s_current; s_next2{1,3}(3)=s_next2{1,3}(3)-1; s_next2{4} = 'D1';pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
        s_next3 = s_current; s_next3{1,3}(3)=s_next3{1,3}(3)-1; s_next3{4} = 'D2';pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
        s_next4 = s_current; s_next4{1,3}(3)=s_next4{1,3}(3)-1; s_next4{4} = 'D3';pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
        s_next5 = s_current; s_next5{1,3}(3)=s_next5{1,3}(3)-1; s_next5{4} = 'D4';pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4   
        
        %   【注意】车载云中，任务离
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
            s_next{i,5} = s_next{i,5}+3;    %更新状态，空闲RU数增加2个
        end        
        
       for i = 1 : length(s_next)
            s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
        
    end     
end

%% 车辆到达************************************************************************************
if strcmp(s_current{4} , 'F+1') && a == -1   %【注意，k等于3时，不可以增了吧，在s中看看有没有去掉】！！！！！！！  
    %% 车俩把那个到达，那么下一时刻至少2个车，所以，一定可以有车辆离开
    
   if s_current{1} == K-1 
       lambda_f = 0;    % sigma算的是，采取动作后的，总的事件发生率，a=-1 后，K=3，没有到达；所以，在算sigma前，除去
   end
   
    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f;
    
    s_next1 = s_current; s_next1{1} = s_next1{1} + 1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A1
    s_next2 = s_current; s_next2{1} = s_next2{1} + 1; s_next2{4} = 'D1'; pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
    s_next3 = s_current; s_next3{1} = s_next3{1} + 1; s_next3{4} = 'D2'; pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
    s_next4 = s_current; s_next4{1} = s_next4{1} + 1; s_next4{4} = 'D3'; pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
    s_next5 = s_current; s_next5{1} = s_next5{1} + 1; s_next5{4} = 'D4'; pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4   
    
     %   【注意】车载云中，任务离
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
        s_next{i,5}=s_next{i,5}+1;  %更新状态，空闲RU数增加1个
    end
    
    for i = 1 : length(s_next)
        s_next{i,6} = pp(i,1);
    end    
    s_next = [s_next;s_add];   
    
end

%% 车辆离开************************************************************************************
if strcmp(s_current{4} , 'F-1') && a == -1
   if s_current{1} == 2 
       u_f = 0;    % sigma算的是，采取动作后的，总的事件发生率，a=-1 后，K=1，没有离开；所以，在算sigma前，除去;F-1发生后，只剩1辆车，所以下一时刻，车辆离开率==0，sigma算的是下一时刻概率
   end

    sigma=M*(lambda_p) + ( s_current{1,2}(1)*(f1/d)+s_current{1,2}(2)*(f2/d)+s_current{1,2}(3)*(f3/d)+s_current{1,2}(4)*(f4/d) ) + ( s_current{1,3}(1)+s_current{1,3}(2)*2+s_current{1,3}(3)*3 )*(f0/d)+lambda_f+u_f;
        
    s_next1 = s_current; s_next1{1} = s_next1{1} - 1; s_next1{4} = 'A'; pp1 = M*lambda_p/sigma;%A1
    s_next2 = s_current; s_next2{1} = s_next2{1} - 1; s_next2{4} = 'D1'; pp2 = s_next2{1,2}(1)*(f1/d)/sigma;%D1
    s_next3 = s_current; s_next3{1} = s_next3{1} - 1; s_next3{4} = 'D2'; pp3 = s_next3{1,2}(2)*(f2/d)/sigma;%D2
    s_next4 = s_current; s_next4{1} = s_next4{1} - 1; s_next4{4} = 'D3'; pp4 = s_next4{1,2}(3)*(f3/d)/sigma;%D3
    s_next5 = s_current; s_next5{1} = s_next5{1} - 1; s_next5{4} = 'D4'; pp5 = s_next5{1,2}(4)*(f4/d)/sigma;%D4       
    
     %   【注意】车载云中，任务离
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
            s_next{i,5}=s_next{i,5}-1;  %更新状态，空闲RU数减少1个
        end
        pp = [pp1;pp2;pp3;pp4;pp5;pp6;pp7;pp8;pp9;pp10];
        

        if s_current{5}==0      %  如果当前没有空闲车俩，则不可能发生车辆离开，所以所有下一个状态的概率为0，状态停止     
            for i = 1 : length(s_next)
                pp(i,1) = 0;
            end
        end
  
       for i = 1 : length(s_next)
          s_next{i,6} = pp(i,1);
       end    
       s_next = [s_next;s_add];       
       
end
