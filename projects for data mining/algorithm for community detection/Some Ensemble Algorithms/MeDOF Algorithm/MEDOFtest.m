function MEDOFtest(dataname,adj,adjclass)
% ��ȡ�ڽӾ���
if size(adj,1) <= 1e4   % �������ģС����ѡ��ϡ�����
    adj = full(adj);
end
T = 10;  %�㷨�ظ�����
TotalQ = [];
TotalNMI = [];
TotalTimes =[];
for i = 1:T
    [finalCommunityLabel,times] = MeDOF(adj); %����ͳ�Ƽ��ɲ��ֵĺ�ʱ  finalCommunityLabel��ʾΪN*1����ʽ
     [finalCommunityLabel] = LabelNorm(finalCommunityLabel);
    TotalTimes = cat(1,TotalTimes,times);
    
    Q = modularity_metric(finalCommunityLabel,adj);
    TotalQ = cat(1,TotalQ,Q);
    
    NMI = 0;
    if exist('adjclass')
        NMI = nmi(finalCommunityLabel',adjclass');%����Ϣ
    end
    TotalNMI = cat(1,TotalNMI,NMI);
end
MeanQ = sum(TotalQ)/ T;
MeanNMI = sum(TotalNMI)/ T;
MeanTimes= sum(TotalTimes) / T;
file_name = ['MeDOF_',dataname, '_Ensemble_Result.mat'];
save(file_name,'TotalQ', 'TotalNMI','TotalTimes','MeanQ', 'MeanNMI','MeanTimes');
end