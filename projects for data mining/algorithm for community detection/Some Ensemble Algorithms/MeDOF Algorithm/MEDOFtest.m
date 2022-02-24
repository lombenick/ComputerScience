function MEDOFtest(dataname,adj,adjclass)
% 读取邻接矩阵
if size(adj,1) <= 1e4   % 若矩阵规模小，则不选择稀疏矩阵
    adj = full(adj);
end
T = 10;  %算法重复次数
TotalQ = [];
TotalNMI = [];
TotalTimes =[];
for i = 1:T
    [finalCommunityLabel,times] = MeDOF(adj); %仅仅统计集成部分的耗时  finalCommunityLabel表示为N*1的形式
     [finalCommunityLabel] = LabelNorm(finalCommunityLabel);
    TotalTimes = cat(1,TotalTimes,times);
    
    Q = modularity_metric(finalCommunityLabel,adj);
    TotalQ = cat(1,TotalQ,Q);
    
    NMI = 0;
    if exist('adjclass')
        NMI = nmi(finalCommunityLabel',adjclass');%互信息
    end
    TotalNMI = cat(1,TotalNMI,NMI);
end
MeanQ = sum(TotalQ)/ T;
MeanNMI = sum(TotalNMI)/ T;
MeanTimes= sum(TotalTimes) / T;
file_name = ['MeDOF_',dataname, '_Ensemble_Result.mat'];
save(file_name,'TotalQ', 'TotalNMI','TotalTimes','MeanQ', 'MeanNMI','MeanTimes');
end