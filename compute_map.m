function  [Precision_at_topnum_image,Precision_at_topnum_catogory]  = compute_map( top_num, q_feat ,query_truth ,db_feat, database_truth , distance_method )
% compute the mean average precision of different dataset
%
Precision_at_topnum_image = 0;
Precision_at_topnum_catogory = 0;
relevant_id = query_truth.relevant_id ;
[q_img_num,~] = size(relevant_id);
database_id_list = database_truth.database_id_list ; 
[db_img_num,~] = size(database_id_list);

% if top_num > 1 ;we need to sort
% top_num = 1; we just find max or min;
if top_num > 1
    for queryID = 1 : q_img_num
        current_relevant_id = relevant_id(queryID,:);
        current_query_feat = q_feat(queryID, :);
        if strcmp (distance_method , 'L2')
            current_query_feat = repmat(current_query_feat,db_img_num,1);
            score = sum((current_query_feat - db_feat).^2,2);
            [~, image_rank] = sort(score, 'ascend');
        elseif strcmp (distance_method , 'cos')
            score = current_query_feat * db_feat';
            [~, image_rank] = sort(score, 'descend');
        elseif strcmp (distance_method , 'hamming')
            ;% to be extend;            
        end
        for i = 1 : top_num
            result_id = database_id_list(image_rank(i));   
            if( find(current_relevant_id == result_id) )
                Precision_at_topnum_image = Precision_at_topnum_image + 1; 
                break;
            end  
%             if(strcmp(result_cato,query_cato))
%                 Precision_at_topnum_catogory = Precision_at_topnum_catogory + 1; 
%                 break;
%             end    
        end
    end
elseif top_num == 1
%     query_cato = q_img(:,3);    
    if strcmp (distance_method , 'L2')
        for queryID = 1 : q_img_num
            current_query_feat = q_feat(queryID, :);
            current_query_feat = repmat(current_query_feat,db_img_num,1);
            score = sum((current_query_feat - db_feat).^2,2);
            [~, first(queryID)] = sort(score, 'ascend');
        end
    elseif strcmp (distance_method , 'cos')
        score = q_feat * db_feat';
        [~, first] = max(score,[],2);
    elseif strcmp (distance_method , 'hamming')
        Dhamm = hammingDist(q_feat, db_feat);
        [~, first] = min(Dhamm,[],2);
    end
    result_id = database_id_list(first);   
    if size(relevant_id,2) == 1
        Precision_at_topnum_image = sum(relevant_id == result_id);
    else
        for queryID = 1 : q_img_num
            if( find(relevant_id(queryID,:) == result_id(queryID) ) )
                Precision_at_topnum_image = Precision_at_topnum_image + 1; 
            end  
        end
    end
end
Precision_at_topnum_image=Precision_at_topnum_image/ q_img_num;
end
