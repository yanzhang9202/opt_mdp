%% Algorithm specification
switch alg_type
    case 'adal'
        adal.tau = 1/2;
        adal.rho = 1;
        adal.maxIter = 1e2;

        x1 = zeros(2*pb.maxH, adal.maxIter);
        x2 = zeros(2*pb.maxH, adal.maxIter);
        lambda = zeros(2*pb.maxH,1);
        
    otherwise
end