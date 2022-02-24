function [community]=Tran_o(mat,com)

mat1=mat;
edge=length(mat1); %边数
N=length(unique(cat(1,unique(mat1(:,1)),unique(mat1(:,2))))); %节点个数
%adm=zeros(N,N,'uint8'); %建立实际的矩阵，即社区网络的实际矩阵，将初值赋为0
adm=sparse(N,N);
for i=1:edge
        adm(mat1(i,2),mat1(i,1))=1;  %将原图转化成为关系矩阵
        adm(mat1(i,1),mat1(i,2))=1;  
end

[x,y]=max(com.MOD);
[x,z]=max(x);
max_m=y(z);  %模块度最大所在的位置
devided=com.COM{max_m}; %被划分的节点的所属情况
[x,y]=max(devided);
[x,z]=max(x);
c_com=x;   %社区的个数

community=cell(1,c_com);
for i=1:c_com
    [~,community{1,i}]=find(devided(1,:)==i);
end

% community=cell(c_com,1);  %各个社区所含有的节点
% for i=1:c_com
%     [c2,community{i,1}]=find(devided(1,:)==i);
% end

% t=1;
% node_de=zeros(N,2);
% for i=1:c_com
%     [t1,t2]=size(community{i,1});
%     for j=1:t2
%         node_de(t,1)=community{i,1}(1,j);
%         node_de(t,2)=i;
%         t=t+1;
%     end
% end