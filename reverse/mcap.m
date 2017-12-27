function [payment,profit,x,y] = mcap(ap,mc,numAP,numMC,P,C,so)
%UNTITLED2 此处显示有关此函数的摘要
% payment为支付之和，profit为收益；ap仍是ap。
x=zeros(numMC,numAP);
y=zeros(1,numAP);
for i=1:numAP
    buf=0;
    if(sum(x(:))<numAP)
        y(i)=1;
        for j=1:numMC 
            if sum(x(j,:))<1
                if mc(j)+buf<ap(so(i)).limit
                    x(j,so(i))=1;
                    buf=buf+mc(j);
                end%容量未满；
                if buf+mc(j)==ap(so(i)).limit
                    x(j,so(i))=1;
                    continue
                end%容量正好就结束；
            end
        end
    else%如果所有的MC都已经连接，结束。
        break
    end
end
payment=0;
profit=0;
for i=1:numAP
    payment=payment+y(i)*ap(i).bid;
    traffic=0;
    for j=1:numMC 
        traffic=traffic+x(j,i)*mc(j);
    end
    profit=profit+traffic*(P*ap(i).q-C*(1-ap(i).h));%*Pap(i).q
end
end

