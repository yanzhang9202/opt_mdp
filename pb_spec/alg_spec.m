%% Algorithm specification
switch alg_type
    case 'adal'
        adal.tau = 1/2;
        adal.rho = 5e-1;
        adal.maxIter = 2.6e1;
        adal.epsilon = 1e-2;
        
        maxH = mdpinstance.maxH;
        x1 = zeros(2*maxH, adal.maxIter);    % solution of mdp
        x2 = zeros(2*maxH, adal.maxIter);    % solution of optimization
        lambda = zeros(2*maxH,1);
        x1_itr = zeros(maxH, 2);
    otherwise
end

clear maxH