mat = importdata('CA_HepPh.mat');
% mat = load('karate.txt');



edge=length(mat); %����
N=length(unique(cat(1,unique(mat(:,1)),unique(mat(:,2))))); %�ڵ����
adm=sparse(N,N);  %�ڽӾ���
%adm=zeros(N,N); 
for i=1:edge
        adm(mat(i,2),mat(i,1))=1;  %��ԭͼת����Ϊ��ϵ����
        adm(mat(i,1),mat(i,2))=1;  
end



% mat=load('CA-HepPh.txt');
% adj=trans(mat);
tic;
%m=origin(adj);
[com ending]=cluster_jl_orientT(adm,1,0,0,0);
community=Tran_o(mat,com);
toc;
% Q=modularity(adj,n)
Q=modularity_metric(community,adm,edge)