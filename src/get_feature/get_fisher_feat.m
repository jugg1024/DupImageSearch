function [db_feat,  q_feat] = get_fisher_feat(dataset)
%% install vlfeat
vl_setup
%% set path
database_path = [dataset '/image/database'];
query_path = [dataset '/image/query'];
feature_path = [dataset '/features/fisher'];
%% get sift descriptor
if  exist([feature_path  '/../sift/database_feat_sift.mat']) == 0
    database_feat_sift = [];    
    cato_names = dir(database_path);
    cato_names = cato_names([cato_names.isdir]);
    for cato_count = 3 : length(cato_names)
        cato = cato_names(cato_count).name;
        cato_path = [database_path  '/'  cato];
       %% find SIFT decriptors from database img        
        matName = [feature_path '/../sift/' cato '_feat_sift.mat'];
        if  exist(matName) == 0
            path_img = [cato_path '/*.jpg'];    
            imgFiles = dir(path_img);
            imgNamList = {imgFiles(~[imgFiles.isdir]).name};
            imgNamList = imgNamList';
            numImg = length(imgNamList);
            feat = [];
            for i = 1:numImg
                imgName = [cato_path '/' imgNamList{i, 1}];
                img = imread(imgName); 
                [m,n,~] = size(img);
                if m > n && m>600
                    img = imresize(img,[600 floor(n/m*600)]);
                elseif m < n && n>600
                    img = imresize(img,[floor(m/n*600) 600]);    
                end
                img = single(rgb2gray(img)) ;
                [~,d] = vl_sift(img) ;
                [~,cols] = size(d);
                feat = [feat,d];
                fprintf('%d SIFT descriptors extracted in image %s in file %s \n\n',cols, imgNamList{i, 1} , cato_path );
            end
            save(matName,'feat', '-v7.3');
        else
            load(matName);
        end
        database_feat_sift = [database_feat_sift,feat];
    end
    matName = [feature_path '/../sift/database_feat_sift.mat'];
    save(matName,'database_feat_sift', '-v7.3');
end
%% GMM find centers
if  exist([feature_path '/../sift/database_100centers_gmm_means_covariances_priors.mat']) == 0
    load([feature_path '/../sift/database_feat_sift.mat']);
    % feat_all = feat_all/max(feat_all(:));
    database_feat_sift = single(database_feat_sift);
    numClusters = 100;
    [means, covariances, priors] = vl_gmm(database_feat_sift, numClusters);
    % matName = strcat(dataset,'/feat_all_Reference_128centers_kmeans_centers.mat');
    matName = [feature_path '/../sift/database_100centers_gmm_means_covariances_priors.mat'] ;
    save(matName,'means', 'covariances', 'priors', '-v7.3'); 
    % [means, covariances, priors] = vl_gmm(feat_all, numClusters);
    % matName = strcat(dataset,'/feat_all_Reference_100centers_gmm_centers.mat');
    % save(matName,'means', 'covariances', 'priors', '-v7.3');
end

 %% encode with fisher
if  exist([feature_path  '/feat_fisher.mat']) == 0
    load([feature_path '/../sift/database_100centers_gmm_means_covariances_priors.mat']);   
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
            matName = [feature_path,'/' dir_ '_' cato '_feat_fisher.mat'];
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
                    [m,n,~] = size(img);
                    if m > n && m>600
                        img = imresize(img,[600 floor(n/m*600)]);
                    elseif m < n && n>600
                        img = imresize(img,[floor(m/n*600) 600]);    
                    end
                    img = single(rgb2gray(img)) ;
                    [f,d] = vl_sift(img) ;
                    [~,cols] = size(d);      
                    datatoBeEncoded = single(d);
                    encoding = vl_fisher(datatoBeEncoded, means, covariances, priors);
                    feat_norm = [ feat_norm ;encoding'];                   
                    fprintf('fisher vector feature extracted in %s \n\n',imgName);
                end
                save(matName,'feat_norm', '-v7.3');
            end
        end
    end
    mat_path = [feature_path '/*fisher.mat'];
    matnames = dir(mat_path);
    matnames = {matnames(~[matnames.isdir]).name};
    matnames = matnames';
    db_feat = [];
    q_feat = [];  
    for i = 1:length(matnames)
        if strcmp(matnames{i, 1},'feat_fisher.mat')
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
    matName = [feature_path  '/feat_fisher.mat'];
    save(matName,'q_feat', 'db_feat', '-v7.3');
end
