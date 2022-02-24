%将标准答案转化为cell数组存储

function community = translateOverlapCommunity()
    fid = fopen('community.dat');
    % fid = fopen('test.txt');
    line = fgetl(fid);
    communityCell = cell(0);
    curNum = 0;
    while ~isempty(line)
        numbers = str2num(line);
        tmp = [];
        for i = 1:length(numbers)
            number = numbers(i);
            if i ~= 1
                tmp = [tmp number];
            end
        end
        curNum = curNum + 1;
        communityCell{curNum} = tmp;
        line = fgetl(fid);
        if line == -1
            break;
        end
    end
    comNum = 0;
    for i = 1:length(communityCell)
        community = communityCell{i};
        for j = 1:length(community)
            if comNum < community(j)
                comNum = community(j);
            end
        end
    end
    community = cell(1,comNum);
    for i = 1:length(communityCell)
        communities = communityCell{i};
        for j = 1:length(communities)
            Community = communities(j);
            community{Community} = [community{Community} i];
        end
    end
end
           
            