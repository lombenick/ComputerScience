% function [nodes,relation,M]=CBCD_core(mat,c_com)
function [nodes,relation,M]=CBCD_core(mat,N,edge,adm,degree,c_com)

mat1=mat;
% edge=length(mat1); %����
% N=length(unique(cat(1,unique(mat1(:,1)),unique(mat1(:,2))))); %�ڵ����
% adm=zeros(N,N,'uint8'); %����ʵ�ʵľ��󣬼����������ʵ�ʾ��󣬽���ֵ��Ϊ0
% for i=1:edge
%         adm(mat1(i,2),mat1(i,1))=1;  %��ԭͼת����Ϊ��ϵ����
%         adm(mat1(i,1),mat1(i,2))=1;  
% end
% degree=zeros(N,2);  %ͳ�Ƹ����ڵ�Ķ�
% for i=1:N
%     degree(i,1)=sum(adm(i,:));
%     degree(i,2)=i;
% end
dr=N/c_com/4;    %��ֵ
%dr=140;
se=zeros(1,N);   %�ҳ�����������ֵ�Ľڵ����

for i=1:N
    if degree(i,1)>=dr
        se(1,i)=1;
        
    end
end
select=find(se(1,:)~=0);  %���к��Ľڵ�
[a,num]=size(select);
relation=zeros(num,2);    %�����¾ɽڵ��ϵ
for i=1:num
    relation(i,1)=i;
    relation(i,2)=select(1,i);
end
index=zeros(edge,1);
d=1;
for i=1:num
    for j=1:num
        if adm(relation(i,2),relation(j,2))==1
            A=[relation(i,2) relation(j,2)];
            [c1,c2]=ismember(A,mat1,'rows');
            %c3=find(c2(:,1)~=0);
            index(d,1)=c2;
            d=d+1;
        end
    end
end
se_edges=nonzeros(index);
[n_edges,t]=size(se_edges);
nodes1=zeros(n_edges,2);
for i=1:n_edges
    nodes1(i,:)=mat1(se_edges(i,1),:);
end

%���߹�ϵ���½ڵ��ʾ
nodes=zeros(n_edges,2);
for i=1:n_edges
    c1=find(relation(:,2)==nodes1(i,1));
    c2=find(relation(:,2)==nodes1(i,2));
    nodes(i,1)=c1;
    nodes(i,2)=c2;
end


M=sparse(num,num);
for i=1:n_edges
    M(nodes(i,1),nodes(i,2))=1;
    M(nodes(i,2),nodes(i,1))=1;
end