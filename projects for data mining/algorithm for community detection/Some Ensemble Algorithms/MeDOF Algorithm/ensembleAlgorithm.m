% ����
function finalCommunity = ensembleAlgorithm(baseCls)
    [~, baseClsSegs] = getAllSegs(baseCls);
    [nCls,totalNodeNum] = size(baseClsSegs);
    JaccardDis = pdist2(baseClsSegs,baseClsSegs,'jaccard');
    % �Ѽ���ͼ�г���С�����������������յ�Ԫ����,NodesLabel��¼���нڵ�ı�ǩ
     JaccardSim = 1 - JaccardDis;
%     %���Խ�Ԫ����Ϊ0������Ԫ����Ϊ1 Ȼ���ڸþ����Ͻ���Ԫ�����ķ���
%     A = JaccardSim;
%     A(logical(eye(size(A)))) = 0;
%     A = A&1;
%     NodesLabel = LM(A); %��ʼ�����нڵ�ı�ǩ
%    NodesLabel = LM(JaccardSim);
     [~,NodesLabel,~] = labelPtr(JaccardSim);
    totalFinalCommunitiesNum = max(NodesLabel);     %�ܹ��Ľڵ����
    nodesToFinalCommunities = zeros(totalNodeNum,totalFinalCommunitiesNum);    %��¼ÿ���ڵ�������Ԫ���������
    for i = 1:totalFinalCommunitiesNum
        commuityid = find(NodesLabel == i);
        nodesum = sum(baseClsSegs(commuityid,:),1);
        nodesToFinalCommunities(:,i) = nodesum';
    end
    [~,finalCommunity] = max(nodesToFinalCommunities,[],2);
end