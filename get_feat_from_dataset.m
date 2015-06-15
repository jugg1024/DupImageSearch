function  [q_feat,db_feat] = get_feat_from_dataset( varargin )
%  从数据集中提取图像的特征
%  varargin{1} ： dataset name
%  varargin{2} ： feature type
%  varargin{3}(可选) ： normalization method
if length(varargin) < 2
    error('not enough inputs for get_feat_from_dataset.m');
end
dataset = varargin{1};
feature_type = varargin{2};
switch feature_type
    case 'vlad'
        fhandle = @get_vlad_feat;
    case 'fisher'
        fhandle = @get_fisher_feat;
    case 'CH'
        fhandle = @get_CH_feat;
    case 'CM'
        fhandle = @get_CM_feat;    
    case 'cnn_fc7'
        fhandle = @get_cnn_fc7_feat;    
    otherwise
        error('unrecongnized feature type');
end
feature_mat = [dataset '/features/' feature_type '/feat_' feature_type '.mat'];
if  exist(feature_mat) == 0
    [db_feat,  q_feat] = feval(fhandle,dataset);
else
    load(feature_mat);
end


