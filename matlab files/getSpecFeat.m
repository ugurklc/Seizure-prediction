function feat = getSpecFeat(data,window_size,overlap_size)

[spectrums, feq, spec_ent] = getSpectrums(data,window_size,overlap_size);
% spectrums: 16x198x198
% feq: 1x198
% spec_ent: 1x16

n_ch = size(spectrums,1);
for i = 1:n_ch
    tmp_coeff = squeeze(spectrums(i,:,:));
    spectrums(i,:,:) = normalization(tmp_coeff,2);
end

bands = [0.1,2; 2,4; 4,8; 8,12; 12,18; 18,22; 22,30; 30,50; 50,200];

eng_bands = getBandsEng(spectrums,feq,bands);

corr = getCorrFeat(eng_bands');

eng_flatten = reshape(eng_bands.',1,[]);
feat = [eng_flatten,corr,mean(spec_ent),std(spec_ent)];
end