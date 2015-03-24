% ------------------------------------------------------------------------------
%   The objective function for benchmark optimization
% ------------------------------------------------------------------------------
%   alpha:    expected active returns
%   omega:    covariance matrix of the investable universe
%   lambda:   measure of risk aversion
%   active_weights:  portfolio active_weights
function output = objectiveFunction(a, alpha, omega, lambda)
  output = -1 * (alpha*a' - 0.5*lambda*(a*omega*a'));
end
