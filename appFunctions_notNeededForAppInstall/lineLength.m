function [ LL, meanLL ] = lineLength( y )
% LINELENGTH calculates the line length of a signal using euclidian
% distance between each data point in the signal (with the pythagorean
% theorem). Outputs are:
%
% LL: The raw line length.
%
% meanLL: Line length divided by the number of sample points.
%
% example:
%
% y = [ 1 0 1 2 3 2 1 0 2 3 4 1 2 1 1 0 0 1 2];
% ll = lineLength(y)
%
% JP 2017


x = 1:length(y);

%{
for j = 1:length(x) - 1

    a = abs(x(j + 1) - x(j));
    b = abs(y(j + 1) - y(j));
    c(j) = sqrt(a.^2 + b.^2);
end

LL = sum(c);
%}

d = diff([x(:) y(:)]);
LL = sum(sqrt(sum(d.*d,2)));
  
meanLL = LL / length(x);

    