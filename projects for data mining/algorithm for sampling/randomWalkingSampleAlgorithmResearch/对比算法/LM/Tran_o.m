function [community]=Tran_o(mat,com)

mat1=mat;
edge=length(mat1); %����
N=length(unique(cat(1,unique(mat1(:,1)),unique(mat1(:,2))))); %�ڵ����
%adm=zeros(N,N,'uint8'); %����ʵ�ʵľ��󣬼����������ʵ�ʾ��󣬽���ֵ��Ϊ0
adm=sparse(N,N);
for i=1:edge
        adm(mat1(i,2),mat1(i,1))=1;  %��ԭͼת����Ϊ��ϵ����
        adm(mat1(i,1),mat1(i,2))=1;  
end

[x,y]=max(com.MOD);
[x,z]=max(x);
max_m=y(z);  %ģ���������ڵ�λ��
devided=com.COM{max_m}; %�����ֵĽڵ���������
[x,y]=max(devided);
[x,z]=max(x);
c_com=x;   %�����ĸ���

community=cell(1,c_com);
for i=1:c_com
    [~,community{1,i}]=find(devided(1,:)==i);
end

% community=cell(c_com,1);  %�������������еĽڵ�
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