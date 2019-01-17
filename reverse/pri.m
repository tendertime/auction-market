function [] = pri()
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%main(P,C,F,numAP,numMC,alpha)
%u=[60,120,150,200];
for j=1:46
    u(j)=29+j;
    %算95%置信区间
    display(j);
    for i=1:50
        [a(i),b(i),c(i)]=main(u(j),5,0.8,60);
    end
    [~,~,f]=ttest(a,mean(a),0.01);
    a(a<f(1)|a>f(2))=[];
    [~,~,f]=ttest(b,mean(b),0.01);
    b(b<f(1)|b>f(2))=[];
    [~,~,f]=ttest(c,mean(c),0.01);
    c(c<f(1)|c>f(2))=[];
    x(j)=mean(a);
    y(j)=mean(b);
    z(j)=mean(c);
    %z(j,:)=[mean(a),mean(b),mean(c)];
end
%bar(u,z);
plot(u,x,'--b',u,y,'-.go',u,z,':rx');
legend('VCG','AGV','OPT',4);
xlabel('Number of AP');
%xlabel('Profit per Mb/s');
ylabel('Time Consumption');
end
