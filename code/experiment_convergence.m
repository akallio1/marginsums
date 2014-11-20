% Runs experiment on convergence of swap chains with original and Rasch input
%
% Copyright (c) 2014 Aleksi Kallio


if ~exist('loadedDataVersion', 'var')
    load('datasets.mat')
end
M=datas{1};
    
nOrig = 10;
nRasch = 10;
nSteps = 200;
nSwaps = 10;

cc = zeros(nOrig + nRasch, nSteps);

oc = count_correlations(M);
OM = cell(1, nOrig);
for i = 1:nOrig
    OM{i} = M;
    cc(i, 1) = oc;
end

RM = cell(1, nRasch);
for i = 1:nRasch
    RM{i} = domaxent(M);
    cc(i + nOrig, 1) = count_correlations(RM{i});
end

for i = 2:nSteps
    for j = 1:nOrig
        OM{j} = swap(double(OM{j}), nSwaps);
        cc(j, i) = count_correlations(OM{j});
    end
    for j = 1:nRasch
        RM{j} = swap(double(RM{j}), nSwaps);
        cc(j + nOrig, i) = count_correlations(RM{j});
    end
end

% Plot chains
figure
hold on
maxSwaps = (nSteps - 1)*nSwaps;

% Original and swapped matrices
plot(zeros(1, nOrig), cc(1:nOrig, 1), 'ko');
plot(ones(1, nOrig)*maxSwaps, cc(1:nOrig, end), 'ko');

% Rasch and swapped Rasch matrices
plot(zeros(1, nRasch), cc((nOrig+1):end, 1), 'kx');
plot(ones(1, nRasch)*maxSwaps, cc((nOrig+1):end, end), 'kx');

% All chains (lines)
plot(0:nSwaps:maxSwaps, smoothcols(cc(1:nOrig, :)'), 'k-');
plot(0:nSwaps:maxSwaps, smoothcols(cc((nOrig+1):end, :)'), 'k--');

title('Convergence of swap chains')


% Test distributions
                                   
disp('Kolmogorov-Smirnov two sample test for samples coming from same distribution (swapped - swapped Rasch)');
[~,p]=kstest2(cc(1:10, end), cc(11:end, end))

disp('Kolmogorov-Smirnov two sample test for samples coming from same distribution (Rasch - swapped Rasch)');
[~,p]=kstest2(cc(11:end, 1), cc(11:end, end))

disp('Kolmogorov-Smirnov two sample test for samples coming from same distribution (swapped - Rasch)');
[~,p]=kstest2(cc(1:10, end), cc(11:end, 1))

