
function [community,nodes]=expand_spr(adm,degree,com,relation,N)
[x,y]=max(com.MOD);
[x,z]=max(x);

devided=com.COM{2};
c1=size(devided);
c_de=c1(2);  %�����ֹ��Ľڵ����
[x,y]=max(devided);
[x,z]=max(x);
c_com=x;   %�����ĸ���


nodes=zeros(N,2);
nodes(:,1)=[1:N];


 %�������������еĽڵ�
community=cell(1,c_com);
for i=1:c_com
%     [c2,community{i,1}]=find(devided(1,:)==i);
    [c2,community{1,i}]=find(devided(1,:)==i);
end
%ת��֮ǰ�Ľڵ㻮�����
for i=1:c_com
    [t1,t2]=size(community{1,i});
    for j=1:t2
        c3=relation(community{1,i}(1,j),2);
        community{1,i}(1,j)=c3;
        nodes(c3,2)=i;
    end
end

node_for_select=community;%����ʱ�������пɳ�Ľڵ㼯��

[count_no_label,t]=size(find(nodes(:,2)==0));
k=0;
degree_all=zeros(c_com,1);
node_s=[];
for_select_com=[1:c_com;1:c_com];   %����ѡ�������п�����ʱ�������ѡ�ڵ�
for_select_num=c_com;
while count_no_label
    if for_select_num==0
        break;
    end
    for i=1:for_select_num
        degree_all(i)=sum(degree(node_for_select{1,i}(1,:),1));
    end
    r=randperm(for_select_num);
    select=r(1);%ѡ��ı���������
    select_com=for_select_com(2,select);%������Ӧ��ԭ����
    pro=degree(node_for_select{1,select}(1,:),1)/degree_all(select);
%�������д�ѡ�Ľڵ����
    num_node_for_select=size(node_for_select{1,select});
    if num_node_for_select(1,2)==0
        node_for_select(select)=[];
        for_select_num=for_select_num-1;
        for_select_com(:,select)=[];
        for_select_com(1,select:end)=for_select_com(1,select:end)-1;
        continue;
    else
        s_index = datasample(1:num_node_for_select(1,2),1,'Weights',pro,'Replace',true);
    end

    %���ն�����ƫ������ĳһ������ѡȡһ�ڵ�
    s=node_for_select{1,select}(1,s_index); 
    node_s=[node_s,s];
    [~,neighbor] = find(adm(s,:)==1);%��ѡ�ڵ���ھӽڵ�
    
    [unlabeled,~]=find(nodes(neighbor(1,:),2)==0);
    unlabeled_size = length(unlabeled);
    
    
    if unlabeled_size==0
        node_for_select{1,select}(:,s_index)=[];
        continue;
    else
        unlabeled=neighbor(1,unlabeled(:,1));%δ����ǵ��ھӽڵ�
        nodes(unlabeled(1,:),2)=select_com;
        community{1,select_com}=[community{1,select_com},unlabeled];
        node_for_select{1,select}(:,s_index)=[];
        node_for_select{1,select}=cat(2,node_for_select{1,select},unlabeled);
    end
  
    [count_no_label,t]=size(find(nodes(:,2)==0));
    
    k=k+1;

end
[not_select,~]=find(nodes(:,2)==0);
len=length(not_select);
for i=1:len
    r=randperm(c_com);
    nodes(not_select(i,1),2)=r(1);
    community{1,r(1)}=[community{1,r(1)},not_select(i)];
end









