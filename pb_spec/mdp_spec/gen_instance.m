% Problem settings
depot = [0,0; 4,0; 0,3; 4,4];
mdpinstance.depot = depot;
mdpinstance.start = 1;
mdpinstance.goal = 4;
mdpinstance.maxH = maxH;
mdpinstance.nAct = 5;

% MDP solver specifications
mdpinstance.epsilon = 1e-1;
mdpinstance.maxIter = 1e2;
mdpinstance.gamma = 1; % MDP discount factor

% Generate reference trajectory
% ref = zeros(instance.maxH, 2);  % [u_k, x_{k+1}]_{ref}, k = 0,1,...,maxH.
ref = repmat(depot(mdpinstance.goal,:), mdpinstance.maxH, 1);
ref1 = [0,0;1,0;2,0;2,1;2,2;2,3;3,3;4,3;4,4];
ref(1:size(ref1, 1),:) = ref1;

clear depot ref1