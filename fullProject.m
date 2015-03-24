% % clear any previous data
clear;

daysPerYear = 252;

load equityReturns;
load liborReturns;
load benchmarkWeights;

numAssets = size(equityReturns, 2);

% ------------------------------------------------------------------------------
% analysis of returns
% ------------------------------------------------------------------------------
[analysisOfReturns, rowheaders] = analyzeReturns(equityReturns);

% output hw1
%csvwrite('hw1.csv', analysisOfReturns);

% efficient portfolio

% ------------------------------------------------------------------------------
% calculate the risk premia for the equity universe
% ------------------------------------------------------------------------------
equityRiskPremia = equityReturns - repmat(liborReturns, 1, 30);

% ------------------------------------------------------------------------------
% minimum variance portfolio
% ------------------------------------------------------------------------------
[weights, deviation] = ...
  getMinVariancePortfolio(cov(equityRiskPremia));
deviation = sqrt(daysPerYear) * deviation;
portReturn = (mean(equityRiskPremia) * weights') * daysPerYear;

writePortfolio('minVarPortfolio.csv', weights, portReturn, deviation, 0);

% ------------------------------------------------------------------------------
% unconstrained high-vol = 1.5 benchmark vol of 13.34% = 20%
% ------------------------------------------------------------------------------
portReturn = 0.85;
[weights, deviation] = ...
  getEfficientPortfolio(mean(equityRiskPremia), cov(equityRiskPremia), portReturn / daysPerYear);
deviation = sqrt(daysPerYear) * deviation;

writePortfolio('effHighVol.csv', weights, portReturn, deviation, 0);

% ------------------------------------------------------------------------------
% unconstrained mid-vol = benchmark vol = 13.34%
% ------------------------------------------------------------------------------
portReturn = 0.55;
[weights, deviation] = ...
  getEfficientPortfolio(mean(equityRiskPremia), cov(equityRiskPremia), portReturn / daysPerYear);
deviation = sqrt(daysPerYear) * deviation;

writePortfolio('effMidVol.csv', weights, portReturn, deviation, 0);

% ------------------------------------------------------------------------------
% constrained high-vol = 20%, long-only, max-weight < 6%
% ------------------------------------------------------------------------------
mu    = mean(equityReturns);
omega = cov(equityReturns);

% bounds
ub_weights = repmat(0.06, numAssets, 1);
lb_weights = repmat(0, numAssets, 1);

lambda = 1;
[weights] = getConstrainedPortfolio(lambda, mu, omega, ub_weights, lb_weights);
deviation = sqrt(daysPerYear) * sqrt(weights * omega * weights');
portReturn = daysPerYear * (mu * weights');

writePortfolio('consHighVol.csv', weights, portReturn, deviation, 0);

% ------------------------------------------------------------------------------
% constrained mid-vol = 13.34%, long-only, max-weight < 6%
% ------------------------------------------------------------------------------
lambda = 10;
[weights] = getConstrainedPortfolio(lambda, mu, omega, ub_weights, lb_weights);
deviation = sqrt(daysPerYear) * sqrt(weights * omega * weights');
portReturn = daysPerYear * (mu * weights');

writePortfolio('consMidVol.csv', weights, portReturn, deviation, 0);

% ------------------------------------------------------------------------------
% benchmark optimization - unconstrained portfolio
% ------------------------------------------------------------------------------
lambda = 70;
[weights] = getBenchmarkOptimizedPortfolio(lambda, ... 
                mu, omega, benchmarkWeights, [], [], [], []);
deviation = sqrt(daysPerYear) * sqrt(weights * omega * weights');
portReturn = daysPerYear * (mu * weights');
ir = mu * weights' / sqrt(weights * omega * weights');

writePortfolio('port_f.csv', weights, portReturn, deviation, ir);

% ------------------------------------------------------------------------------
% benchmark optimization - active weights between -5% and 5%
% ------------------------------------------------------------------------------
lambda = 1;
lb = repmat(-0.05, numAssets, 1);
ub = repmat(0.05, numAssets, 1);
[weights] = getBenchmarkOptimizedPortfolio(lambda, ... 
                mu, omega, benchmarkWeights, lb, ub, [], []);
deviation = sqrt(daysPerYear) * sqrt(weights * omega * weights');
portReturn = daysPerYear * (mu * weights');
ir = mu * weights' / sqrt(weights * omega * weights');

writePortfolio('port_g.csv', weights, portReturn, deviation, ir);


% ------------------------------------------------------------------------------
% benchmark optimization - active weights between -5% and 5%
% absolute weights are non-zero
% ------------------------------------------------------------------------------
lambda = 0.25;
lb = repmat(-0.05, numAssets, 1);
ub = repmat(0.05, numAssets, 1);
acons = -1 * eye(numAssets);
bcons = benchmarkWeights';
[weights] = getBenchmarkOptimizedPortfolio(lambda, ... 
                mu, omega, benchmarkWeights, lb, ub, acons, bcons);
deviation = sqrt(daysPerYear) * sqrt(weights * omega * weights');
portReturn = daysPerYear * (mu * weights');
ir = mu * weights' / sqrt(weights * omega * weights');

writePortfolio('port_h.csv', weights, portReturn, deviation, ir);

% ------------------------------------------------------------------------------
% benchmark optimization - active weights between -5% and 5%
% absolute weights are non-zero
% cross-sectional winsorization
% ------------------------------------------------------------------------------

% do a cross-sectional winsorization
% for cross-sectional winsorization just winsorize the transpose of the equityReturn
winsorizedReturns = winsorize(equityReturns', 1.5);
winsorizedReturns = winsorizedReturns';

mu    = mean(winsorizedReturns);
omega = cov(winsorizedReturns);

lambda = 0.25;
lb = repmat(-0.05, numAssets, 1);
ub = repmat(0.05, numAssets, 1);
acons = -1 * eye(numAssets);
bcons = benchmarkWeights';
[weights] = getBenchmarkOptimizedPortfolio(lambda, ... 
                mu, omega, benchmarkWeights, lb, ub, acons, bcons);
deviation = sqrt(daysPerYear) * sqrt(weights * omega * weights');
portReturn = daysPerYear * (mu * weights');
ir = mu * weights' / sqrt(weights * omega * weights');

writePortfolio('port_i.csv', weights, portReturn, deviation, ir);
