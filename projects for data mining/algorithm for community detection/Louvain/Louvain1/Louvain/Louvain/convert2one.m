function convert2one
clear,clc;
close all;

str='karate.dat';
str2='karate1.dat';
converts(str,str2);

str='football.dat';
str2='football1.dat';
converts(str,str2);

str='lesmis.dat';
str2='lesmis1.dat';
converts(str,str2);

str='polbooks.dat';
str2='polbooks1.dat';
converts(str,str2);

str='dolphin.dat';
str2='dolphin1.dat';
converts(str,str2);

str='jazz.dat';
str2='jazz1.dat';
converts(str,str2);

str='celegansneural.dat';
str2='celegansneural1.dat';
converts(str,str2);

str='email.dat';
str2='email1.dat';
converts(str,str2);

str='netscience.dat';
str2='netscience1.dat';
converts(str,str2);

str='polblogs.dat';
str2='polblogs1.dat';
converts(str,str2);

str='adjnoun.dat';
str2='adjnoun1.dat';
converts(str,str2);

str='celegans_metabolic.dat';
str2='celegans_metabolic1.dat';
converts(str,str2);

function converts(str,str2)
G=load(str);
m2=size(G,1);
G=sparse(G(:,1),G(:,2),ones(m2,1));
G=full(G);
sm=sum(G,1);
ix=find(sm);
G=G(ix,ix);
[i,j,v]=find(G);
G=[i,j];
writefile(G,str2);











