% ------------------------------------------------------------------------------
%  This function returns the negative of the objective function.
%  We will use the optimizer to minimize this function to obtain the contrained
%  portfolios.
% ------------------------------------------------------------------------------
%   mu:       expected returns
%   omega:    covariance matrix of the investable universe
%   lambda:   measure of risk aversion
%   weights:  portfolio weights
function output = portfolioObjectiveFunction(weights, mu, omega, lambda)
  output = -1 * (mu*weights - 0.5*lambda*(weights'*omega*weights));
end
