%深度优先遍历非连通图
%借助的是栈

function metaCom = DFS_Non_RC(G)
    S = zeros(length(G),1);
    visited = zeros(1,length(G));
    metaCom = cell(1,length(G));
    metaComNum = 0;
    while ~isempty(find(visited == 0,1))
        v = find(visited == 0,1);
        S(1) = v;cur = 1;visited(v) = 1;com = zeros(1,length(G));
        everyTimeNum = 1;com(everyTimeNum) = v;
        while ~isempty(find(S,1))
            k = S(cur);S(cur) = 0;cur = cur - 1;                            % pop(S)
            neibors = find(G(k,:));
            for i = 1:length(neibors)
                if visited(neibors(i)) == 0
                    cur = cur + 1;S(cur) = neibors(i);                      % push(S)
                    visited(neibors(i)) = 1;
                    everyTimeNum = everyTimeNum + 1;com(everyTimeNum) = neibors(i);
                end
            end
        end
        com = com(1:everyTimeNum);
        metaComNum = metaComNum + 1;
        metaCom{metaComNum} = com;
    end
    metaCom = metaCom(1:metaComNum);
end