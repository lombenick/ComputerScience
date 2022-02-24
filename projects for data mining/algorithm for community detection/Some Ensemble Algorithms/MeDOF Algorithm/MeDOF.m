function [finallabel,times] = MeDOF(G)
    totalNodeNum = size(G,1);
    M = 20;
    Mlabels = zeros(M,totalNodeNum);
    for i=1:2:M
        [NodesLabel,~]= LM(G);
        Mlabels(i,:) = NodesLabel;
        [~,NodesLabel,~] = labelPtr(G);
        Mlabels(i + 1,:) = NodesLabel;
    end
    t0 = clock;
    finallabel = ensembleAlgorithm(Mlabels');
    times = etime(clock,t0);  
end