%jaccard函数的实现
%set1,set2表示集合，向量形式给出
function weight = jaccard(set1,set2)
%     if length(set1) == length(set2)
%         weight = 1 - pdist([set1;set2],'jaccard');
%     elseif length(set1) > length(set2)
%         set3 = zeros(1,length(set1));
%         set3(1:length(set2)) = set2;
%         weight = 1 - pdist([set1;set3],'jaccard');
%     else
%         set3 = zeros(1,length(set2));
%         set3(1:length(set1)) = set1;
%         weight = 1 - pdist([set2;set3],'jaccard');
%     end
% end

common = 0;
set1NodeNum = length(set1);
set2NodeNum = length(set2);
for i = 1:set1NodeNum
    for j = 1:set2NodeNum
        if set1(i) == set2(j)
            common = common + 1;
        end
    end
end
totalNodeNum = set1NodeNum + set2NodeNum - common;
weight = common / totalNodeNum;
end