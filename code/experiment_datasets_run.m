% Runs experiment on datasets and creates big result table
%
% Copyright (c) 2014 Aleksi Kallio

format long g

if ~exist('loadedDataVersion', 'var')
    load('datasets.mat')
end

disp(['Using data version: '  loadedDataVersion]);

stats = zeros(nDatas, 11);
swapStats = zeros(nDatas, nIters, 11);
maxentStats = zeros(nDatas, nIters, 11);
for i = 1:nDatas

    disp(['Processing dataset ' names{i} '...']);

    stats(i, :) = matrix_statistics(datas{i}, true);
    
    for j = 1:nIters
        
        swapStats(i, j, :) = matrix_statistics(swap_datas{i, j}, false);
        maxentStats(i, j, :) = matrix_statistics(maxent_datas{i, j}, false);
        
    end
    
end

save('results.mat', '-v7.3', 'stats', 'swapStats', 'maxentStats')
