%% 
dataset = 'dataset';
feature_name = 'CH';
cato_names = dir(dataset);
cato_names = cato_names([cato_names.isdir]);

%% encode with cnn CH
for cato_count = 3 : length(cato_names)
    cato = cato_names(cato_count).name;
    cato_path = strcat(dataset,'/',cato);
    dirnames = dir(cato_path);
    dirnames = dirnames([dirnames.isdir]);
    for dirc = 3:length(dirnames)
        filename = dirnames(dirc).name;      
        matName = strcat(dataset,'/',feature_name,'/',cato,'_',filename,'_feat_CH.mat');
        if  exist(matName) == 0
            root = strcat(dataset,'/',cato,'/',filename,'/');
            path_img = strcat(root,'*.jpg');    
            imgFiles = dir(path_img);
            imgNamList = {imgFiles(~[imgFiles.isdir]).name};
            imgNamList = imgNamList';
            numImg = length(imgNamList);
            feat_norm = [];
            for i = 1:numImg
                imgNamList{i, 2} = imgNamList{i, 1};
                imgNamList{i, 3} = cato;
                imgNamList{i, 1} = strcat(root,imgNamList{i, 1});
                im_ = imread(imgNamList{i, 1}); 
                im_ = single(im_) ; % note: 255 range
                [m,n,~] = size(im_);
                if m > n && m>600
                    im_ = imresize(im_,[600 floor(n/m*600)]);
                elseif m < n && n>600
                    im_ = imresize(im_,[floor(m/n*600) 600]);    
                end
                encoding = colorhist(im_);
                encoding = encoding./sqrt((sum(encoding.^2)));
                feat_norm = [feat_norm; encoding];
                fprintf('extract image %s in file %s \n\n', imgNamList{i, 2},root);
            end
            save(matName,'feat_norm','imgNamList', '-v7.3');
        end
    end
end

mat_path = 'dataset/CH/*CH.mat';
matnames = dir(mat_path);
matnames = {matnames(~[matnames.isdir]).name};
matnames = matnames';
db_feat_norm = [];
q_feat_norm = [];
db_imgNamList = {};
q_imgNamList = {};
for i = 1:length(matnames)
    if strcmp(matnames{i, 1},'feat_CH.mat')
        ;
    else
        if ~isempty(strfind(matnames{i, 1},'Reference'))
            db_feat_norm = [db_feat_norm;feat_norm];
            db_imgNamList = [db_imgNamList;imgNamList];
        else
            q_feat_norm = [q_feat_norm;feat_norm];
            q_imgNamList = [q_imgNamList;imgNamList];
        end    
    end    
end
matName = strcat(dataset,'/',feature_name,'/','feat_CH.mat');
save(matName,'q_feat_norm', 'db_feat_norm','q_imgNamList','db_imgNamList', '-v7.3');