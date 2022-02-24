function [labelMatrix,times] = label_Propagation1(A)
%U.N. Raghavan , R. Albert , S. Kumara ,   白亮
%Near linear time algorithm to detect community structures in large-scale networks, Phys. Rev. E 76 (2007) 036106 .

t0=clock;
ok = false;
%classes= cell(0,0);%
row = size(A,1);
labelMatrix = [1:row]; 
newlabel=labelMatrix;%+++
Iter=0;
LPA_MAXIMUM_ITERATIONS=200;
while ~ok & Iter < LPA_MAXIMUM_ITERATIONS
    ok = true;  
    Iter = Iter+1;
    labelMatrix = newlabel;
    sequence = randperm(row);
    for i = 1:row
        neighborOfI = A(sequence(i),:) == 1;
        laberOfNeighbors = labelMatrix(neighborOfI);
        if ~isempty(laberOfNeighbors)
%             uniqueLabel = unique(laberOfNeighbors);                  %
%            t labelStatistics = zeros(length(uniqueLabel),2);          %
%             for j = 1:length(uniqueLabel)                            %
%                 labelStatistics(j,1) = uniqueLabel(j);               %
%                 labelStatistics(j,2) = length(find(laberOfNeighbors ==
%                 uniqueLabel(j)));%
%             end %
            iLabel = mode(laberOfNeighbors);  
            Label=labelMatrix(sequence(i));
            %labelMatrix(sequence(i)) = iLabel;
            if Label ~= iLabel
               % labelMatrix(sequence(i)) = iLabel;
                newlabel(sequence(i)) = iLabel;   %同步更新标签 https://blog.csdn.net/google19890102/article/details/50186831
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
end

