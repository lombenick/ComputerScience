function [Q,t]=try1
% mat = importdata('CA_HepPh.mat');
% mat = load('karate.txt');
mat = importdata('CA_CondMat.mat');

tic;

edge=length(mat); %边数
N=length(unique(cat(1,unique(mat(:,1)),unique(mat(:,2))))); %节点个数
adm=sparse(N,N);  %邻接矩阵
%adm=zeros(N,N); 
for i=1:edge
        adm(mat(i,2),mat(i,1))=1;  %将原图转化成为关系矩阵
        adm(mat(i,1),mat(i,2))=1;  
end

degree=zeros(N,1);    %统计各个节点的度数
for i=1:N
    degree(i,1)=sum(adm(i,:));
end

sampletime = 220;
depth = 20;
[m,r]=RW_pro(adm,degree,sampletime,depth,N);
[com ending]=cluster_jl_orientT(m,1,1,0,0);
[community,nodes]=expand_spr(adm,degree,com,r,N);
t=toc;
Q=modularity_metric(community,adm,edge);