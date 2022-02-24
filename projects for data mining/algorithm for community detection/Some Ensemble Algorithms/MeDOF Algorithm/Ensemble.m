%第四步 集成
%finalCommunityLabel存储每个节点的标签（1*totalNodeNum）
%Mlabels表示M层的标签
%totalNodesNum是所有节点数目
%表示一个社区最少的节点数目（实在没有其他选择时仍会选择原来的较少节点社区）

function finalCommunity = Ensemble(baseCls)
     % Get all clusters in the ensemble
     %baseCls的每一列表示一个基聚类
     %baseClsSegs 每行表示一个类中的对象 
     %bcs每列表示一个基聚类中每个对象所属类的编号（所有的类进行了编号）
     [bcs, baseClsSegs] = getAllSegs(baseCls);
     
    % baseClsSegs = baseClsSegs'; %转换为每列元素为1的对象构成一个类
     [nCls,N] = size(baseClsSegs);  %baseClsSegs 每行表示一个类中的对象  %N 对象数（顶点数）；nCls所有基聚类中的类个数
     M = size(bcs,2);
     
     JaccardDis = zeros(nCls, nCls);%基于Jaccard计算两个类之间的距离 这一步比较耗时
     for i = 1:nCls-1
         for j = i+1:nCls
             A = baseClsSegs([i,j],:);
             JaccardDis(i,j) = pdist(A,'jaccard');
             JaccardDis(j,i) = JaccardDis(i,j) ;
         end
     end

    JaccardSim = 1 - JaccardDis; %杰卡德相似度
    
   %以下代码为如果类与类之间相似度够成的联通分支多余1个，则停止后面的执行
    connected = DFS_Non_RC(JaccardSim); %得到所有的联通分支 connected{i}表示第i個联通分支
    if length(connected) ~= 1
        finalCommunity = 0;
        return;
    end
    
   % NodesLabel = zeros(1,nCls);       %初始化所有元社区的标签
    g3 = min_span_tree(JaccardDis);
    g3 = g3 .* JaccardSim;
    
     % 将最小生成树删去一些边，得到元社区,输出参数NodesLabel表示每个节点的一个标签
    NodesLabel = getFinalMetaCommunity(JaccardSim,g3);

    totalFinalCommunitiesNum = max(NodesLabel);     %总共的基社区组成的元社区个数
    nodesToFinalCommunities = zeros(N,totalFinalCommunitiesNum);    %记录每个节点隶属于元社区的情况
    %統計 一個節點屬於元社區的次數 確定最終的社區劃分
    for i=1:totalFinalCommunitiesNum
        commuityid = find(NodeLabel ==i);
        nodesum = sum(baseClsSegs(commuityid,:),1);
        nodesToFinalCommunities(:,i) = nodesum';
    end
    finalCommunity = max(nodesToFinalCommunities,[],2);
    
    
    for i = 1:totalFinalCommunitiesNum
       coms = find(NodesLabel == i); 
       for j = 1:length(coms)
          nodes = find(baseClsSegs(coms(j),:)==1); 
          for k = 1:length(nodes)
              nodesToFinalCommunities(nodes(k),i) = nodesToFinalCommunities(nodes(k),i) + 1;
          end
       end
    end
    tmpC = cell(1,totalFinalCommunitiesNum);cur = 0;   %用于暂时存放每个节点的社区

    finalCommunity2 = zeros(totalNodeNum,1);                %存放最终的社区
    for i = 1:totalNodeNum
        [~,pos] = max(nodesToFinalCommunities(i,:));  %找到节点i最大隶属度的社区，并把它加入那个社区
        tmpC{pos} = [tmpC{pos} i];
    end
    
    for i = 1:totalFinalCommunitiesNum
        if ~isempty(tmpC{i})
            nodes = tmpC{i};
            cur = cur + 1;
            finalCommunity2(nodes) = cur;
        end
    end
end