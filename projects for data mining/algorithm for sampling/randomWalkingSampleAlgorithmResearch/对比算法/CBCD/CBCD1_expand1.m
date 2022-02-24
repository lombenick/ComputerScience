
%com为划分好的节点以及其所属社区
%relation为新旧节点对应关系

% function [final]=CBCD1_expand(mat,com,nodes,relation)
% function [final]=CBCD1_expand1(mat,com,nodes,M,degree,relation)
function [community1]=CBCD1_expand1(N,adm,com,nodes,M,degree,relation)


devided=com.COM{2};
devided=devided';


% mat1=mat;
% se_nodes=nodes;
% edge=length(mat1); %边数
% N=length(unique(cat(1,unique(mat1(:,1)),unique(mat1(:,2))))); %节点个数
% adm=zeros(N,N,'uint8'); %建立实际的矩阵，即社区网络的实际矩阵，将初值赋为0
% for i=1:edge
%         adm(mat1(i,2),mat1(i,1))=1;  %将原图转化成为关系矩阵
%         adm(mat1(i,1),mat1(i,2))=1;  
% end
[e_core,b]=size(nodes);
[n_core,b]=size(relation);
% M=zeros(n_core,n_core,'uint8');
% for i=1:e_core
%     M(se_nodes(i,2),se_nodes(i,1))=1;        %将核心节点转化为关系矩阵
%     M(se_nodes(i,1),se_nodes(i,2))=1;
% end


% degree=zeros(N,2);  %统计各个节点的度
% for i=1:N
%     degree(i,1)=sum(adm(i,:));
%     degree(i,2)=i;
% end
com_n=max(devided(:,1));

community=cell(com_n,1);  %各个社区所含有的节点
for i=1:com_n
    [community{i,1},c2]=find(devided(:,1)==i);
end
%统计支持度
% sup1=zeros(n_core,com_n,'uint8');   %存储核心节点（新）对各个社区的支持度
% for i=1:com_n
%     [t1,t2]=size(community{i,1});
%     for j=1:n_core
%         for t=1:t1
%             if M(j,community{i,1}(t,1))==1
%                 sup1(j,i)=sup1(j,i)+1;
%             end
%         end
%     end
% end

sup1=sparse(n_core,com_n);
for j=1:n_core
    for i=1:com_n
        ww=sum(M(j,community{i,1}(:,1)));
        sup1(j,i)=ww;
    end
end

%数组元包   转化之前的节点划分情况 支持度也对应变化
% sup=sup1;   %行号并不是节点编号，而是在relation中对应的第二列的编号
% for i=1:com_n
%     [t1,t2]=size(community{i,1});
%     for j=1:t1
%         c3=relation(community{i,1}(j,1),2);
%         community{i,1}(j,1)=c3;
%     end
% end
%community

sup=sup1;
for i=1:com_n
    community{i,1}(:,1)=relation(community{i,1}(:,1),2)';
end


%构建社区摘要
summary=zeros(com_n,N);
for i=1:com_n
    for j=1:n_core
        if sup(j,i)~=0
            summary(i,relation(j,2))=sup(j,i);
        end
    end
end

%遍历剩余节点
% t=1;
% no_de=zeros(N-n_core,2);    %未被划分的节点，及其所属社区
% for i=1:N
%     [t1,~]=size(find(relation(:,2)~=i));
%     if t1==n_core
%         no_de(t,1)=i;
%         t=t+1;
%     end
% end

no_de=zeros(N,2);   %未被划分的节点，及其所属社区
for i=1:N
    no_de(i,1)=i;
end
core_node=sort(relation(:,2));
no_de(core_node(:,1),:)=[];

% [nocore_n,t2]=size(no_de);
% neibor=zeros(nocore_n,N,'uint8');  %存储非核心节点的邻居节点
% for i=1:nocore_n     %记录邻居节点
%     t=1;
%     for j=1:N
%         if adm(no_de(i,1),j)==1
%             neibor(i,t)=j;
%             t=t+1;
%         end
%     end
% end

[nocore_n,t2]=size(no_de);
neibor=zeros(nocore_n,N,'uint8');  %存储非核心节点的邻居节点
for i=1:nocore_n
    [~,tempneighborindex] = find(adm(no_de(i,1),:)==1);
    [~,count_nei]=size(tempneighborindex);
    neibor(i,1:count_nei)=tempneighborindex;
end


%计算剩余节点与社区的相似值
sim=zeros(nocore_n,com_n);
for i=1:nocore_n
    s1=0;
    summ=zeros(com_n,1);
    for j=1:com_n
        [t1,t2]=size(community{j,1});  %t1为j社区的节点个数
        [t3,t4]=size(find(neibor(i,:)~=0));  %t3为i的邻居节点个数
        for t=1:t3
            flag=s1;
            s1=s1+sqrt(summary(j,neibor(i,t))/t1);
            if s1~=flag
                summ(j,1)=summ(j,1)+1;     %统计邻居属于社区j的个数
            end
        end
        s2=s1/degree(no_de(i,1),1);
        sim(i,j)=s2;
    end
    [max_s,index]=max(sim(i,:));       %index为最大对应的社区
    [t5,t6]=size(community{index,1});  %t5为社区节点个数
    community{index,1}(t5+1,1)=no_de(i,1);
    %  更新社区摘要
    for t11=1:com_n
        summary(t11,no_de(i,1))=summ(t11,1);
    end
end
%commuinty

t=1;
node_de=zeros(N,2);
for i=1:com_n
    [t1,t2]=size(community{i,1});
    for j=1:t1
        node_de(t,1)=community{i,1}(j,1);
        node_de(t,2)=i;
        t=t+1;
    end
end
node_de=sortrows(node_de,1);


%重新计算剩余节点的对各社区的相似值，迭代
K=0;  %迭代次数
while(1)
    K=K+1;
    sim=zeros(nocore_n,com_n);
    for i=1:nocore_n
        s1=0;
        summ=zeros(com_n,1);
        for j=1:com_n
            [t1,t2]=size(community{j,1});  %t1为j社区的节点个数
            [t3,t4]=size(find(neibor(i,:)~=0));  %t3为i的邻居节点个数
            for t=1:t3
                flag=s1;
                s1=s1+sqrt(summary(j,neibor(i,t))/t1);
                if s1~=flag
                    summ(j,1)=summ(j,1)+1;     %统计邻居属于社区j的个数
                end
            end
            s2=s1/degree(no_de(i,1),1);
            sim(i,j)=s2;
        end
        [max_s,index]=max(sim(i,:));       %index为最大对应的社区
        [t5,t6]=size(community{index,1});  %t6为社区节点个数
        community{index,1}(1,t6+1)=no_de(i,1);
        %  更新社区摘要
        for t11=1:com_n
            summary(t11,no_de(i,1))=summ(t11,1);
        end
    end
    node_de1=node_de;
    t=1;
    node_de=zeros(N,2);
    for i=1:com_n
        [t1,t2]=size(community{i,1});
        for j=1:t1
            node_de(t,1)=community{i,1}(j,1);
            node_de(t,2)=i;
            t=t+1;
        end
    end
    node_de=sortrows(node_de,1);
    if isequal(node_de,node_de1)==1
        final=node_de;
        break;
    end
end
K
% commuinty1=cell(1,com_n);
% for i=1:com_n
%     community1{1,i}=community{i,1}';
% end


community1=cell(1,com_n);
for i=1:com_n
    [ww,~]=find(final(:,2)==i);
    community1{1,i}=ww';
end


        
        


