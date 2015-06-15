function  [query_truth,database_truth] = get_truth_from_dataset(varargin)
%  get truth from the xml or by certain rules
%  varargin{1} £º dataset name
%  varargin{2} - varargin{?}£º to be extended
if length(varargin) > 1
    error('too much inputs for get_truth_from_dataset.m');
end
dataset = varargin{1};
switch dataset
    case 'dataset/MobileVisualSearchDataset'
        truth_mat = [dataset '/truth/' 'MobileVisualSearchDataset.mat'];
    case 'dataset/FribourgProductImageDataset'
        truth_mat = [dataset '/truth/' 'FribourgProductImageDataset.mat'];
    otherwise
        error('unrecongnized dataset!');
end
if  exist(truth_mat) == 0
    switch dataset
    case 'dataset/MobileVisualSearchDataset'
        % get query relevance :
        % in MobileVisualSearchDataset, the relevance query_img and
        % database_img have the same catogary and same img_name;
        % set the image id by : catogory_id * 1000 + image_name_id;
        root = [dataset '/image/query'];
        cato_names = dir(root);
        cato_names = cato_names([cato_names.isdir]);
        relevant_id = [];
        query_imgNamList = {};
        for cato_count = 3 : length(cato_names)
            cato = cato_names(cato_count).name;
            switch cato
                case 'book_covers'
                   cato_id = 1;
                case 'business_cards'
                   cato_id = 2;
                case 'cd_covers'
                   cato_id = 3;
                case 'dvd_covers'
                   cato_id = 4;   
                case 'landmarks'
                   cato_id = 5;
                case 'museum_paintings'
                   cato_id = 6;
                case 'print'
                   cato_id = 7;
                case 'video_frames'
                   cato_id = 8;
            end
            path_img = [root  '/' cato '/' '*.jpg'];     
            imgFiles = dir(path_img);
            q_imgNamList = {imgFiles(~[imgFiles.isdir]).name};
            q_imgNamList = q_imgNamList';
            numImg = length(q_imgNamList);
            relevant_id_ = zeros(numImg,1);
            for i = 1:numImg
                sp = strsplit(q_imgNamList{i},{'.'});
                q_imgNamList{i} = [root  '/' cato '/' q_imgNamList{i}];
                image_name_id = str2num(char(sp(1)));
                relevant_id_(i) = cato_id*1000 + image_name_id;
            end
            relevant_id = [relevant_id; relevant_id_] ;
            query_imgNamList = [query_imgNamList; q_imgNamList];
        end
        query_truth.relevant_id = relevant_id;
        query_truth.query_imgNamList = query_imgNamList;
        % get db id:
        % database_id_list is the same order(which the img is searched) as
        % the feature_list
        root = [dataset '/image/database'];
        cato_names = dir(root);
        cato_names = cato_names([cato_names.isdir]);
        database_id_list = [];
        database_imgNamList = {};
        for cato_count = 3 : length(cato_names)
            cato = cato_names(cato_count).name;
            switch cato
                case 'book_covers'
                   cato_id = 1;
                case 'business_cards'
                   cato_id = 2;
                case 'cd_covers'
                   cato_id = 3;
                case 'dvd_covers'
                   cato_id = 4;   
                case 'landmarks'
                   cato_id = 5;
                case 'museum_paintings'
                   cato_id = 6;
                case 'print'
                   cato_id = 7;
                case 'video_frames'
                   cato_id = 8;
            end
            path_img = [root  '/' cato '/' '*.jpg'];     
            imgFiles = dir(path_img);
            db_imgNamList = {imgFiles(~[imgFiles.isdir]).name};
            db_imgNamList = db_imgNamList';
            numImg = length(db_imgNamList);
            database_id_list_ = zeros(numImg,1);
            for i = 1:numImg
                sp = strsplit(db_imgNamList{i},{'.'});
                db_imgNamList{i} = [root  '/' cato '/' db_imgNamList{i}];
                image_name_id = str2num(char(sp(1)));    
                database_id_list_(i) = cato_id*1000 + image_name_id;
            end
            database_id_list = [database_id_list; database_id_list_] ;
            database_imgNamList = [database_imgNamList;db_imgNamList];
        end
        database_truth.database_id_list = database_id_list;
        database_truth.database_imgNamList = database_imgNamList;
        database_truth.have_catogary = true;
        
    case 'dataset/FribourgProductImageDataset'
        % get query relevance :
        % in FribourgProductImageDataset, the query_img's relevance img is
        % in the xml files with the tag <relevance/><relevance>
        querydir = 'Q_2_crop+rotate_byhand';        
        xml_path = [dataset '/image/query/' querydir  '/*.xml'];
        xmlFiles = dir(xml_path);
        xmlNamList = {xmlFiles(~[xmlFiles.isdir]).name};
        xmlNamList = xmlNamList';    
        numXml = length(xmlNamList);
        relevant_id = zeros(numXml,33);  % max number of relevance img is 33
        for i = 1:numXml
           xmlNamList{i} = [dataset '/image/query/' querydir  '/' xmlNamList{i}];
           xmlDoc = xmlread(xmlNamList{i});
           IDArray = xmlDoc.getElementsByTagName('id');
           for j = 1 : IDArray.getLength-2    
               relevant_id(i,j) = str2num(char(IDArray.item(j+1).getFirstChild.getData));   
           end  
        end
        query_truth.relevant_id = relevant_id;
        img_path = [dataset '/image/query/' querydir  '/*.jpg'];
        imgFiles = dir(img_path);
        query_imgNamList = {imgFiles(~[imgFiles.isdir]).name};
        query_imgNamList = query_imgNamList';   
        numImg = length(query_imgNamList);
        for i = 1:numImg
           query_imgNamList{i} = [dataset '/image/query/' querydir '/' query_imgNamList{i}];
        end
        query_truth.query_imgNamList = query_imgNamList;
        % get db id:
        % database_id_list is the same order(which the img is searched) as
        % the feature_list
        databasedir = 'T_8_crop+rotate_byhand';
        database_path = [dataset '/image/database/' databasedir  '/*.xml'];
        xmlFiles = dir(database_path);
        db_xmlNamList = {xmlFiles(~[xmlFiles.isdir]).name};
        db_xmlNamList = db_xmlNamList';
        numXml = length(db_xmlNamList);
        database_id_list = zeros(numXml,1);
        for i = 1:numXml
           sp = strsplit(db_xmlNamList{i},{'e' ,'.'});
           database_id_list(i) = str2num(char(sp(2)));
        end
        database_truth.database_id_list = database_id_list;
        img_path = [dataset '/image/database/' databasedir  '/*.jpg'];
        imgFiles = dir(img_path);
        database_imgNamList = {imgFiles(~[imgFiles.isdir]).name};
        database_imgNamList = database_imgNamList';   
        numImg = length(database_imgNamList);
        for i = 1:numImg
           database_imgNamList{i} = [dataset '/image/database/' databasedir '/' database_imgNamList{i}];
        end
        database_truth.database_imgNamList = database_imgNamList;
        database_truth.have_catogary = false;
    end
    save( truth_mat ,'query_truth' ,'database_truth' ,'-v7.3')  ;
else
    load(truth_mat);
end

