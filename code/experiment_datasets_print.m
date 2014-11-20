% Prints the big result table in Latex
%
% Copyright (c) 2014 Aleksi Kallio

format = '%.3f';

if ~exist('stats', 'var')
    load('results.mat')
end

fid = fopen('results.tex','w');

fprintf(fid,'\\begin{table}\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\begin{tabular}{lrrrrr}\n');

isErrorMeasure = [0 0 0 -1 1 1 1 1 0 0 0];
% Prune part or the statistics
sname = {'Correlation count (pos)','Correlation count (neg)','Correlation count (both)','DO NOT SHOW','Switch box count','Clustering error (k=2)','Clustering error (k=5)','Clustering error (k=10)','DO NOT SHOW','DO NOT SHOW','DO NOT SHOW'};
fprintf(fid,'\n\\hline\n');
for i = [1 5]
    [m,n] = size(datas{i});

    fprintf(fid,'\\multicolumn{6}{c}{ Dataset %s } (%i rows and %i columns with fill ratio of %s) \\\\\n', names{i}, m, n, formatnum(sum(sum(datas{i}))/numel(datas{i})));
    fprintf(fid,'\n\\hline\n');

    fprintf(fid,'\\multicolumn{2}{c}{Original} & \\multicolumn{2}{c}{Strict model} & \\multicolumn{2}{c}{Rasch model} \\\\\n');

    fprintf(fid,'Measure &  & Measure (std) & p & Measure (std) & p \\\\\n');
    fprintf(fid,'\n\\hline\n');
    
    mSwapStats = median(squeeze(swapStats(i, :, :)));
    mSwapStd = std(squeeze(swapStats(i, :, :)));
    mMaxentStats = median(squeeze(maxentStats(i, :, :)));
    mMaxentStd = std(squeeze(maxentStats(i, :, :)));
    mSwapP = (sum(squeeze(swapStats(i, :, :)) <= repmat(stats(i, :), nIters, 1)) + 1) / (nIters + 1);
    mMaxentP = (sum(squeeze(maxentStats(i, :, :)) <= repmat(stats(i, :), nIters, 1)) + 1) / (nIters + 1);
    mSwapPInv = (sum(squeeze(swapStats(i, :, :)) >= repmat(stats(i, :), nIters, 1)) + 1) / (nIters + 1);
    mMaxentPInv = (sum(squeeze(maxentStats(i, :, :)) >= repmat(stats(i, :), nIters, 1)) + 1) / (nIters + 1);
    
    for si = [1:3 5:8]
        if isErrorMeasure(si) == 1
            fprintf(fid,[sname{si} ' & ' formatnum(stats(i, si), 2) ' & ' formatnum(mSwapStats(si),2) ' (' formatnum(mSwapStd(si),2) ') & ' formatnum(mSwapP(si),3) ' & ' formatnum(mMaxentStats(si),2) ' (' formatnum(mMaxentStd(si),2) ') & ' formatnum(mMaxentP(si),3) '\\\\\n']);
        else 
            fprintf(fid,[sname{si} ' & ' formatnum(stats(i, si), 2) ' & ' formatnum(mSwapStats(si),2) ' (' formatnum(mSwapStd(si),2) ') & ' formatnum(mSwapPInv(si),3) ' & ' formatnum(mMaxentStats(si),2) ' (' formatnum(mMaxentStd(si),2) ') & ' formatnum(mMaxentPInv(si),3) '\\\\\n']);
        end
    end    
      
    fprintf(fid,'\n\\hline\n');

end

fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\caption{Statistics measured for original datasets and compared to randomized datasets with both the strict margin sum null model and Rasch model. Median measure over all randomizations is reported for randomized data.}\n');
fprintf(fid,'\\label{tab:big_table}\n');
fprintf(fid,'\\end{table}\n');

fclose(fid);
