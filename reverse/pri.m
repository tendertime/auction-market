function [] = pri()
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%main(P,C,F,numAP,numMC,alpha)
n=1;
for j=1:0.2:10
    for i=1:20
        %[a(i),b(i),c(i)]=main(40,1,10000,j,200,0.5);
        [a(i),b(i),c(i)]=main(40,j,10000,40,200,0.5);
    end
    u(n)=j;
    x(n)=mean(a);
    y(n)=mean(b);
    z(n)=mean(c);
    n=n+1;
end
plot(u,x,'--b',u,y,'-.go',u,z,':rx');
legend('VCG','AGV','OPT',4);
xlabel('Cache miss cost per Mb/s');
ylabel('Social Welfare Function(SWF)')
end
