% mat=load('CA-HepPh.txt');
% adj=trans(mat);
function[Q,t]=try1
mat = importdata('CA_HepPh.mat');
tic;
edge=length(mat); %����
N=length(unique(cat(1,unique(mat(:,1)),unique(mat(:,2))))); %�ڵ����
adm1=sparse(N,N);  %�ڽӾ���
%adm=zeros(N,N); 
for i=1:edge
        adm1(mat(i,2),mat(i,1))=1;  %��ԭͼת����Ϊ��ϵ����
        adm1(mat(i,1),mat(i,2))=1;  
end
degree=zeros(N,2);  %ͳ�Ƹ����ڵ�Ķ�
for i=1:N
    degree(i,1)=sum(adm1(i,:));
    degree(i,2)=i;
end

[n,r,m]=CBCD_core(mat,N,edge,adm1,degree,20);
[com ending]=cluster_jl_orientT(m,1,1,0,0);
[community]=CBCD1_expand1(N,adm1,com,n,m,degree,r);
t=toc;
Q=modularity_metric(community,adm1,edge);