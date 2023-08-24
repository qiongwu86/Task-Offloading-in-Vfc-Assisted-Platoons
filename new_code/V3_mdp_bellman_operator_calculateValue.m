function [Q, V, policy] = V3_mdp_bellman_operator_calculateValue(P, PR, discount, Vprev)

A = length(P);
for a=1:A           
    Q(:,a) = PR(:,a) + discount*P{a}*Vprev;
end

[V, policy] = max(Q,[],2);

end 
