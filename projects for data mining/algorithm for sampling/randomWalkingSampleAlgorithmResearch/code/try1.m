function [Q,t]=try1
% mat = importdata('CA_HepPh.mat');
% mat = load('karate.txt');
mat = importdata('CA_CondMat.mat');

tic;

edge=length(mat); %����
N=length(unique(cat(1,unique(mat(:,1)),unique(mat(:,2))))); %�ڵ����
adm=sparse(N,N);  %�ڽӾ���
%adm=zeros(N,N); 
for i=1:edge
        adm(mat(i,2),mat(i,1))=1;  %��ԭͼת����Ϊ��ϵ����
        adm(mat(i,1),mat(i,2))=1;  
end

degree=zeros(N,1);    %ͳ�Ƹ����ڵ�Ķ���
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