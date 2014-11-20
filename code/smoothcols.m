function x = smoothcols(y)

x = zeros(size(y));
for I = 1:size(y, 2)
    x(:,I) = smooth(y(:,I), 50);
end