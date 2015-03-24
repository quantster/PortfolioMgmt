% ------------------------------------------------------------------------------
%   Compute the weight and std-deviation of the efficient portfolio given
%   the expected returns, the covariance of the investable universe, and
%   the desired portfolio return
% ------------------------------------------------------------------------------
function [weights, deviation] = getEfficientPortfolio(mu, omega, mu_p)
  omega_inv = inv(omega);
  i = repmat(1,size(mu));
  A = i * omega_inv * mu';
  B = mu * omega_inv * mu';
  C = i * omega_inv * i';
  D = B*C - A*A;

  g = (B*i*omega_inv - A*mu*omega_inv) / D;
  h = (C*mu*omega_inv - A*i*omega_inv) / D;

  weights = g + h*mu_p;
  deviation = sqrt(weights * omega * weights');
end
