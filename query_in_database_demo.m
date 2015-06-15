% by Li gen
% special thanks to willard-yuan : https://github.com/willard-yuan/CNN-for-Image-Retrieval
clear all; close all; clc;
%% get feature for dataset (both Query image and Database image)
dataset = 'dataset/FribourgProductImageDataset';
feature = 'cnn_fc7';
% dataset = 'dataset/MobileVisualSearchDataset';
% feature = 'vlad';
[query_truth , database_truth] = get_truth_from_dataset(dataset);
[q_feat , db_feat] = get_feat_from_dataset(dataset,feature);
%% normorlize
% q_feat = normalize_feat(q_feat , 'powerlaw',0);
% db_feat = normalize_feat(db_feat , 'powerlaw',0);
q_feat = normalize_feat(q_feat , 'unnormalize');
db_feat = normalize_feat(db_feat , 'unnormalize');
%% compress
% PCAHparam.nbits = 64;
% PCAHparam = trainPCAH(double(db_feat_norm), PCAHparam);
% [db_feat_norm, ~] = compressPCAH(db_feat_norm, PCAHparam);
% [q_feat_norm, ~] = compressPCAH(q_feat_norm, PCAHparam);
% ITQ
% ITQparam.nbits = 32;
% ITQparam =  trainPCAH(double(db_feat_norm), ITQparam);
% %ITQparam =  trainPCAH(train_data, ITQparam);
% ITQparam = trainITQ(db_feat_norm, ITQparam);
% [db_feat_norm, ~] = compressITQ(db_feat_norm, ITQparam);
% [q_feat_norm, ~] = compressITQ(q_feat_norm, ITQparam);

%% measure
Pimage = zeros(3,1);
Pcato = zeros(3,1);
distance_method = 'cos';
for top_num = 1:2
   [Pimage(top_num),Pcato(top_num)] = compute_map( top_num, q_feat ,query_truth ,db_feat, database_truth , distance_method );
end

%% virsulazation
numRetrieval = 20;
for query_id = 1:length(q_feat)
    retrieval_virsulazation(query_id, numRetrieval , q_feat ,query_truth ,db_feat, database_truth , distance_method );
end
