mat = importdata('CA_HepPh.mat');
% mat = load('karate.txt');



edge=length(mat); %边数
N=length(unique(cat(1,unique(mat(:,1)),unique(mat(:,2))))); %节点个数
adm=sparse(N,N);  %邻接矩阵
%adm=zeros(N,N); 
for i=1:edge
        adm(mat(i,2),mat(i,1))=1;  %将原图转化成为关系矩阵
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