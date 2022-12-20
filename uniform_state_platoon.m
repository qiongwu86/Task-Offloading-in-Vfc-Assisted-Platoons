function [pp_unif,s_next,sigma,flag1] = uniform_state_platoon(s_current,s_next,pp,K,M,lambda_p,f0,f1,f2,f3,f4,d,lambda_f,u_f,sigma)
% clear;
% K=6;

%初始转移s->s'，假如本来s‘有3个状态且不包含s状态，归一化后s’增加一个s状态，s'归一化后变成四个状态
y=M*(lambda_p)+lambda_f+u_f+ (f1/d) + (f2/d) + (f3/d)+ (f4/d) + K*3*(f0/d);

%转移概率均匀化
pp_unif = pp;
Ls = length(s_next)-1;  % 因为添加过一个空白状态
%%   首先判断是否有s = s'的情况，有则flag1 =1;并记录索引
flag1 = 0;
for i=1 : Ls
    if s_next{i,1} == s_current{1,1} && strcmp(s_next{i,4} , s_current{1,4})    % 如果当前K与下一状态K相等 + 当前事件与下一事件相等
        if s_current{1,2}(1)==s_next{i,2}(1) && s_current{1,2}(2)==s_next{i,2}(2) && s_current{1,2}(3)==s_next{i,2}(3) && s_current{1,2}(4)==s_next{i,2}(4) && s_current{1,3}(1)==s_next{i,3}(1) && s_current{1,3}(2)==s_next{i,3}(2) && s_current{1,3}(3)==s_next{i,3}(3)
                flag1 = 1;
                index = i;
        end
    end
end

%%  转移状态归一化 

if flag1 == 1        % 即有回到自身的状态
    for j = 1:Ls
        if j == index
             pp_unif(j)=1-(1-pp(j))*sigma/y; %   下一状态与当前状态相等
        else
             pp_unif(j)= pp(j)*sigma/y;
        end
    end
    
else   % 即【没有】回到自身的状态
    s_next(Ls+1,1:5) = s_current;
    for j =1:Ls
        pp_unif(j)= pp(j)*sigma/y;
    end
    pp_unif(Ls+1) = 1 - sigma/y;
end