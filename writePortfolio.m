function writePortfolio(fileName, weights, portReturn, deviation, ir)
  output = weights;
  output(1,size(weights,2)+1) = portReturn;
  output(1,size(weights,2)+2) = deviation;
  output(1,size(weights,2)+3) = ir;
  csvwrite(fileName, output');
end
