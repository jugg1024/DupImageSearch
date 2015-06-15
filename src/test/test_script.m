clear all;close all;clc;
dataset = 'dataset';
cato_names = dir(dataset);
cato_names = cato_names([cato_names.isdir]);
mat_path = 'dataset/*vlad.mat';
matnames = dir(mat_path);
matnames = {matnames(~[matnames.isdir]).name};
matnames = matnames';
db_feat_norm = [];
q_feat_norm = [];
db_imgNamList = {};
q_imgNamList = {};
for i = 1:length(matnames)
    load(strcat(dataset,'/',matnames{i, 1}));
    if strcmp(matnames{i, 1},'feat_vlad.mat')
        ;
    elseif ~isempty(strfind(matnames{i, 1},'Reference'))
        [m,n] = size(feat_norm);
        feat_norm = reshape(feat_norm',m*n,1);
        feat_norm = reshape(feat_norm',m*n/12800,12800);
        db_feat_norm = [db_feat_norm;feat_norm];
        db_imgNamList = [db_imgNamList;imgNamList];
    else
        [m,n] = size(feat_norm);
        feat_norm = reshape(feat_norm',m*n,1);
        feat_norm = reshape(feat_norm',m*n/12800,12800);
        q_feat_norm = [q_feat_norm;feat_norm];
        q_imgNamList = [q_imgNamList;imgNamList];
    end    
end

P = zeros(3,1);
for top_num = 1:1
   P(top_num) = compute_p( top_num, db_feat_norm, db_imgNamList , q_feat_norm ,q_imgNamList);
end