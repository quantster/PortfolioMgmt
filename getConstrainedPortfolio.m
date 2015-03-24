% ------------------------------------------------------------------------------
%   Use the Matlab optimizer to get the constrained portfolio
% ------------------------------------------------------------------------------
function [weights] = getConstrainedPortfolio(lambda, mu, omega, ub, lb)
  fun = @portfolioObjectiveFunction;

  numAssets = size(omega, 2);
  x0 = repmat(1/numAssets, numAssets, 1);

  % inequality constraints
  a = []; b = [];

  % equality constraints - fully invested portfolio
  aeq = ones(1, numAssets); beq = [1];

  nonlcon = [];
  options = [];
  arg1 = mu;
  arg2 = omega;
  arg3 = lambda;

  [x, fval, exitflag, output] = ... 
    fmincon(fun, x0, a, b, aeq, beq, lb, ub, nonlcon, options, arg1, arg2, arg3)

  weights = x';
end
