function [feat,label] = extractFeatureDog(file_name)
% extract all features from dog data
% Input:
%   file_name: mat file name
% Output:
%   feat: feature vector with xxx elements
%   label: binary label 0 - interictal, 1 - preictal

mat_file = load(file_name);
var_name = fieldnames(mat_file); var_name = var_name{1};
label = double(contains(var_name,'preictal'));

seg = getfield(mat_file,var_name); %#ok<GFLD>
data = seg.data;

% entropy and correlation feature
time_domain_feat = getTimeFeat(data);

% wavelet and entropy feature
window_size = 2400;
overlap_size = 1200;
wavelet_feat = getWaveletFeat(data,window_size,overlap_size);

% spectral engery feature
spectral_feat = getSpecFeat(data,window_size,overlap_size);

% concatenate
feat = [time_domain_feat,wavelet_feat,spectral_feat];
end