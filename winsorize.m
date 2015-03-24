% ------------------------------------------------------------------------------
%  cross-sectional winsorization
%  Inputs:
%     input:        the input data set
%     cutoff_stdev: number of stddevs above which the outliers are trimmed
%  Outputs:
%     output: the winsorized output 
% ------------------------------------------------------------------------------
function [output] = winsorize(input, cutoff_stdev)
  % get the median of the input
  m = median(input);
  m_matrix = repmat(m, size(input, 1), 1);

  % get the median based standard-deviation
  sigma = sqrt(sum((input - repmat(m, size(input, 1), 1)) .* ... 
          (input - repmat(m, size(input, 1), 1))) / size(input, 1));

  % the upper limit of the data for the winsorization
  upper_limit = m + (cutoff_stdev * sigma);

  % the lower limit of the data for the winsorization
  lower_limit = m - (cutoff_stdev * sigma);

  % do the winsorization
  for i = 1:size(input, 2)
    output(:,i) = min(input(:,i), upper_limit(:,i));
    output(:,i) = max(input(:,i), lower_limit(:,i));
  end
end
