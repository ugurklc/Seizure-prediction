function E = entropy_bin(x,width)

bins = min(x):width:max(x);
bins = bins(1:end-1);

bin_width = diff(bins);

[p,~] = histcounts(x,bins,'normalization','probability');

bin_width = bin_width(p>0);
p = p(p>0);

E = -sum(p.*( log2(p) - log2(bin_width)));
end