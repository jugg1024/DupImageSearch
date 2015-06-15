clear all; close all; clc;

% [db_feat_norm, db_imgNamList , q_feat_norm ,q_imgNamList] = get_feat_from_dataset('vlad');



mat_path = 'dataset/*vlad.mat';
matnames = dir(mat_path);
matnames = {matnames(~[matnames.isdir]).name};
matnames = matnames';
q_feat_norm = [];
q_imgNamList = {};
db_feat_norm = [];
db_imgNamList = {};
for i = 1:length(matnames)   
    if ~isempty(strfind(matnames{i, 1},'cd_')) && isempty(strfind(matnames{i, 1},'Reference'))
        load(strcat('dataset','/',matnames{i, 1}));
        q_feat_norm = [q_feat_norm;feat_norm];
        q_imgNamList = [q_imgNamList;imgNamList];
    end    
    if ~isempty(strfind(matnames{i, 1},'cd_')) && ~isempty(strfind(matnames{i, 1},'Reference'))
        load(strcat('dataset','/',matnames{i, 1}));
        db_feat_norm = [db_feat_norm;feat_norm];
        db_imgNamList = [db_imgNamList;imgNamList];
    end   
end

% 
% P = zeros(5,1);
% for top_num = 1:1
%    P(top_num) = compute_p( top_num, db_feat_norm, db_imgNamList , q_feat_norm ,q_imgNamList);
% end

%virsulazation
numRetrieval = 20;
for queryID = 1:length(q_imgNamList)
    retrieval_virsulazation( queryID ,numRetrieval, db_feat_norm, db_imgNamList , q_feat_norm ,q_imgNamList);
end