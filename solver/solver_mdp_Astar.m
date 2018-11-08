function [xu] = solver_mdp_Astar(ref, instance, alpha)
% This function solves the motion planning of a MDP model. Using the
% orignal cost function plus the distance to the reference trajectory as
% the new cost function, we solve the MDP problem and outputs the optimal
% trajectory.
%
% We assume that the system is deterministic. So the output trajectory
% given a starting point is also deterministic.
%
% The MDP problem uses the taxi-passenger example from the RL class, 2015
% Fall, except that we make the environment deterministic and the taxi only
% needs to drive to the goal position.
%
% State variable: s = [s1, s2, t], s_i \in {0,1,2,3,4}, t is time.
% Action set: A(s) = [a1, a2, a3, a4, a5] (indexed by [1,2,3,4, 5])
%                   up right down left stay
% Transition: s_{k+1} = T(s_{k}, a_i)
% Reward function: R(s_{k}, a_i, s_{k+1})
%   case 1: if not at the goal position, and the action doesn't lead to the
%   goal position, the reward is -1 minus the current distance to the
%   reference trajectory.
%   case 2: if not at the goal position, and the action leads to the goal
%   position, the reward is +10 minus the current distance to the reference
%   trajectory.
%   case 3: if at the goal position, whatever action it takes, the reward
%   is 0 minus the current distance to the reference trajectory.
global mdpverbose
% Initialize A* algorithm
maxH = instance.maxH;
maxIter = instance.maxIter;
depot = instance.depot;
goal = [depot(instance.goal, :), maxH-1];
nAct = instance.nAct;
neighbor = zeros(nAct, 4);
new_cost = zeros(nAct, 1);
frontier = [0,0,0,0]; 
            % The first point in the frontier is the source position with
            % cost 0
come_from = zeros(5,5, maxH);
cost_so_far = ones(5,5, maxH)*inf;  cost_so_far(1,1,1) = 0;
cnt_itr = 0;
flag = 0;
while ~isempty(frontier) && cnt_itr < maxIter
    current = frontier(1,1:3);
    frontier(1, :) = []; % Remove the examined node
    if all(current(1:3) == goal)
        if mdpverbose
           fprintf(['A star succeeds at the ', num2str(cnt_itr), ...
               ' steps!\n'])
        end
        flag = 1;
        break;
    end
    % Find the neighbor nodes
    temp1 = num2cell(current + 1);
    for aa = 1 : nAct
        neighbor(aa,1:3) = move(current, aa, instance);
        % Get the neighbor's costs
        nt = neighbor(aa,3);
        if isempty(ref)
             new_cost(aa) = cost_so_far(temp1{:}) + 1;
        else
            new_cost(aa) = cost_so_far(temp1{:}) + 1 + ...
                alpha*norm(neighbor(aa,1:2) - ref(nt,1:2))^2;
        end
        temp2 = num2cell(neighbor(aa,1:3)+1);
        if new_cost(aa) < cost_so_far(temp2{:})
            cost_so_far(temp2{:}) = new_cost(aa);
            heuristic = norm(neighbor(aa,1:2) - goal(1:2))^2;
            priority = new_cost(aa) + heuristic;
            frontier = [neighbor(aa,1:3), priority; frontier];
            come_from(temp2{:}) = sub2ind([5,5], temp1{1:2});
        end
    end
    frontier = sortrows(frontier, 4);
    cnt_itr = cnt_itr + 1;
    if mdpverbose
        if mod(cnt_itr, 1000) == 1
        fprintf(['MDP A star solver: ', num2str(cnt_itr), ' th iters:', ...
            '...\n'])
        end
    end
end

if mdpverbose && ~flag
    fprintf(['A star fails at the ', num2str(cnt_itr), ...
       ' iterations!\n'])    
end

% Generate the trajectory
xu = zeros(maxH, 3);
xu(maxH, 1:2) = goal(1:2);
ss = goal;
for tt = 1 : (maxH-1)
    jj = maxH - tt;
    temp1 = num2cell(ss+1);
    [row, col] = ind2sub([5,5], come_from(temp1{:}));
    xu(jj,1:2) = [row, col]-1;
    ss = [row - 1, col - 1, jj-1];
end

end