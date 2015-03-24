% ------------------------------------------------------------------------------
%   Use the Matlab optimizer to get the benchmark optimized portfolio
% ------------------------------------------------------------------------------
function [ weights] = getBenchmarkOptimizedPortfolio(lambda, ... 
          mu, omega, benchmarkWeights, lb, ub, a, b)
  % calculate the beta vector
  beta = benchmarkWeights * omega / (benchmarkWeights * omega * benchmarkWeights');
  alpha = mu - (benchmarkWeights * mu')*beta;

  % setup and run the optimization
  fun = @benchmarkObjectiveFunction;

  numAssets = size(omega, 2);
  x0 = repmat(1/numAssets, numAssets, 1)';
  % equality constraints 
  % fully invested
  aeq(1,:) = ones(1, numAssets);
  % beta neutral
  aeq(2,:) = beta; beq = [0; 0];

  nonlcon = []; options = [];
  arg1 = alpha;
  arg2 = omega;
  arg3 = lambda;
  [x, fval, exitflag, output] = ... 
    fmincon(fun, x0, a, b, aeq, beq, lb, ub, nonlcon, options, arg1, arg2, arg3)
  weights = x;
end
