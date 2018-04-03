function [DSIC,BIC,OPT] = main(P,C,F,numAP,numMC,alpha) %返回总的收益；
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%涉及QoS全部采用均匀分布
packloss=[0.1,0.3,0.5,0.8,1];
latency=[0.2,0.4,0.6,0.8,1];
bandwidth=[15,40,70,90,120];
rb=[6,9,12,24,36,48,54];%wifi连接速率
store = (90*rand(1,numAP)+10)/F; %文件的存储位置大小
bid = 20*rand(1,numAP)+80;%均匀价格
%bid=11.55*randn(1,numAP)+90;%正态价格
mc = rand(1,numMC)+0.2;%mc的带宽需求分布
%mc = 0.289*randn(1,numMC)+0.7;
mc =sort(mc,'descend');
for i=1:numAP
    ap(i).b=bandwidth(randi(5));
    ap(i).h=store(i);%缓存命中率,直接从s算。
    ap(i).bid=bid(i);
    ap(i).q=alpha*latency(randi(5))+(1-alpha)*packloss(randi(5));%等待计算,QoS；
    ap(i).rb=rb(randi(7));
    ap(i).limit=min(ap(i).b/(1-ap(i).h),ap(i).rb);
    sea(i)=ap(i).bid/(ap(i).rb*(P*ap(i).q-C*(1-ap(i).h)));
end

%%{
%DSIC:
tic;
[~,soa]=sort(sea);
[payment,profit,~,y] = mcap(ap,mc,numAP,numMC,P,C,soa);
sum=0;
for i=1:numAP
    if y(i)==1
        fa=ap;
        fa(i)=[];
        sear=sea;
        sear(i)=[];
        [~,seoa]=sort(sear);
        [pay,pro,~,~] = mcap( fa,mc,numAP-1,numMC,P,C,seoa);
        p(i)=profit+pay-payment-pro;%给APi的支付；
        sum=sum+p(i);
    end
end
t1=toc;
DSIC=profit-payment-sum;
%}
%%{
%BIC:
tic;
[~,soa]=sort(sea);
[~,profit,~,~] = mcap( ap,mc,numAP,numMC,P,C,soa);
sum=0;
for i=1:numAP
    fa=ap;
    fa(i)=[];
    sear=sea;
    sear(i)=[];
    [~,seoa]=sort(sear);
    [pay,~,~,~] = mcap(fa,mc,numAP-1,numMC,P,C,seoa);
    sum=sum+pay;
    p(i)=pay;
end
for i=1:numAP
    p(i)=p(i)-(sum-p(i))/(numAP-1);
end
t2=toc;
BIC=profit;
%}
%OPT
tic;
%先计算H
[~,soa]=sort(sea);
%{
x=1;
for i=1:numAP-1
    if(sea(soa(i)) ~= sea(soa(i+1)))
        sec(soa(i)).lf=i;
        sec(soa(i)).mf=x;
        x=1;
    else
        sec(soa(i)).lf=2;
        sec(soa(i)).mf=2;
        x=x+1;
    end
end
sec(soa(numAP)).mf=x;
sec(soa(numAP)).lf=1;
for i=1:numAP-1
    if(sec(soa(numAP-i)).mf==2)
        sec(soa(numAP-i)).lf=sec(soa(numAP-i+1)).lf;
        sec(soa(numAP-i)).mf=sec(soa(numAP-i+1)).mf;
    end
end
for i=1:numAP
    sc(i)=sec(i).lf/sec(i).mf+ap(i).bid;%H
end
[~,soc]=sort(sc);
%}
[payment,profit,~,y] = mcap( ap,mc,numAP,numMC,P,C,soa);
cp=1;
for i=1:numAP
    if y(i)==1
        va(cp).c=ap(i).bid;
        va(cp).q=ap(i).q;
        cp=cp+1;
    end
end
cp=cp-1;
for i=1:cp
    sed(i)=va(i).q;
end
[~,sod]=sort(sed);
minv=99999;
maxv=0;
for i=1:cp-1
    maxv=max(va(sod(i)).c,maxv);
    minv=min(va(sod(i)).c,minv);
    va(sod(i)).lc=maxv;
    va(sod(i)).mc=minv; 
    if (va(sod(i)).q~=va(sod(i+1)).q)
        maxv=0;
        minv=99999;
    end
end
va(sod(cp)).lc=max(va(sod(cp)).c,maxv);
va(sod(cp)).mc=min(va(sod(cp)).c,minv); 
maxv=0;
minv=99999;
for i=1:cp-1
    maxv=max(va(sod(cp-i)).lc,maxv);
    minv=min(va(sod(cp-i)).mc,minv);    
    va(sod(cp-i)).lc=maxv;
    va(sod(cp-i)).mc=minv; 
    if (va(sod(cp-i)).q~=va(sod(cp-i+1)).q)
        maxv=0;
        minv=99999;
    end
end
sum=0;
for i=1:cp
    sum=sum+va(i).q*(0.5*va(i).lc*va(i).lc-0.5*va(i).c*va(i).c+va(i).c*va(i).mc-va(i).lc*va(i).mc);
    %sum=sum+va(i).q*(va(i).lc-va(i).c)*(va(i).c-va(i).mc);
end

t3=toc;
OPT=profit-payment-sum;
end
