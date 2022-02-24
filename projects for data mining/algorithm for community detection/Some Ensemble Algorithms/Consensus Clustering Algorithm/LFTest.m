function LFTest(dataname,adj,adjclass)
%Consensus clustering in complex networks算法
%基算法采用LM算法  参数tao=0.3
if nargin<3
        adjclass = 0;
end

T = 10;  %算法重复次数
M = 20;  %基聚类个数  论文中参数np
tao = 0.3;
TotalQ = [];
TotalNMI = [];
TotalTimes =[];
for i = 1:T
    [finalCommunityLabel,times] = ConClu(adj,M,tao);
     TotalTimes = cat(1,TotalTimes,times);
     
    Q = modularity_metric(finalCommunityLabel,adj);%模块度
    TotalQ = cat(1,TotalQ,Q);
    
    NMI = 0;
    if adjclass ~=0
        A = finalCommunityLabel';
        B = adjclass';
        NMI = nmi(A,B) %互信息
    end
    TotalNMI = cat(1,TotalNMI,NMI);
end
MeanQ= sum(TotalQ) / T;
MeanNMI= sum(TotalNMI) / T;
MeanTimes= sum(TotalTimes) / T;
file_name = ['LF_',dataname, '_Ensemble_Result.mat'];
save(file_name,'TotalQ', 'TotalNMI','TotalTimes','MeanQ', 'MeanNMI','MeanTimes');
end

