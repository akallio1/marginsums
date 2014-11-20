% Calculate various statistics from a matrix
%
% Copyright (c) 2014 Aleksi Kallio

function stats = matrix_statistics(M, accurate)

mplot(M);
hold on
[m, n] = size(M);


% 1. - 3. pairwise correlations of taxa
pPos = zeros(1, n*(n-1)/2);
pNeg = zeros(1, n*(n-1)/2);
pBoth = zeros(1, n*(n-1)/2);
i = 0;
for i1 = 1:(n-1)
    for i2 = (i1+1):n
        
        a = sum(M(:, i1) & M(:, i2));
        b = sum(~M(:, i1) & M(:, i2));
        c = sum(M(:, i1) & ~M(:, i2));
        d = sum(~M(:, i1) & ~M(:, i2));
        
        if sum([a,b,c,d]) ~= length(M(:, i1))
            error('internal error')
        end
        
         i = i + 1;
         pPos(i) = fexact(a, a+b+c+d, a+c, a+b, 'tail', 'r');
         pNeg(i) = fexact(a, a+b+c+d, a+c, a+b, 'tail', 'l');
         pBoth(i) = fexact(a, a+b+c+d, a+c, a+b, 'tail', 'b');

    end
end

if i ~= n*(n-1)/2
    error('internal error')
end


pCutoff =  10^-6; % no multiple testing correction
stats(1) = sum(pPos < pCutoff);
stats(2) = sum(pNeg < pCutoff);
stats(3) = sum(pBoth < pCutoff);

% 4. mean correlation p-value
stats(4) = mean(pPos); % mean Fisher correlation


% 5. switch box count (nestedness)
stats(5) = sbcount_prod(M);

% 6. - 8. clustering structure
if accurate
    repls = 100;
else
    repls = 1;
end
warningState = warning('query', 'all');
warning off all; % not interested if k-means fails to converge
[~, ~, SUMD] = kmeans(M, 2, 'replicates', repls, 'emptyaction', 'singleton');
stats(6) = sum(SUMD);
[~, ~, SUMD] = kmeans(M, 5, 'replicates', repls, 'emptyaction', 'singleton');
stats(7) = sum(SUMD);
[~, ~, SUMD] = kmeans(M, 10, 'replicates', repls, 'emptyaction', 'singleton');
stats(8) = sum(SUMD);
warning(warningState);


% 9. - 11. PCA

% standardise to unit variances
M2=M-repmat(mean(M), m, 1); % standardise columns to zero mean
M3=M2./repmat(std(M2), m, 1); % standardise columns to unit variance
M3(isnan(M3)) = 0; % fix constant columns (div-by-zero)
[~, ~, explained]=pcacov(cov(M3));
stats(9) = sum(explained(1:2));
stats(10) = sum(explained(1:5));
stats(11) = sum(explained(1:10));

