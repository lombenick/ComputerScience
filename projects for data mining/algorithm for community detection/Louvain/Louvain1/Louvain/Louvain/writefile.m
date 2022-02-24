function writefile(outM,str)

%%%%%%%%% outM  
   
count=size(outM);
filename2 = sprintf(str);
Fid2 = fopen(filename2, 'w');

m=count(1);
n=count(2);

for i=1:m
    for j=1:n-1
         fprintf(Fid2,'%i ',outM(i,j));
    end
    fprintf(Fid2,'%i\r\n',outM(i,n));
end

fclose(Fid2);
       
%%%%%%%%%%Êä³öÎÄ¼þ
