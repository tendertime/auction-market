function [] = pri()
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%main(P,C,F,numAP,numMC,alpha)
for j=5:60
    for i=1:10
        [a(i),b(i),c(i)]=main(20,1,1000,j,200,0.5);
    end
    u(j)=j;
    x(j)=mean(a);
    y(j)=mean(b);
    z(j)=mean(c);
end
plot(u,x,'--b',u,y,'-.go',u,z,':rx');
legend('VCG','AGV','OPT',4);
xlabel('Num. of AP');
ylabel('Execution Time');
end

