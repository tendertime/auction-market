function [payment,profit,y] = mcap(ap,numAP,P,C,aim,so)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
rb=[54,48,36,24,18,12,9,6];%wifi��������
rbr=[8.7,9.4,13.8,18.7,23.5,27.4,34.6,37.3];%��Ӧ����
co=[2,5,12]*pi*37.3*37.3/1000;%cover
co=ceil(co);
buf=0;%
payment=0;
profit=0;
y=zeros(1,numAP);
for i=1:numAP
    if(buf<aim)
        y(so(i))=1;
    else
        break;
    end
    payment=payment+ap(so(i)).bid;
    buf=buf+ap(so(i)).b;%���Ǵ�������ʱ��
    %buf=buf+ap(so(i)).s;%�������أ�
    l=rand(1);
    if(l<0.8)%����и���80
        lo=3;
    elseif (l>0.95)%С���и���5
        lo=1;
    else lo=2;%�����еȳ���
    end
    %ѡ�����
    mcl=38*rand(1,co(lo));%����ֲ�����
    mcd=2.5*rand(1,co(lo))+0.5;%����ֲ�mc������
    [mcl,rl]=sort(mcl);%��������ԭ��˳����
    bufb=0;
    bufd=0;
    traffic=0;
    ll=1;%
    for j=1:co(lo)
       if(mcl(j)>rbr(ll)&ll~=8)
           ll=ll+1;
       end
       if(bufb+mcd(j)/rb(ll)<1 & bufd+mcd(j)<ap(so(i)).limit)
           bufb=bufb+mcd(j)/rb(ll);
           bufd=bufd+mcd(j);
           traffic=traffic+mcd(j);
       else
           continue
       end
    end
    profit=profit+traffic*(P-C*(1-ap(so(i)).h));
end
end
