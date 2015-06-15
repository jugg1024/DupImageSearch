function  retrieval_virsulazation(query_id, numRetrieval , q_feat ,query_truth ,db_feat, database_truth , distance_method )
% virsulazation

current_query_path = query_truth.query_imgNamList{query_id};
query_relevant_id = query_truth.relevant_id(query_id, :);
current_query_img = imread(current_query_path);
current_query_img = imresize(current_query_img, [200 200]);
current_query_feat = q_feat(query_id, :);
if strcmp (distance_method , 'L2')
    db_img_num = size(db_feat,2);
    current_query_feat = repmat(current_query_feat,db_img_num,1);
    score = sum((current_query_feat - db_feat).^2,2);
    [~, image_rank] = sort(score, 'ascend');
elseif strcmp (distance_method , 'cos')
    score = current_query_feat * db_feat';
    [~, image_rank] = sort(score, 'descend');
elseif strcmp (distance_method , 'hamming')
    ;% to be extend;            
end
I2 = uint8(zeros(100, 100, 3, numRetrieval)); % 32 and 32 are the size of the output image
for i=1:numRetrieval
    result_path = database_truth.database_imgNamList{image_rank(i)};
    result_id = database_truth.database_id_list(image_rank(i));
    im = imread(result_path); 
    im = imresize(im, [100 100]);
    if( find(query_relevant_id ==  result_id) )
        im(:,1:5,1)=255;  im(:,1:5,2:3)=0;
        im(:,end-4:end,1)=255; im(:,end-4:end,2:3)=0;
        im(1:5,:,1)=255; im(1:5,:,2:3)=0;
        im(end-4:end,:,1)=255;  im(end-4:end,:,2:3)=0;  
    end    
    I2(:, :, :,i) = im;
end
figure(1);
montage(I2(:, :, :, (1:numRetrieval)));
title('search result');
figure(2)
imshow(current_query_img);
title('query image');
end
