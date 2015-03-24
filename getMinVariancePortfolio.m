% ------------------------------------------------------------------------------
%   Compute the weight and std-deviation of the min-variance portfolio given
%   the covariance matrix of the investable universe
% ------------------------------------------------------------------------------
function [weights, deviation] = getMinVariancePortfolio(omega)
  [rows,cols] = size(omega);
  omega_inv = inv(omega);
  i = repmat(1,1,cols);
  weights = (i * omega_inv) / (i * omega_inv * i');
  deviation = sqrt(weights * omega * weights');
end
