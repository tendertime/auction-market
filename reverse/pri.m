function [] = pri()
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%main(P,C,F,numAP,numMC,alpha)
n=4;
u=[60,120,150,200];
for j=1:4
    for i=1:30
        [a(i),b(i),c(i)]=main(15,5,0.8,u(j));
    end
    z(j,:)=[mean(a),mean(b),mean(c)];
end
bar(u,z);
legend('VCG','AGV','OPT',4);
xlabel('Number of AP');
ylabel('Social Welfare');
end
