function [Q, V, policy] = V3_mdp_bellman_operator_calculateValue(P, PR, discount, Vprev, K)

% lhx
% [m1,n1]=size(PR);
% Q = -1000*ones(m1,n1);

% mdp_bellman_operator Applies the Bellman operator on the value function Vprev
%                      Returns a new value function and a Vprev-improving policy
% Arguments ---------------------------------------------------------------
% Let S = number of states, A = number of actions
%   P(SxSxA) = transition matrix
%              P could be an array with 3 dimensions or 
%              a cell array (1xA), each cell containing a matrix (SxS) possibly sparse
%   PR(SxA) = reward matrix
%              PR could be an array with 2 dimensions or 
%              a sparse matrix
%   discount = discount rate, in ]0, 1]
%   Vprev(S) = value function
% Evaluation --------------------------------------------------------------
%   V(S)   = new value function
%   policy(S) = Vprev-improving policy

% MDPtoolbox: Markov Decision Processes Toolbox
% Copyright (C) 2009  INRA
% Redistribution and use in source and binary forms, with or without modification, 
% are permitted provided that the following conditions are met:
%    * Redistributions of source code must retain the above copyright notice, 
%      this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright notice, 
%      this list of conditions and the following disclaimer in the documentation 
%      and/or other materials provided with the distribution.
%    * Neither the name of the <ORGANIZATION> nor the names of its contributors 
%      may be used to endorse or promote products derived from this software 
%      without specific prior written permission.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
% IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
% INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
% BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
% OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
% OF THE POSSIBILITY OF SUCH DAMAGE.


if iscell(P); S = size(P{1},1); else S = size(P,1); end;
if discount < 0 || discount > 1
     disp('--------------------------------------------------------')
     disp('MDP Toolbox ERROR: Discount rate must be in ]0; 1]')
     disp('--------------------------------------------------------')
elseif size(Vprev,1) ~= S
    disp('--------------------------------------------------------')
    disp('MDP Toolbox ERROR: Vprev must have the same dimension as P')
    disp('--------------------------------------------------------')
else
        
    if iscell(P)
        A = length(P);
        for a=1:A           
            Q(:,a) = PR(:,a) + discount*P{a}*Vprev;
        end
    else
        A = size(P,3);
        for a=1:A
            Q(:,a) = PR(:,a) + discount*P(:,:,a)*Vprev;
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     [V, policy] = max(Q,[],2);  % 返回值函数最大值，以及相对应动作索引。-1，索引为1,matlab下标从1开始
%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 新添加
    [s] = initial_state_platoon(K); 
    policy = randi([1, 9], size(Q, 1), 1);
    V = Q(sub2ind(size(Q), (1:size(Q, 1))', policy));
    for it = 1: S
        if strcmp(s{it,4},'A') && s{it,5} == 0 && policy(it) == 1
            V(it,1) = Q(it,2);
            policy(it) = 2;   % 因为数字先后顺序产生的结果，所以此处纠正； policy:存放最佳动作的索引
        end
        if strcmp(s{it,4},'F-1') && policy(it) == 2
            V(it,1) = Q(it,1);
            policy(it) = 1;
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end 
