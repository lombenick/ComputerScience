% 集成
function finalCommunity = ensembleAlgorithm(baseCls)
    [~, baseClsSegs] = getAllSegs(baseCls);
    [nCls,totalNodeNum] = size(baseClsSegs);
    JaccardDis = pdist2(baseClsSegs,baseClsSegs,'jaccard');
    % 把集成图切成最小生成树，并生成最终的元社区,NodesLabel记录所有节点的标签
     JaccardSim = 1 - JaccardDis;
%     %将对角元素置为0，非零元素置为1 然后在该矩阵上进行元社区的发现
%     A = JaccardSim;
%     A(logical(eye(size(A)))) = 0;
%     A = A&1;
%     NodesLabel = LM(A); %初始化所有节点的标签
%    NodesLabel = LM(JaccardSim);
     [~,NodesLabel,~] = labelPtr(JaccardSim);
    totalFinalCommunitiesNum = max(NodesLabel);     %总共的节点个数
    nodesToFinalCommunities = zeros(totalNodeNum,totalFinalCommunitiesNum);    %记录每个节点隶属于元社区的情况
    for i = 1:totalFinalCommunitiesNum
        commuityid = find(NodesLabel == i);
        nodesum = sum(baseClsSegs(commuityid,:),1);
        nodesToFinalCommunities(:,i) = nodesum';
    end
    [~,finalCommunity] = max(nodesToFinalCommunities,[],2);
end