function [payment,profit,y] = mcap(ap,numAP,P,C,aim,so,msd,msl)
%UNTITLED2 此处显示有关此函数的摘要
rb=[54,48,36,24,18,12,9,6];%wifi连接速率
rbr=[8.7,9.4,13.8,18.7,23.5,27.4,34.6,37.3];%对应距离
buf=0;
profit=0;
payment=0;
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
    bufb=0;
    bufd=0;
    traffic=0;
    ll=1;%
    for j=1:ap(so(i)).l
       if(msl(so(i),j)>rbr(ll)&ll~=8)
           ll=ll+1;
       end
       if(bufb+msd(so(i),j)/rb(ll)<1 & bufd+msd(so(i),j)<ap(so(i)).limit)
           bufb=bufb+msd(so(i),j)/rb(ll);
           bufd=bufd+msd(so(i),j);
           traffic=traffic+msd(so(i),j);
       else
           continue
       end
    end
    profit=profit+traffic*(P-C*(1-ap(so(i)).h));
end
end
%{
function [payment,profit,y] = mcap(ap,numAP,P,C,aim,so)
%UNTITLED2 此处显示有关此函数的摘要
rb=[54,48,36,24,18,12,9,6];%wifi连接速率
rbr=[8.7,9.4,13.8,18.7,23.5,27.4,34.6,37.3];%对应距离
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
    mcl=38*rand(1,ap(so(i)).l);%随机分布距离
    mcd=2.5*rand(1,ap(so(i)).l)+0.5;%随机分布mc的需求；
    [mcl,rl]=sort(mcl);%距离排序，原有顺序是
    bufb=0;
    bufd=0;
    traffic=0;
    ll=1;%
    for j=1:ap(so(i)).l
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
%}