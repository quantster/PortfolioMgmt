% ------------------------------------------------------------------------------
%   Compute the weight and std-deviation of the max Sharpe-ratio portfolio
%   given the excess returns and the covariance matrix of the investable universe
% ------------------------------------------------------------------------------
function [weights, deviation] = getMaxSharpeRatioPortfolio(eta, omega)
  [rows,cols] = size(omega);
  omega_inv = inv(omega);
  i = repmat(1,1,cols);
  weights = (eta * omega_inv) / (eta * omega_inv * i');
  deviation = sqrt(weights * omega * weights');
end
