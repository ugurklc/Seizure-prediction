clear;
fullFileName = which(mfilename); ptr = fileparts(fullFileName); cd(ptr);
addpath(genpath('../'))

dog_id = 'Dog_1';

% config directory
save_dir = fullfile('..','results',dog_id);
if exist(save_dir) ~= 7 %#ok<EXIST>
    mkdir(save_dir);
end

file_list = dir(fullfile('..','data',dog_id,[dog_id,'_*.mat']));
n_file = length(file_list);

% config parallel pool
p = gcp('nocreate');
if isempty(p)
    cluster = parcluster('local')
    numWoker = cluster.NumWorkers
    parpool('local',numWoker)
end

% run
tic
parfor i = 1:n_file
   file_name = file_list(i).name;
   [feat,label] = extractFeatureDog(file_name);
   
   [~,f,~] = fileparts(file_name)
   save_name = fullfile(save_dir,[f,'_feat.mat']);
   parsave(save_name,feat,label);
end
toc
