function feat = getCorrFeat(data)

R = corrcoef(data);
e = eig(R);

R_fliplr = fliplr(R);
ur = triu(R_fliplr);
ur = ur - diag(diag(ur));
corr_coefs = ur(ur~=0);

feat = [e;corr_coefs]';
end

