function [pp_unif,s_next,sigma,flag1] = uniform_state_platoon(s_current,s_next,pp,K,M,lambda_p,f0,f1,f2,f3,f4,d,lambda_f,u_f,sigma)
% clear;
% K=6;

%��ʼת��s->s'�����籾��s����3��״̬�Ҳ�����s״̬����һ����s������һ��s״̬��s'��һ�������ĸ�״̬
y=M*(lambda_p)+lambda_f+u_f+ (f1/d) + (f2/d) + (f3/d)+ (f4/d) + K*3*(f0/d);

%ת�Ƹ��ʾ��Ȼ�
pp_unif = pp;
Ls = length(s_next)-1;  % ��Ϊ��ӹ�һ���հ�״̬
%%   �����ж��Ƿ���s = s'�����������flag1 =1;����¼����
flag1 = 0;
for i=1 : Ls
    if s_next{i,1} == s_current{1,1} && strcmp(s_next{i,4} , s_current{1,4})    % �����ǰK����һ״̬K��� + ��ǰ�¼�����һ�¼����
        if s_current{1,2}(1)==s_next{i,2}(1) && s_current{1,2}(2)==s_next{i,2}(2) && s_current{1,2}(3)==s_next{i,2}(3) && s_current{1,2}(4)==s_next{i,2}(4) && s_current{1,3}(1)==s_next{i,3}(1) && s_current{1,3}(2)==s_next{i,3}(2) && s_current{1,3}(3)==s_next{i,3}(3)
                flag1 = 1;
                index = i;
        end
    end
end

%%  ת��״̬��һ�� 

if flag1 == 1        % ���лص������״̬
    for j = 1:Ls
        if j == index
             pp_unif(j)=1-(1-pp(j))*sigma/y; %   ��һ״̬�뵱ǰ״̬���
        else
             pp_unif(j)= pp(j)*sigma/y;
        end
    end
    
else   % ����û�С��ص������״̬
    s_next(Ls+1,1:5) = s_current;
    for j =1:Ls
        pp_unif(j)= pp(j)*sigma/y;
    end
    pp_unif(Ls+1) = 1 - sigma/y;
end