function flag=iscontain2( q,front,rear,x )
%�����q��������
flag=0;
for i=front:rear
    if q(i)==x
        flag=1;
        break;
    end
end

end

