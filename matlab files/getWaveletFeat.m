function feat = getWaveletFeat(data,window_size,overlap_size)

[w_coeff,w_entropy] = getWavelets(data,window_size,overlap_size); 
% w_coeff: 16x198x24
% wentropy: 1x16


[n,h,w] = size(w_coeff);
for i = 1:n
    tmp_coeff = squeeze(w_coeff(i,:,:));
    w_coeff(i,:,:) = normalization(tmp_coeff,2);
end

bands = zeros(n,w);

for i = 1:n
    for j = 1:h
        tmp = squeeze(w_coeff(i,j,:));
        bands(i,:) = bands(i,:) + tmp';
    end
    bands(i,:) = bands(i,:)/n;
end
bands = normalization(bands,1);

corr = getCorrFeat(bands');

bands_flatten = reshape(bands.',1,[]);
feat = [bands_flatten,corr,mean(w_entropy),std(w_entropy)];
end