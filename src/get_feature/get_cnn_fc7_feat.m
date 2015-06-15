function [db_feat,  q_feat]  = get_cnn_fc7_feat(dataset)
%% install vlfeat
vl_setupnn
net = load('matconvnet-master/imagenet-vgg-f.mat') ;
%% set path
database_path = [dataset '/image/database'];
query_path = [dataset '/image/query'];
feature_path = [dataset '/features/cnn_fc7'];
%% encode with cnn fc7 layer
if  exist([feature_path  '/feat_cnn_fc7.mat']) == 0
    root = [dataset '/image'];
    dir_names = dir(root);
    dir_names = dir_names([dir_names.isdir]);
    for dir_count = 3 : length(dir_names)
        dir_ = dir_names(dir_count).name;
        dir_path = [root,'/',dir_];  
        cato_names = dir(dir_path);
        cato_names = cato_names([cato_names.isdir]);
        for cato_count = 3 : length(cato_names)
            cato = cato_names(cato_count).name;
            matName = [feature_path,'/' dir_ '_' cato '_feat_cnn_fc7.mat'];
            if  exist(matName) == 0
                cato_path = [dir_path,'/',cato];  
                path_img = [cato_path '/' '*.jpg'];    
                imgFiles = dir(path_img);
                imgNamList = {imgFiles(~[imgFiles.isdir]).name};
                imgNamList = imgNamList';
                numImg = length(imgNamList);
                feat_norm = [];
                for i = 1:numImg
                    imgName = [cato_path  '/' imgNamList{i, 1}];
                    img = imread(imgName); 
                    img = single(img) ;
                    img = imresize(img, net.normalization.imageSize(1:2)) ;
                    img = img - net.normalization.averageImage ;
                    res = vl_simplenn(net, img) ;
                    encoding = res(20).x;
                    encoding = encoding(:);
                    encoding = encoding./sqrt((sum(encoding.^2)));
                    feat_norm = [feat_norm; encoding'];
                    fprintf('cnn fc7 feature extracted in %s \n\n', imgName);
                end
                save(matName,'feat_norm', '-v7.3');
            end
        end
    end
    mat_path = [feature_path '/*cnn_fc7.mat'];
    matnames = dir(mat_path);
    matnames = {matnames(~[matnames.isdir]).name};
    matnames = matnames';
    db_feat = [];
    q_feat = [];  
    for i = 1:length(matnames)
        if strcmp(matnames{i, 1},'feat_cnn_fc7.mat')
            ;
        else
            load([feature_path '/' matnames{i, 1}]);
            if ~isempty(strfind(matnames{i, 1},'database'))
                db_feat = [db_feat;feat_norm];
            else
                q_feat = [q_feat;feat_norm];
            end    
        end    
    end
    matName = [feature_path  '/feat_cnn_fc7.mat'];
    save(matName,'q_feat', 'db_feat', '-v7.3');
end