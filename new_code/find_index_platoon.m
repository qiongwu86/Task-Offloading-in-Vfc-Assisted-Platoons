%   ��⣬ĳһ�����£�ת�Ƶ�����״̬�ĸ��� * ����״̬�ļ�ֵ������Ϊ����һ��״̬�£���ȡһ�������������ֵ��������̵�
function [V_8next,s_next] = find_index_platoon(s,i,s_next,N,pp,pp_unif,V_old,flag1)

if flag1==1  % �лص������״̬
    Ls=length(s_next)-1;
else
    Ls=length(s_next);
end

V_8next = zeros(Ls,1);   
                
                %   �����е���һ��״̬����һ�飬Ѱ����һ��״̬������
                for y = 1: Ls   
                    flag = 0;     %�ҵ��¸�״̬��������flag��1
                    for nn = 1: N
                        if s{nn,2}(1)==s_next{y,2}(1) && s{nn,2}(2)==s_next{y,2}(2) && s{nn,2}(3)==s_next{y,2}(3)&& s{nn,2}(4)==s_next{y,2}(4) && s{nn,3}(1)==s_next{y,3}(1) && s{nn,3}(2)==s_next{y,3}(2) && s{nn,3}(3)==s_next{y,3}(3)
                            if s{nn,1}==s_next{y,1}&&strcmp(s{nn,4}, s_next{y,4})%�¼�
                                s_next_index = nn;
                                s_next{y,7} = s_next_index;
                                flag = 1;
                                break;%����һ��ѭ��
                            end
                        end
                    end %% �ҵ������Ƿ�Ψһ��Ӧ������
                    
                    
                    if flag == 0 && pp(y)~=0    %���������û���ҵ��¸�״̬�������ͱ���
                        fprintf('��ʼ״̬�ǵ� %d ��\n',i);
                        fprintf('�¸�״̬�ĵ� %d ��\n',y);
                        disp('û���ҵ��¸�״̬������������');
                        disp('************************');
                    end
                    
                    if flag ==1
                        V_8next(y) = pp_unif(y)*V_old(s_next_index);    % ��һ��״̬  *  ��һ��״̬�ľ�ֵ����
                    else
                        V_8next(y) = 0;
                    end
                    s_next{y,8} = pp_unif(y,1);
                end