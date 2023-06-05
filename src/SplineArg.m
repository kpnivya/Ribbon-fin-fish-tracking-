function [cs, xx] = SplineArg(x, y)
% To interpolate the data - cubic spline approximation
cs = spline(x,[0 y 0]);
xx = linspace(min(x),max(x), 3*length(x));

end