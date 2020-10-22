function eng_bands = getBandsEng(spectrums,feq,bands)

n_bands = size(bands,1);
n_feq = size(feq,1);
[n_seq,h,~] = size(spectrums);

idx_bands = cell(1,n_bands);


for i = 1:n_feq
    for j = 1:n_bands
        if bands(j,1) <= feq(i) && feq(i) < bands(j,2)
            idx_bands{j} = [idx_bands{j},i];
        end
    end
end

eng_bands = zeros(n_seq,n_bands);
for i = 1:n_seq
    for j = 1:n_bands
        eng = 0;
        for k = 1:h
            win = squeeze(spectrums(i,k,:));
            start_idx = idx_bands{j}(1);
            end_idx = idx_bands{j}(end);
            eng = eng + sum(win(start_idx:end_idx));
        end
        eng_bands(i,j,:) = eng;
    end
end
eng_bands = normalization(eng_bands,1);

end