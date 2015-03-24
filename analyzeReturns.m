function [output, rowheaders] = analyzeReturns(equityReturns)
  daysPerYear = 252;

  rowheaders = char('size', 'mean', 'annual mean', 'std', 'annual std', 'min', 'max', 'skewness', 'kurtosis');

  numColumns = size(equityReturns,2);

  % number of data points per equity
  output(1,1:numColumns) = size(equityReturns,1);

  % daily and annual mean
  output(2,1:numColumns) = mean(equityReturns);
  output(3,1:numColumns) = daysPerYear * output(2,1:numColumns);

  % daily and annual stddev
  output(4,1:numColumns) = std(equityReturns);
  output(5,1:numColumns) = sqrt(daysPerYear) * output(4,1:numColumns);

  % min and max
  output(6,1:numColumns) = min(equityReturns);
  output(7,1:numColumns) = max(equityReturns);
  
  % skewness of the daily returns
  output(8,1:numColumns) = skewness(equityReturns);
  
  % kurtosis of the daily returns
  output(9,1:numColumns) = kurtosis(equityReturns);
end

