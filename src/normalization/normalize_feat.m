function feat_norm = normalize_feat(feat , method ,varargin)
if strcmp (method , 'powerlaw')
    for i = 1:size(feat,1)
        alpha = varargin{1};
        feat_norm(i,:) = abs(feat(i,:)).^alpha .* sign(feat(i,:));
    %     db_feat_norm(i,:) = sign(db_feat_norm(i,:));
%         feat_norm(i,:) = feat_norm(i,:)./sqrt((sum(feat_norm(i,:).^2)));  
    end
elseif strcmp (method , 'unnormalize')
    feat_norm = feat;
end