function [avg] = GetAvg(X)
% Getting the average values of a given matrix - mean of each column - used
% for avg_bodyline and avg_fin
[a, b] = size(X);

avg = zeros(b, 1);

for i = 1:b
    avg(i, 1) = mean(X(:, i)); 
end

end