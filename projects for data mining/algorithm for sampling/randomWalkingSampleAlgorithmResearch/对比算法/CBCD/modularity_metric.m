function Q=modularity_metric(modules,adj,nedges)

% nedges=numedges(adj); % total number of edges

Q = 0;
for m=1:length(modules)
    mm=sum(sum(adj(modules{m},modules{m})))/2;
    e_mm=mm/nedges;
    a_m=sum(sum(adj(modules{m},:)))/(2*nedges);
    Q = Q + (e_mm - a_m^2);
  
end