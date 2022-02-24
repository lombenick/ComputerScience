function [group,NodeLabel,times] = labelPtr(A)
%U.N. Raghavan , R. Albert , S. Kumara , 
%Near linear time algorithm to detect community structures in large-scale networks, Phys. Rev. E 76 (2007) 036106 .

t0=clock;
ok = false;
%classes= cell(0,0);%
row = size(A,1);
labelMatrix = [1:row]; 

while ~ok
    ok = true;  
    sequence = randperm(row);
    for i = 1:row
        neighborOfI = A(sequence(i),:) == 1;
        laberOfNeighbors = labelMatrix(neighborOfI);
        if ~isempty(laberOfNeighbors)
%             uniqueLabel = unique(laberOfNeighbors);                  %
%             labelStatistics = zeros(length(uniqueLabel),2);          %
%             for j = 1:length(uniqueLabel)                            %
%                 labelStatistics(j,1) = uniqueLabel(j);               %
%                 labelStatistics(j,2) = length(find(laberOfNeighbors ==
%                 uniqueLabel(j)));%
%             end %
            iLabel = mode(laberOfNeighbors);  
            Label=labelMatrix(sequence(i));
            %labelMatrix(sequence(i)) = iLabel;
            if labelMatrix(sequence(i)) ~= iLabel
                labelMatrix(sequence(i)) = iLabel;
                ok = false;
                y=0;
            end
        end
    end
end
% uniqueLabel = unique(labelMatrix(2,:));            %
% for i = 1:length(uniqueLabel)                      %
%     index = labelMatrix(2,:) == uniqueLabel(i);    %
%     classes = [classes,labelMatrix(1,index)];
% end

times=etime(clock,t0); 
cur = 0;
totalCom = max(labelMatrix);
group = cell(1);
for i = 1:totalCom
    nodes = find(labelMatrix == i);
    if ~isempty(nodes)
        cur = cur + 1;
        group{cur} = nodes;
    end
end
NodeLabel = 1:length(A);
for i = 1:cur
    nodes = group{i};
    NodeLabel(nodes) = i;
end
end
