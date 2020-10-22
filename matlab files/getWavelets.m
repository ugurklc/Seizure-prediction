function [w_coeff,w_entropy] = getWavelets(data,window_size,overlap_size)

[n_ch,n_seg] = size(data);
n_windows = ceil(n_seg/(window_size - overlap_size));

window_scale = kaiser(window_size,2.4)';
n_f = 24;
w_coeff = zeros(n_ch,n_windows-2,n_f);
w_entropy = zeros(1,n_ch);
for i = 1:n_ch
    idx = 1;
    ent = 0;
    
    for start_idx = 1:window_size-overlap_size:n_seg
        end_idx = min(n_seg,start_idx+window_size)-1;
        if end_idx - start_idx < window_size-1
            break
        end
        win = data(i,start_idx:end_idx).* window_scale;
        [c,l] = wavedec(win,5,'db1'); % w_decomp
        l = cumsum([1,l(1:end-1)]);
        w_feat = zeros(1,n_f);
        e = zeros(1,6);
        for k = 1:6
            tmp = c(l(k):l(k+1)-1);
            w_feat(4*k-3:4*k) = [mean(tmp), mean(abs(tmp)),...
                                mean(tmp.^2), std(tmp)];
            e(k) = entropy_bin(tmp,0.1);
        end
        ent = ent+mean(e);
        w_coeff(i,idx,:) = w_feat;
        idx = idx+1;
    end
    w_entropy(i) = ent/idx;
end

end

