% x = 0:5:20;
% x(1) = 1;
% map = zeros(1,5);
% map(1) = MAP(1);
% map(2:5) = MAP(5:5:20);
% plot(x,map,'b-s');
% title('RRi(N) evolution using(T8,Q2) for CNN layer6 '); % 标题
% xlabel('N best relevant images'); % x 轴标题
% ylabel('RRi(N)'); % y 轴标题
% legend('CNN layer6'); % 图例说明
% axis([1,20,0,1]); % 设定坐标范围
% set(gca,'XTick',0:5:20)
% set(gca,'XTickLabel',{'1','5','10','15','20'})

query_relevant = find(relevantID ~= 0);
query_relevantID = relevantID(query_relevant);
existID = zeros(length(query_relevantID),1);
count = 0;
for i = 1:length(query_relevantID)
    id = query_relevantID(i);
    if(find(existID==id))
    else
        count = count +1 ;
        existID(count) = id;
    end
end
T10_ID = db_img(:,2);
T10 = zeros(length(T10_ID),1);
for i =1 : length(T10_ID)
    T10(i) = str2num(char(T10_ID(i)));
end
ll = find(existID>0);
cc=0;
for i = 1:length(ll)
    if find(T10 == existID(i))
        cc = cc +1;
    end
end