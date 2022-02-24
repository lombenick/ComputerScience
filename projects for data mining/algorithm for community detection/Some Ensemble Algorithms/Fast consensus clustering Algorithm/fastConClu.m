function [finalCommunityLabel,times] = fastConClu(G,np,tao)
% Fast Consensus Clustering
 
t0=clock;
    N = size(G,1); % 节点数量
    M = numel(find(G))/2; % 边的数量
    delta = 0.02;
    
    iter = 1;
    while iter <100
        iter = iter+1;
        
        community_all = zeros(N,np);
        co_mat = [];
        for i = 1:np
            community_all(:,i) = LM(G);
            a = community_all(:,i);
            b = zeros(N,max(a));
            for j = 1:N
                b(j,a(j,1)) = 1;
            end
            co_mat = [co_mat,b];
        end
        % 相似度矩阵 D = 1/M * BB'
        D = 1/np * (co_mat * co_mat');
        D = D-diag(diag(D)-diag(0));
        D = sparse(D);
        Dc = D;
        
        D = D.*G;

        % 小于tao的元素置0
        D(find(D < tao)) = 0;

        % If a node gets disconnected, keep it attached to the rest of the graph by
        % preserving the link with the highest weight.
        discon = find(sum(D) == 0);
        if numel(discon) ~= 0
           for i = discon
               maxw = max(G(:,1));
               addedge = find(G(:,i) == maxw);
               D(i,addedge(1)) = maxw;
               D(addedge(1),i) = maxw;
           end
        end

        % 随机选取m个点，并随机选取两个邻居
        for i=1:M
            nodeid =randi(N,1,1);
            neighbor = find(D(:,nodeid)==1);
            neighborsize= size(neighbor,1);
            if neighborsize >= 2
                random = randperm(neighborsize);
                if D(neighbor(random([1])),neighbor(random([2]))) ==0
                    D(neighbor(random([1])),neighbor(random([2]))) = Dc(neighbor(random([1])),neighbor(random([2])));
                end
            end
        end
              
        onenum = length(find(D==1));
        smallonenum = length(find(D<1&D>0));
        if smallonenum/(smallonenum+onenum) < delta
            break;
        end
        
        % 复制邻接矩阵，进行下一次迭代
        G = D; 
    end

    finalCommunityLabel = LM(D);
        times=etime(clock,t0);  