function [] = pri()
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%main(P,C,F,numAP,numMC,alpha)
for j=10:100
    for i=1:10
        [a(i),b(i),c(i)]=main(30,1,1000,40,j,0.5);
    u(j)=j;
    x(j)=mean(a);
    y(j)=mean(b);
    z(j)=mean(c);
end
plot(u,x,'g');
hold on
plot(u,y,'b');
hold on
plot(u,z,'r');
end

