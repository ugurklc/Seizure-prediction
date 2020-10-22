function [spectrums, feq, spec_ent] = getSpectrums(data,window_size,overlap_size)

[n_ch,n_seg] = size(data);
n_windows = ceil(n_seg/(window_size - overlap_size));

window_scale = kaiser(window_size,2.4)';


spec_ent = zeros(1,n_ch);
feq_cap = 198;
spectrums = zeros(n_ch,n_windows-2,feq_cap);
feq = zeros();

for i = 1:n_ch
    idx = 1;
    ent = 0;
    
    for start_idx = 1:window_size-overlap_size:n_seg
        end_idx = min(n_seg,start_idx+window_size)-1;
        if end_idx - start_idx < window_size-1
            break
        end
        
        win = data(i,start_idx:end_idx).* window_scale;
        
        w = triang(801); w= w(1:800);
        [pxx,f] = pwelch(win,w,400,800,400);
        
        s = log(pxx(1:feq_cap));
        ent = ent + entropy_bin(s,0.1);
        
        th = prctile(s,75);
        s(s<=th) = 0 ;

        spectrums(i,idx,:) = s;
        feq = f(1:feq_cap);
        idx = idx+1;
    end
    
    spec_ent(i) = ent/idx;
end

end

