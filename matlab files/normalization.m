function out = normalization(in,axis)
% zero mean and unit var

means = mean(in,axis);
stds = std(in,0,axis);

out = (in-means) ./ stds;
end