function [finalCommunityLabel,times] = ConClu(G,np,tao)
% Consensus Clustering
  t0=clock;  
    N = size(G,1); % �ڵ�����
    M = numel(find(G))/2; % �ߵ�����
    D = zeros(size(G));
    
    iter = 1;
    while iter <100
        iter = iter+1;
        
        community_all = zeros(N,np);
        co_mat = [];
        for i = 1:np
            community_all(:,i) = LM(G);
        end
        
        ss = 0;
        for i = 1:N
            s = length(unique(community_all(i,:)));
            ss = ss + s;
        end
        if ss == N
            break
        end
        
        for i = 1:np
            a = community_all(:,i);
            b = zeros(N,max(a));
            for j = 1:N
                b(j,a(j,1)) = 1;
            end
            co_mat = [co_mat,b];
        end
        % ���ƶȾ��� D = 1/M * BB'
        D = 1/np * (co_mat * co_mat');
        D = D-diag(diag(D)-diag(0));
        D = sparse(D);
        
        % С��tao��Ԫ����0
        D(find(D < tao)) = 0;
        
        % �����ڽӾ��󣬽�����һ�ε���
        G = D; 
    end

    finalCommunityLabel = LM(D);
    times=etime(clock,t0);  