
% -------------------------------------------------------------------------
%Aim:
%Search local density peaks
% -------------------------------------------------------------------------
%Input:
%A: the data set
% -------------------------------------------------------------------------
% Written by Dongdong Cheng
% Department of Computer Science, Chongqing University 
% December 2017

function [index,supk,nb,rho,local_core,cores,cl,cluster_number ] = LDP_Searching(A)
[N,dim]=size(A);
% dist=pdist2(A,A);
%  [~,index]=sort(dist,2);%��dist���н�������

kdtree=KDTreeSearcher(A(:,:),'bucketsize',1); % 1��ʾѡ��ŷʽ����
[index,~] = knnsearch(kdtree,A(:,:),'k',100);% �����ź���������;���

%��ʼ����������
r=1;
flag=0;         
nb=zeros(1,N);  %��Ȼ�ھӸ��� 
%NNN=zeros(N,N); %�������Ȼ�ھӼ�
count=0;        %��Ȼ�������Ϊ���������������ͬ�Ĵ���
count1=0;       %ǰһ����Ȼ�������Ϊ���������
count2=0;       %�˴���Ȼ�������Ϊ���������

%������Ȼ����ھ�
while flag==0
    for i=1:N
        k=index(i,r+1);
        nb(k)=nb(k)+1;
%         RNN(k,nb(k))=i;
    end
    r=r+1;
%     count2=0;
    [~,count2]=size(find(nb==0));
%     for i=1:N
%         if nb(i)==0
%             count2=count2+1;
%         end
%     end
    %����nb(i)=0�ĵ�������������仯�Ĵ���
    if count1==count2
        count=count+1;
    else
        count=1;
    end
    if count2==0 || (r>2 && count>=2)   %�ھ�������ֹ����
        flag=1;
    end
    count1=count2;
end

%������Ȼ����ڵĸ���������
supk=r-1;               %����Kֵ��Ҳ����Ȼ����ھӵ�ƽ����
max_nb=max(nb);         %��Ȼ�ھӵ������Ŀ
min_nb=min(nb);         %��Ȼ�ھӵ���С��Ŀ
%NN=index(:,2:SUPk+1);   %�����ݵ��K�������ݵ㼯
%ratio_nb=nb./(N*SUPk);  %�����ݵ����Ȼ����ھ���Ŀ��ռ����
%����ÿ�����ݵ���ܶ�
%disp(SUPk);
%�������Ӿ���
disp(supk);
disp(max_nb);
% disp(min_nb);
rho=zeros(N,1);
Non=max_nb;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %������Ȼ����ͼ
% conn=zeros(N,N);
% for i=1:N
%     for j=2:supk+1
%         x=index(i,j);
%         dist=sqrt(sum((A(i,:)-A(x,:)).^2));
%         conn(i,x)=1/(1+dist);%����ĵ�����Ϊ��������ƶ�
%         conn(x,i)=conn(i,x);
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N
    d=0;
    for j=1:Non+1
        x=index(i,j);
        dist=sqrt(sum((A(i,:)-A(x,:)).^2));
        d=d+dist;
    end
%     rho(i)=exp(-d^2/Non);
    rho(i)=nb(i)/d;
end
% [rho_sorted,ordrho]=sort(rho,'descend');%ordrho�����ܶȴӴ�С��˳��
local_core=zeros(N,1);%���n����ľֲ����ĵ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ҵ�ÿ����Ĵ���㣺����ÿ�����k���򣬽������ܶ����ĵ���Ϊ������
% [rho_sorted,ordrho]=sort(rho,'descend');
% for i=1:N
%     rep=ordrho(i);
%     xrho=rho(rep);
%   for j=2:supk+1
%       if xrho<rho(index(ordrho(i),j))
%           xrho=rho(index(ordrho(i),j));
%           rep=index(ordrho(i),j);
%       end
%   end
%   local_core(ordrho(i))=rep;
% end
%  supk=5;
for i=1:N
    rep=i;
    xrho=rho(rep);
  for j=2:supk+1
      if xrho<rho(index(i,j))
          xrho=rho(index(i,j));
          rep=index(i,j);
      end
  end
  local_core(i)=rep;
end
% %����ÿ���㼰������
% figure;
% plot(A(:,1),A(:,2),'ko','MarkerSize',5,'MarkerFaceColor','k');
% hold on;
% for i=1:N
%     plot([A(i,1),A(local_core(i),1)],[A(i,2),A(local_core(i),2)],'linewidth',1.5,'color','k','LineStyle',':');
%     hold on;
% end
% plot(A(local_core,1),A(local_core,2),'rs','MarkerSize',6,'MarkerFaceColor','w');
%���·���ÿ����ľֲ������
visited=zeros(N,1);
round=0;
for k=1:N
    if visited(k)==0
        parent=k;
        round=round+1;
        while local_core(parent)~=parent
            visited(parent)=round;
            parent=local_core(parent);
        end
        local_core(find(visited==round))=parent;
    end
end
% %����ÿ���㼰������
% hold on;
% plot(A(local_core,1),A(local_core,2),'ro','MarkerSize',8,'MarkerFaceColor','r');
% figure;
% plot(A(:,1),A(:,2),'ko','MarkerSize',5,'MarkerFaceColor','k');
% hold on;
% for i=1:N
%     plot([A(i,1),A(local_core(i),1)],[A(i,2),A(local_core(i),2)],'linewidth',1.5,'color','k','LineStyle',':');
%     hold on;
% end
% plot(A(local_core,1),A(local_core,2),'ro','MarkerSize',8,'MarkerFaceColor','r');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�õ�׼���ĵ㣬׼���ĵ���������Ϊ���ĵ�
 cluster_number=0;
 cl=zeros(N,1);
for i=1:N
    if local_core(i)==i;
       cluster_number=cluster_number+1;
       cores(cluster_number)=i;
       cl(i)=cluster_number;
    end
end
% disp('��ʼ�Ӵظ���Ϊ��');disp(cluster_number);
% �����ǵó�׼����ֱ�ӵõ����Ӵ�
for i=1:N
    cl(i)=cl(local_core(i));
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(6);
% % �������ĵ�ͼ�Լ���Ӧ�ĳ�ʼ������
% plot(A(:,1),A(:,2),'.');
% hold on;
% for i=1:N
%     plot([A(i,1),A(local_core(i),1)],[A(i,2),A(local_core(i),2)]);
%     hold on;
% end
% drawcluster2(A,cl,cluster_number+1);
% hold on;
% plot(A(local_core,1),A(local_core,2),'ro','MarkerSize',8,'MarkerFaceColor','r','MarkerEdgeColor','r');
% % title('����supk���ڵĽ��');
end



