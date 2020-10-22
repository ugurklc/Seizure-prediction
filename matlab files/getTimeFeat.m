function feat = getTimeFeat(data)
% extract time domain feature from original data
% Input:
%   data: matrix in the 'data' field of the original struct
% Output:
%   feat: 1-by-N feature vector

n = size(data,1);
E = zeros(n,1);

for i = 1:n
    E(i) = entropy_bin(data(i,:),1);
end

if size(data,2) > 400
    resampled = interpft(data',400);
    resampled = resampled';
else
    resampled = data;
end

resampled = normalization(resampled,1);
corr_feat = getCorrFeat(resampled');
feat = [corr_feat, max(E),min(E),mean(E)];

end

