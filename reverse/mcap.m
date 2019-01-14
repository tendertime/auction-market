function [payment,profit,y] = mcap(ap,numAP,P,C,aim,so)
%UNTITLED2 此处显示有关此函数的摘要
rb=[54,48,36,24,18,12,9,6];%wifi连接速率
rbr=[8.7,9.4,13.8,18.7,23.5,27.4,34.6,37.3];%对应距离
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
    buf=buf+ap(so(i)).b;%考虑带宽因素时；
    %buf=buf+ap(so(i)).s;%缓存因素；
    l=rand(1);
    if(l<0.8)%大城市概率80
        lo=3;
    elseif (l>0.95)%小城市概率5
        lo=1;
    else lo=2;%进入中等城市
    end
    %选择完毕
    mcl=38*rand(1,co(lo));%随机分布距离
    mcd=2.5*rand(1,co(lo))+0.5;%随机分布mc的需求；
    [mcl,rl]=sort(mcl);%距离排序，原有顺序是
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
