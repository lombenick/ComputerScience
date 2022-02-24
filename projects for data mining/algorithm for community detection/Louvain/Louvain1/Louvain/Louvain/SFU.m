% function M = FastUnfording
% clear,clc;
% close all;
% str='karate1.dat';
% subfua(str);
% 
% 
% function subfua(str)
% m=load(str);
% M=sparse(m(:,1),m(:,2),ones(size(m,1),1));
% M=full(M);
% labels=SFU(M);
% n=size(M,1);
% c=length(unique(labels));
% nlabels=zeros(n,c);
% for i=1:n
%     nlabels(i,labels(i))=1;
% end
% [i,j,v]=find(M);
% W=[i,j];
% % info=OverlappingInfomap(W,nlabels);
% str
% info
% c


function labels=SFU(m) %%%%%%%%%% m is the adjacency matrix of the network
s=1;
self=1;
debug=1;
verbose=1;
[COMTY,~] = cluster_jl_orient(m,s,self,debug,verbose);

ss=length(COMTY.COM);
Q=COMTY.MOD(ss);
labels=COMTY.COM{1,ss};

for i=1:length(COMTY.COM)
    COMTY.COM{1,i};
    COMTY.MOD(i);
end


% function val=OverlappingInfomap(W,labels)
% n=size(labels,1);
% c=size(labels,2);
% m2=size(W,1);
% m=m2/2;
% L=100;
% 
% tmp=diff(W(:,2)');
% jin=find([1,tmp,1]);
% deg=diff(jin);
% 
% pai=rand(n,c);
% pai=pai.*labels;
% pai=pai/sum(sum(pai));
% sav=zeros(n,c);
% sta=deg/sum(deg);
% 
% for count=1:L
%     for a=1:n
%         bs=W(jin(a):jin(a+1)-1,1);
%         is=find(labels(a,:));
%         for z=1:length(is)
%             i=is(z);
%             tmp=0;
%             for x=1:length(bs)
%                 b=bs(x);
%                 js=find(labels(b,:));
%                 for y=1:length(js)
%                     j=js(y);
%                     if i==j
%                         derta=1;
%                     else
%                         if isempty(find(is==j))%%%
%                             derta=1/length(is);
%                         else
%                             derta=0;
%                         end
%                     end
%                     tmp=tmp+pai(b,j)*derta/deg(b);
%                 end
%             end
%             sav(a,i)=tmp;
%         end
%     end
%     mdf=dist2(pai,sav);
%     if mdf<1.0e-3
%         pai=sav;
%         break;
%     end
%     pai=sav;
% end
% 
% qout=zeros(1,c);
% for i=1:c
%     lab=labels(:,i);
%     lab=lab';
%     com=find(lab);
%     tmp=0;
%     for x=1:length(com)
%         a=com(x);
%         bs=W(jin(a):jin(a+1)-1,1);
%         bs=bs';
%         kin=length(intersect(com,bs));
%         ka=deg(a);
%         paout=(ka-kin)/ka;
%         tmp=tmp+pai(a,i)*paout;
%     end
%     qout(i)=tmp;
% end
% 
% sqout=sum(qout);
% HQ=0;
% for i=1:c
%     tmp=qout(i)/sqout;
%     HQ=HQ-tmp*log2(tmp);
% end
% left=sqout*HQ;
% 
% HP=zeros(1,c);
% pin=zeros(1,c);
% for i=1:c
%     lab=labels(:,i);
%     lab=lab';
%     com=find(lab);
%     pin(i)=qout(i)+sum(pai(com,i)');
%     tmp=qout(i)/pin(i);
%     HP(i)=HP(i)-tmp*log2(tmp);
%     for x=1:length(com)
%         a=com(x);
%         tmp=pai(a,i)/pin(i);
%         HP(i)=HP(i)-tmp*log2(tmp);
%     end
% end
% 
% spin=sum(pin);
% right=sum(pin.*HP);
% 
% val=left+right;
% %%method3
% 
% function d=dist1(old,new)
% derta=abs(old-new);
% d=derta/abs(old);
% 
% function d=dist2(old,new)
% d1=sum(sum((old-new).^2))^(1/2);
% d2=sum(sum(old.^2))^(1/2);
% d=d1/d2;


%%%method3



