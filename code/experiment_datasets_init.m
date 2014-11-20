% Initialises datasets and creates randomized data
%
% Copyright (c) 2014 Aleksi Kallio

nDatas = 5;
nIters = 1000;

% Load data
disp('Loading original data and generating randomized...')
load '../data/hm20110608d.mat' % from NOW database
load '../data/vanuatu.mat' % from Diamond & Marshall (1976)

% Filter to include only mamcat=lala
data = data(:,  strcmp(taxoninfo.mamcat, 'lala'));

% Collectors that will hold the generated data
datas = cell(1, nDatas);
names = cell(1, nDatas);
swap_datas = cell(nDatas, nIters);
maxent_datas = cell(nDatas, nIters);

% Pick MN classes, filter too rare taxa
MN5data = data(siteinfo.siteMN==5, :);
names{1} = 'NOW MN5';
datas{1} = MN5data(:, sum(MN5data) > 10);

MN9data = data(siteinfo.siteMN==9, :);
names{2} = 'NOW MN9';
datas{2} = MN9data(:, sum(MN9data) > 10);

MN12data = data(siteinfo.siteMN==12, :);
names{3} = 'NOW MN12';
datas{3} = MN12data(:, sum(MN12data) > 10);

names{4} = 'NOW';
datas{4} = data(:, sum(data) > 10);

datas{5} = vanuatudata;
names{5} = 'Vanuatu'

% Print what we just did
for i = 1:nDatas
    disp(['Created original data ' names{i}]);
end

% Create randomized datas
for j = 1:nIters
    disp(['Generating randomized sample set ' num2str(j) ' of ' num2str(nIters)]);
    for i = 1:nDatas
        swap_datas{i, j} = swap(datas{i}, sum(sum(datas{i}))*1000);
        maxent_datas{i, j} = domaxent(datas{i});
    end
end

% Flag/description to be included with data
loadedDataVersion = 'published version';
 
% Finally, save all relevant variables
disp('Saving data to disk...')
save('datasets.mat', '-v7.3', 'datas', 'swap_datas', 'maxent_datas', 'names', 'nDatas', 'nIters', 'loadedDataVersion')

disp('Done!')