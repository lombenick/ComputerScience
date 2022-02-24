%���Ĳ� ����
%finalCommunityLabel�洢ÿ���ڵ�ı�ǩ��1*totalNodeNum��
%Mlabels��ʾM��ı�ǩ
%totalNodesNum�����нڵ���Ŀ
%��ʾһ���������ٵĽڵ���Ŀ��ʵ��û������ѡ��ʱ�Ի�ѡ��ԭ���Ľ��ٽڵ�������

function finalCommunity = Ensemble(baseCls)
     % Get all clusters in the ensemble
     %baseCls��ÿһ�б�ʾһ��������
     %baseClsSegs ÿ�б�ʾһ�����еĶ��� 
     %bcsÿ�б�ʾһ����������ÿ������������ı�ţ����е�������˱�ţ�
     [bcs, baseClsSegs] = getAllSegs(baseCls);
     
    % baseClsSegs = baseClsSegs'; %ת��Ϊÿ��Ԫ��Ϊ1�Ķ��󹹳�һ����
     [nCls,N] = size(baseClsSegs);  %baseClsSegs ÿ�б�ʾһ�����еĶ���  %N ������������������nCls���л������е������
     M = size(bcs,2);
     
     JaccardDis = zeros(nCls, nCls);%����Jaccard����������֮��ľ��� ��һ���ȽϺ�ʱ
     for i = 1:nCls-1
         for j = i+1:nCls
             A = baseClsSegs([i,j],:);
             JaccardDis(i,j) = pdist(A,'jaccard');
             JaccardDis(j,i) = JaccardDis(i,j) ;
         end
     end

    JaccardSim = 1 - JaccardDis; %�ܿ������ƶ�
    
   %���´���Ϊ���������֮�����ƶȹ��ɵ���ͨ��֧����1������ֹͣ�����ִ��
    connected = DFS_Non_RC(JaccardSim); %�õ����е���ͨ��֧ connected{i}��ʾ��i����ͨ��֧
    if length(connected) ~= 1
        finalCommunity = 0;
        return;
    end
    
   % NodesLabel = zeros(1,nCls);       %��ʼ������Ԫ�����ı�ǩ
    g3 = min_span_tree(JaccardDis);
    g3 = g3 .* JaccardSim;
    
     % ����С������ɾȥһЩ�ߣ��õ�Ԫ����,�������NodesLabel��ʾÿ���ڵ��һ����ǩ
    NodesLabel = getFinalMetaCommunity(JaccardSim,g3);

    totalFinalCommunitiesNum = max(NodesLabel);     %�ܹ��Ļ�������ɵ�Ԫ��������
    nodesToFinalCommunities = zeros(N,totalFinalCommunitiesNum);    %��¼ÿ���ڵ�������Ԫ���������
    %�yӋ һ�����c���Ԫ��^�ĴΔ� �_����K����^����
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
    tmpC = cell(1,totalFinalCommunitiesNum);cur = 0;   %������ʱ���ÿ���ڵ������

    finalCommunity2 = zeros(totalNodeNum,1);                %������յ�����
    for i = 1:totalNodeNum
        [~,pos] = max(nodesToFinalCommunities(i,:));  %�ҵ��ڵ�i��������ȵ������������������Ǹ�����
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