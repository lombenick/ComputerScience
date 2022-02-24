function [M,relation]=RW_pro(adm,degree,r_count,n_count,N)
% adm=zeros(N,N,'uint8'); %����ʵ�ʵľ��󣬼����������ʵ�ʾ��󣬽���ֵ��Ϊ0
% adm=sparse(N,N);
% for i=1:edge
%         adm(mat1(i,2),mat1(i,1))=1;  %��ԭͼת����Ϊ��ϵ����
%         adm(mat1(i,1),mat1(i,2))=1;  
% end


% degree=zeros(N,1);    %ͳ�Ƹ����ڵ�Ķ���
% for i=1:N
%     degree(i,1)=sum(adm(i,:));
% end

flag1=zeros(N,1);  %��ÿ���ڵ㱻��ȡ�����ı�ǩ
count_edge=[];  %ͳ��ÿ���߳��ֵĴ���(���У����һ�б������)
visitednode=[];   %��ÿ��������߷��ʹ��Ľڵ����ͳ��(���У����һ�б������)
for i=1:r_count
    flag2=zeros(N,1); %ÿһ��������߱�ǩ2��Ҫ���㣬��ֹ����
    %r=randperm(r_count);     %�Գ�ʼ�ڵ�*************************
%     u=randperm(N,1);
    
    
    
    degreeall=sum(degree(:,1));
    allnode=[1:1:N];
    allnodepro=degree(:,1)/degreeall;
    u_index = datasample(1:N,1,'Weights',allnodepro,'Replace',true); 
    u=allnode(u_index);
    
    flag1(u,1)=flag1(u,1)+1; %u�ı�ǩ1��һ
    flag2(u,1)=flag2(u,1)+1; %u�ı�ǩ2��һ
    v=u;
    
    %��ǽڵ���ʵ����
        visitnodesize = size(visitednode,1);
        if visitnodesize==0
           visitednode =[v,1];
        else
            ww1=0;
            for k=1:visitnodesize
                if visitednode(k,1) == v
                    visitednode(k,2) =  visitednode(k,2)+1;
                    break;
                else
                    ww1=ww1+1;
                end
            end
            if ww1==visitnodesize
                visitednode =cat(1,visitednode,[v,1]);
            end
        end
    
    for j=2:n_count
              
        [~,tempneighborindex] = find(adm(v,:)==1);
        neighbor = tempneighborindex(find((flag2(tempneighborindex,1)==0)));
        neighborsize = length(neighbor);
        if neighborsize<1
            break;
        end
        neighbordeger = degree(neighbor,1);
        neighborpro =  neighbordeger/sum(neighbordeger);
        
        sampleindex = datasample(1:neighborsize,1,'Weights',neighborpro,'Replace',false);  %�޷Ż�ƫ����
        
        sampleobject = neighbor(sampleindex);
        
        %��ǽڵ���ʵ����
        visitnodesize = size(visitednode,1);
        ww2=0;
        for k=1:visitnodesize
            if visitednode(k,1) == sampleobject
                visitednode(k,2) =  visitednode(k,2)+1;
                break;
            else
                ww2=ww2+1;
            end
        end
        if ww2==visitnodesize
            visitednode =cat(1,visitednode,[sampleobject,1]);
        end
        
        
        %�ж��ѷ��ʵı����Ƿ��иñߣ������1���������뵱ǰ�߲����Ϊ1
        if v<sampleobject
            
            nowedge = [v,sampleobject,1];
        else
            nowedge = [sampleobject,v,1];
        end
        visitedgenum = size(count_edge,1);
        if visitedgenum==0
            count_edge = nowedge;
        else
            ww3=0;
            for m=1:visitedgenum
                if isequal(count_edge(m,[1,2]), nowedge([1,2]))
                    count_edge(m,3) =  count_edge(m,3)+1;
                    break;
                else
                    ww3=ww3+1;
                   
                end
                if ww3==visitedgenum
                    count_edge = cat(1,count_edge,nowedge);
                end
            end
        end
        
        v= sampleobject;%��ʾ��ǰ����λ��
        flag1(v,1)=flag1(v,1)+1; %u�ı�ǩ1��һ
        flag2(v,1)=flag2(v,1)+1; %u�ı�ǩ2��һ
    end
end

visitnodesize = size(visitednode,1);
visitedgenum = size(count_edge,1);



p =r_count;
k= n_count;

% reach1=zeros(N,2);   %ÿ���ڵ㱻���ʹ����ܴ���
% for i=1:N
%     reach1(i,1)=i;
%     if flag1(i,1)~=0
%         reach1(i,2)=flag1(i,1);
%     end
% end

weightedge=zeros(visitedgenum,3);
weightedge(:,1)=count_edge(:,1);
weightedge(:,2)=count_edge(:,2);

countallnode=sum(visitednode(:,2));   %���ʵĽڵ��ܴ���
countalledge=sum(count_edge(:,3));    %���ʵıߵ��ܴ���

for i=1:visitedgenum
  
    weightedge(i,3)=log10((count_edge(i,3)/countalledge)/((flag1(weightedge(i,1),1)/countallnode)*(flag1(weightedge(i,2),1)/countallnode))); %���ݻ���Ϣ��Ȩֵ

end


new_node=zeros(visitnodesize,2);%�½ڵ���ɽڵ��Ӧ��ϵ
for i=1:visitnodesize
    new_node(i,1)=i;
    new_node(i,2)=visitednode(i,1);
%     new_node(i,2)=pro_sin(i,1);
end

relation=new_node;
weight_new=zeros(visitedgenum,3);   %���½ڵ��ʾ�ĸ��߼���Ȩ��
for i=1:visitedgenum
    c1=find(new_node(:,2)==weightedge(i,1));
    c2=find(new_node(:,2)==weightedge(i,2));
    weight_new(i,1)=new_node(c1,1);
    weight_new(i,2)=new_node(c2,1);
    weight_new(i,3)=weightedge(i,3);
end

M=zeros(visitnodesize);           %�½ڵ��Ӧ���ڽӾ���
for i=1:visitedgenum
    M(weight_new(i,1),weight_new(i,2))=weight_new(i,3);
    M(weight_new(i,2),weight_new(i,1))=weight_new(i,3);
end